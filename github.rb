require "graphql/client"
require "graphql/client/http"

# Github API example wrapper
module GHAPI
  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTPAdapter = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(context)
      {
        "Authorization" => "Bearer #{ENV["OCTO_STATS_TOKEN"]}"
      }
    end
  end

  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTPAdapter)

  Client = GraphQL::Client.new(
    schema: Schema,
    execute: HTTPAdapter
  )
end

class GithubStats
  attr_reader :close_to_limit, :pause_after

  class Queries
    TagsQuery = GHAPI::Client.parse <<-'GRAPHQL'
      query ($owner: String!, $name: String!, $first: Int!, $after: String){
         rateLimit {
          limit
          cost
          remaining
          resetAt
        }
        repository(owner: $owner, name: $name) {
          tags: refs(refPrefix: "refs/tags/", first: $first, after: $after) {
            totalCount
            pageInfo {
              hasNextPage
              endCursor
            }
            edges {
              node {
                name
                target {
                  ... on Commit {
                    author {
                      name
                      email
                      date
                    }
                  }
                }
              }
            }
          }
        }
      }
    GRAPHQL

    PullsQuery = GHAPI::Client.parse <<-'GRAPHQL'
      query ($owner: String!, $name: String!, $states: [PullRequestState!], $first: Int!, $after: String) {
         rateLimit {
          limit
          cost
          remaining
          resetAt
        }
        repository(owner: $owner, name: $name) {
          pullRequests(states: $states, first: $first, after: $after) {
            totalCount
            pageInfo {
              hasNextPage
              endCursor
            }
            edges {
              node {
                number
                merged
                createdAt
                author {
                  login
                }
              }
            }
          }
        }
      }

    GRAPHQL
  end

  # When testing or debuggin you can pause after pagination through
  # pause_after pages or if the rate limit only rate_limit remaining
  #
  def initialize(pause_after: nil, close_to_limit: nil)
    @close_to_limit = close_to_limit
    @pause_after = pause_after
  end

  def tags(owner: "IoraHealth", repo_name: "feature_toggles", first: 100, after: nil)
    variables = { owner: owner, name: repo_name, first: first, after: after }
    q(Queries::TagsQuery, "tags", variables)
  end

  def pulls(owner: "IoraHealth", repo_name: "feature_toggles", states: ["MERGED"], first: 100, after: nil)
    variables = { owner: owner, name: repo_name, states: states, first: first, after: after }
    q(Queries::PullsQuery, "pullRequests", variables)
  end

  private

  def q(query, type, variables)
    return enum_for(:q, query, type, variables) unless block_given?

    page = 0
    loop do
      print "Repo: #{variables[:name]}, Page: #{page} - "

      page = page + 1
      results = GHAPI::Client.query query, variables: variables
      data    = results.original_hash
      edges   = data['data']['repository'][type]['edges']

      log(data)
      edges.each { |edge| yield edge['node'] }
      break unless has_next_page(data)
      variables[:after] = page_info(data)['endCursor']
      pause_if_limit_reached(data, page)
    end
  end

  def page_info(original_hash)
    pulls = original_hash['data']['repository']['pullRequests']
    tags = original_hash['data']['repository']['tags']
    (pulls || tags)['pageInfo']
  end

  def has_next_page(original_hash)
    page_info(original_hash)['hasNextPage']
  end

  def limit(original_hash)
    original_hash['data']['rateLimit']
  end

  def log(original_hash)
    print page_info(original_hash)
    print " - "
    puts limit(original_hash)
  end

  def pause_if_limit_reached(original_hash, page)
    limit_info       = limit(original_hash)
    pause_after_page = pause_after && (page % pause_after == 0)
    limit_is_close   = close_to_limit && limit_info['remaining'] < close_to_limit
    reset_time       = limit_info['resetAt']
    now              = Time.now.utc

    if pause_after_page || limit_is_close
      log(original_hash)

      while Time.now.utc < reset_time do
        wait = (reset_time - now)/60
        puts "Waiting at least #{wait} minutes until reset"
        sleep 60
      end

      print "Ctrl C to cancel or to continue type: GO "
      gets "GO"
    end
  end
end
