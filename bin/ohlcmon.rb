#!/usr/bin/env ruby
# Id$ nonnax 2022-12-16 00:53:13
require 'file/file_ext'
require 'fiber/fiber_tags'
require 'rubytools/time_ext'
require_relative '../lib/argv_sorted'

# using TimeExt

coinstr, delta_value=argv_sorted

delta_value ||= 5

def monitor(coinstr, delta_value=5)
 IO.popen("coingetohlc.rb", &:read) if File.age('litecoin_1.csv') > 60*5
 puts IO.popen(format("coinread.rb %s", delta_value.to_i), &:read)
 puts IO.popen("harry_plotter.rb #{coinstr}*.csv", &:read)
end

# first run
monitor(coinstr, delta_value)

FiberTags.new do
 _every 5.minutes do
  monitor(coinstr, delta_value)
 end
end
