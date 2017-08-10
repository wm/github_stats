# git_stats
Pull some statistics from GH

## Configuration

### Access to Github's API

Before starting you will need to set your token to access the github API

`export OCTO_STATS_TOKEN=<YOUR TOKEN HERE>`

see [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) for how to get a token from Github.

### Setting the repositories you want stats for

You may also place a list of repos you want to pull stats on in a file called
`default_repos.txt`. This file should be in the CWD. Each line of the file
should be a repo name.

## Interactive with irb

You can use this simply in irb as follows

```ruby
$ irb -r ./github.rb -r ./stats.rb

irb(main):003:0> pulls = Stats.new(owner: 'IoraHealth', repo_names: ['braise']).pulls
=> #<Enumerator: #<Stats:0x007f9896b58610 @github_stats=#<GithubStats:0x007f9896b585c0 ...>
irb(main):004:0> pulls.next
=> ["year", "quarter", "month", "created_at", "name", "login", "number"]
irb(main):005:0> pulls.next
Repo: braise, Page: 0 - {"hasNextPage"=>false, "endCursor"=>"Y3Vyc29yOnYyOpHOCAqsVw=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4996, "resetAt"=>"2017-08-10T04:45:09Z"}
=> [2015, "2015-1", "2015-1", "2015-01-28", "braise", "patricksrobertson", 1]
irb(main):006:0> pulls.next
=> [2015, "2015-1", "2015-1", "2015-01-28", "braise", "patricksrobertson", 2]
irb(main):007:0> pulls.next
=> [2015, "2015-1", "2015-2", "2015-02-02", "braise", "patricksrobertson", 3]
```

```ruby
irb(main):010:0* tags = Stats.new(owner: 'IoraHealth', repo_names: ['braise']).tags
=> #<Enumerator: #<Stats:0x007f9895841090 @github_stats=#<GithubStats:0x007f9895841040 ...>
irb(main):011:0> tags.next
=> ["year", "quarter", "month", "commit_at", "name", "login", "tag_name"]
irb(main):012:0> tags.next
Repo: braise, Page: 0 - {"hasNextPage"=>false, "endCursor"=>"Ng=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4995, "resetAt"=>"2017-08-10T04:45:09Z"}
=> [2016, "2016-1", "2016-1", "2016-01-11", "braise", "Patrick Robertson", "braise_0.1.0"]
irb(main):013:0> tags.next
=> [2016, "2016-1", "2016-2", "2016-02-01", "braise", "Patrick Robertson", "braise_0.3.0"]
```

Note that it prints out the pagination and rate limit information to the screen

## Exporting all stats to csv

To export stats from Github run the command: `ruby execute.rb`

### Sample output

```
$ ruby execute.rb
Repo: growth-charts,           Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ/Nyg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4988, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: model_broadcast,         Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJNAww=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4987, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: delorean_client,         Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ0jOw=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4986, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: iora_logging,            Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJy17g=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4985, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: event_publisher,         Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJEBaQ=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4984, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: fredette,                Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJuYDQ=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4983, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: encounter-documentation, Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ6gcQ=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4982, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: chirp-nav-bar,           Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJK73Q=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4981, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: burgundy,                Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ1DgQ=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4980, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: bobsled,                 Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJeC8w=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4979, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: dosespot,                Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJQ7xg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4978, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: bci-services,            Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ9Qlg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4977, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: iora_deployment,         Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ3dEg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4976, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: resque-chalk,            Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ1IiA=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4975, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: patient_log_service,     Page : 0 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJ3Omg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4974, "resetAt"=>"2017-08-10T03:44:12Z"}
...
Repo: icis_patients,           Page : 0 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJgVA=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4938, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: icis_patients,           Page : 1 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJqug=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4937, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: icis_patients,           Page : 2 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJ5EA=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4936, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: icis_patients,           Page : 3 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJVRA=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4935, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: icis_patients,           Page : 4 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJ+ZQ=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4934, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: icis_patients,           Page : 5 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJ8jg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4933, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: icis_patients,           Page : 6 - {"hasNext Page "=>false, "endCursor"=>"Y3VycABCDEFGHIJrMSg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4932, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: IoraHealth,              Page : 0 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJbKw=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4931, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: IoraHealth,              Page : 1 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJkmg=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4930, "resetAt"=>"2017-08-10T03:44:12Z"}
Repo: IoraHealth,              Page : 2 - {"hasNext Page "=>true,  "endCursor"=>"Y3Vyc2ABCDEFGHIJT5w=="} - {"limit"=>5000, "cost"=>1, "remaining"=>4929, "resetAt"=>"2017-08-10T03:44:12Z"}
...
```

The above output is the pagination and rate limit information. The data will be written to pulls.csv and tags.csv in the CWD.
