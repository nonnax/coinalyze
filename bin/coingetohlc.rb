#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-12 23:41:51 +0800
$LOAD_PATH<<'../lib'
require 'excon'
require 'json'
require 'file/file_ext'
require 'rubytools/array_csv'
require 'rubytools/time_and_date_ext'
require 'benchmark'
require 'thread/n_threads_ext'
using NThreadsExt

def update(coin, days = 1)
  puts [coin, days].join('/')

  # days = 7 unless days
  res = Excon.get "https://api.coingecko.com/api/v3/coins/#{coin}/ohlc?vs_currency=php&days=#{days}"

  body = JSON.parse(res.body)
  # create a new object to avoid race conditions
  data = ArrayCSV.new("#{coin}_#{days}.csv", 'w', autosave: false)
  body.each do |r|
    r[0] = Time.at(r[0].to_i / 1000) # coerce String to Date
    data << r
  end

  data.dataframe =
  data
   .dataframe
   .sort{|a, b| a[0]<=>b[0]}
   .prepend %w[date open high low close]

  data.save
  sleep 1

end

coin_list = %w[ethereum bitcoin-cash chainlink litecoin ripple uniswap]

if (age=File.age("litecoin_1.csv")) > 120
  Benchmark.bm do |b|

      jobs=
      coin_list
      .map do |c|
        [1, 7, 14, 30, 90].map{|i|
          [[c, i]].to_h # avoids being flattened
        }
      end
      .flatten

      b.report{
        ThreadArray
        .new(jobs)
        .map_threads(threads: 8) do |c, i|
            update(c, i)
        end
      }
  end
else
  puts "data is up to date"
end

puts (1000*age).to_ts
