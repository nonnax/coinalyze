#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-12 23:41:51 +0800
$LOAD_PATH<<'../lib'
require 'faraday'
require 'json'
require 'file/file_ext'
require 'rubytools/array_csv'
require 'rubytools/time_ext'
require 'benchmark'
require 'coingecko/ohlc'

coin_list = %w[ethereum bitcoin-cash chainlink litecoin ripple uniswap]

if (age=File.age("litecoin_1.csv")) > 120
  Benchmark.bm{|b|
    b.report{Coingecko.get_ohlc{ coin_list }}
  }
else
  puts "data is up to date"
end

puts (1000*age).to_ts
