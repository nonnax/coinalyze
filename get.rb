#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-12 23:41:51 +0800
require 'excon'
require 'json'
require 'rubytools/array_table'
require 'rubytools/array_csv'

def update(coin, days = 1)
  # days = 7 unless days
  res = Excon.get "https://api.coingecko.com/api/v3/coins/#{coin}/ohlc?vs_currency=php&days=#{days}"

  body = JSON.parse(res.body)
  data = ArrayCSV.new("#{coin}_#{days}.csv", 'w')
  body.each do |r|
    r[0] = Time.at(r[0].to_i / 1000)
    data << r
  end

  data.dataframe = data
                   .dataframe
                   .sort
                   .reverse

  data
    .dataframe
    .prepend %w[date open high low close]

  data.save
end

coin_list = %w[bitcoin-cash chainlink litecoin ripple uniswap]

coin_list.each_with_index do |c, i|
  t = []
  [1, 7, 30, 90].each do |i|
    t << Thread.new do
      update(c, i)
      sleep 0.5
    end
  end
  t.map(&:join)
  print "#{[i + 1, coin_list.size].join('/')}\r"
end
