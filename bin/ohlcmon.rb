#!/usr/bin/env ruby
# Id$ nonnax 2022-12-16 00:53:13
require 'file/file_ext'
require 'fiber/fiber_tags'
require 'rubytools/time_ext'
require_relative '../lib/argv_sorted'

# using TimeExt

coins=argv_sorted
fail 'ohlcmon.rb <name>' if coins.empty?
days='1,180'
days=coins.pop if coins.last.match?(/\d/)

delta_value ||= 5

def monitor(delta_value=5)
 IO.popen("coingetohlc.rb", &:read) if File.age('litecoin_1.csv') > 60*5
 sleep 0.5
 IO.popen("watchy.rb", &:read)
 puts IO.popen(format("coinread.rb %s", delta_value), &:read)
end

def plot(coin, *days)
  fnames = days.map{|d| "#{coin}*#{d}.csv" }
  fnames.each do |f|
    puts IO.popen("harry_plotter.rb #{f}", &:read)
    puts IO.popen("ma.rb 11 10 #{f}", &:read)
  end
end

def watch(coin)
  puts IO.popen("coinwatch.rb #{coin}", &:read)
end

# first run
monitor
coins.each do |coin|
  plot(coin, *days.split(/,/))
  watch(coin)
end

FiberTags.new do
 _every 5.minutes do
  monitor
 end

 coins.each do |coin|
  _every 5.minutes do
   watch(coin)
  end
 end

 coins.each do |coin|
  _every 5.minutes do
   plot(coin, *days.split(/,/))
  end
 end

end
