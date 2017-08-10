require './stats.rb'

stats = Stats.new
Stats.to_csv(stats.pulls, "./pulls.csv")
Stats.to_csv(stats.tags, "./tags.csv")
