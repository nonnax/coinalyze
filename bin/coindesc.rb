#!/usr/bin/env ruby
# Id$ nonnax 2021-11-12 23:53:26 +0800
# require_relative 'coingecko_ohlc'
require 'rubytools/fzf'

def cmd
  s=<<~___
  coinwatch.rb {}
  && harry_plotter.rb {}_7.csv | tail -n10
  && echo 1
  && daru_describe.rb {}_1.csv
  && echo 14
  && daru_describe.rb {}_14.csv
  && echo 30
  && daru_describe.rb {}_30.csv
  && echo 90
  && daru_describe.rb {}_90.csv
  ___
  s.gsub(/\n+/, ' ')
end

%w[bitcoin-cash litecoin chainlink ripple uniswap].fzf_preview(cmd)
