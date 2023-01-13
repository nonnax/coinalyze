#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-12 23:41:51 +0800
$LOAD_PATH<<'../lib'
require 'faraday'
require 'file/file_ext'
require 'rubytools/time_ext'
require 'benchmark'
require 'coingecko/ohlc'

coin,=ARGV
coin_list = %w[avalanche-2 bitcoin ethereum dogecoin chainlink]+[coin || 'bitcoin']

if [File.age("ethereum_1.csv"), File.age("#{coin}_1.csv")].all?{|age| age > 120}
  Benchmark.bm{|b|
    b.report{Coingecko.get_ohlc(days: [1, 180]){ coin_list.uniq }}
  }
else
  puts "data is up to date"
end

# puts (1000*age).to_ts
