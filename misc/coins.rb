#!/usr/bin/env ruby
# Id$ nonnax 2021-11-11 00:45:17 +0800
require 'excon'
require 'json'
require 'array_table'
require 'arraycsv'
require 'rover-df'

coins=%w[bitcoin ethereum bitcoin-cash litecoin ripple chainlink uniswap].join(',')
change_unit=%w[24h 7d 14d 30d].join(',')
url="https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=#{coins}&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=#{change_unit}"
res=Excon.get(url)
data=JSON.parse(res.body, symbolize_names: true)
f='coins.csv'
df=ArrayCSV.new(f, 'w')
# keys=%i[id current_price high_24h low_24h price_change_percentage_24h price_change_percentage_24h_in_currency price_change_percentage_7d_in_currency market_cap_change_percentage_24h]
keys=%i[id current_price high_24h low_24h price_change_percentage_24h price_change_percentage_30d_in_currency]
df<<keys.map{|e| 
    e.to_s
     .gsub(/change_percentage/, 'delta')
     .gsub(/in_currency/, 'php')
     .to_sym
  }
data.each do |h|
  df<< h.values_at(*keys)
end

df1=Rover.parse_csv(File.read(f), header_converters:[:symbol])
df2=Rover.parse_csv(File.read('bank1.csv'), header_converters:[:symbol])
data=df1.inner_join(df2)


require 'tempfile'
tf=Tempfile.new
tf.puts data.sort_by{|r| r[:id]}.to_csv
tf.rewind

puts IO.popen("csv_table #{tf.path}", &:read)

# puts df.to_table
  # {
    # "id": "uniswap",
    # "symbol": "uni",
    # "name": "Uniswap",
    # "image": "https://assets.coingecko.com/coins/images/12504/large/uniswap-uni.png?1600306604",
    # "current_price": 1402.77,
    # "market_cap": 729030924033,
    # "market_cap_rank": 17,
    # "fully_diluted_valuation": 1402367150446,
    # "total_volume": 21417119730,
    # "high_24h": 1402.37,
    # "low_24h": 1313.74,
    # "price_change_24h": 13.58,
    # "price_change_percentage_24h": 0.97776,
    # "market_cap_change_24h": 17339751979,
    # "market_cap_change_percentage_24h": 2.43642,
    # "circulating_supply": 519857388.1320768,
    # "total_supply": 1000000000.0,
    # "max_supply": 1000000000.0,
    # "ath": 2166.99,
    # "ath_change_percentage": -35.39362,
    # "ath_date": "2021-05-03T05:25:04.822Z",
    # "atl": 49.87,
    # "atl_change_percentage": 2707.41628,
    # "atl_date": "2020-09-17T01:20:38.214Z",
    # "roi": null,
    # "last_updated": "2021-11-10T16:45:29.636Z",
    # "price_change_percentage_14d_in_currency": 3.7780475770287003,
    # "price_change_percentage_24h_in_currency": 0.9777617243901761,
    # "price_change_percentage_30d_in_currency": 14.313710576352012,
    # "price_change_percentage_7d_in_currency": 6.135207176172046
  # }
