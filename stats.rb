require 'csv'
require 'time'
require './github.rb'

class Stats
  attr_reader :repo_names, :owner, :github_stats
  DEFAULT_REPOS_FILE="default_repos.txt"

  def initialize(owner: "IoraHealth", repo_names: nil)
    @github_stats = GithubStats.new
    @owner = owner
    if File.file?(DEFAULT_REPOS_FILE)
      default_repos = File.readlines(DEFAULT_REPOS_FILE).map(&:chomp)
    end
    @repo_names = repo_names || default_repos
  end

  def self.to_csv(enum, file_path)
    CSV.open(file_path, 'w') do |csv_object|
      enum.each { |item| csv_object << item }
    end
  end

  def export(path)
    Stats.to_csv(pulls, "#{path}/pulls.csv")
    Stats.to_csv(tags, "#{path}/tags.csv")
  end

  def tags
    return enum_for(:tags) unless block_given?

    yield ["year", "quarter", "month", "commit_at", "name", "login", "tag_name"]

    repo_names.each do |name|
      github_stats.tags(owner: owner, repo_name: name).each do |tag|
        tag_name = "#{name}_#{tag['name']}"
        author   = tag['target']['author'] || tag['target']['target']['author']
        date     = parse_time author['date']

        yield [date[:year], date[:quarter], date[:month], date[:time], name, author['name'], tag_name]
      end
    end
  end

  def pulls(states=["MERGED"])
    return enum_for(:pulls, states) unless block_given?

    yield ["year", "quarter", "month", "created_at", "name", "login", "number"]

    repo_names.each do |name|
      github_stats.pulls(owner: owner, repo_name: name, states: states).each do |pull|
        number = pull['number']
        login  = pull['author']['login']
        date   = parse_time pull['createdAt']

        yield [date[:year], date[:quarter], date[:month], date[:time], name, login, number]
      end
    end
  end

  def parse_time(time_string)
    time    = Time.parse time_string
    year    = time.year
    month   = time.month
    quarter = ((month - 1) / 3) + 1

    {time: time.strftime("%Y-%m-%d"), year: year, quarter: "#{year}-#{quarter}", month: "#{year}-#{month}"}
  end
end
