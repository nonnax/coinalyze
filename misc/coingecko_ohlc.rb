#!/usr/bin/env ruby
# Id$ nonnax 2021-11-12 23:41:51 +0800
require 'excon'
require 'json'
require 'array_table'
require 'arraycsv'
require 'numeric_ext'
require 'cache'

coin, days=ARGV
# days = 7 unless days
res= Excon.get "https://api.coingecko.com/api/v3/coins/#{coin}/ohlc?vs_currency=php&days=#{days}"
body=JSON.parse(res.body)
data=ArrayCSV.new("#{coin}_#{days}.csv", 'w')
data<<%w[date open high low close]
body.each do |r|
  r.map!{|f| f.commify}
  r[0]=Time.at(r[0].to_i/1000)
  data<<r  
end
df=data.dataframe.dup.reverse
df.prepend %w[date open high low close]

res=Cache.cached("ohlc_#{coin}_#{days}", ttl: 60) do  
  df.to_table
end
puts res
# puts JSON.pretty_generate(body)
