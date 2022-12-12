#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 11:36:18
cmd="lstrim.rb *.csv | fzf --preview 'coinave.rb {}* && ma.rb 11 6 {}*'"

puts IO.popen(cmd, &:read)
