#!/usr/bin/env ruby
# Id$ nonnax 2021-11-12 23:53:26 +0800
# require_relative 'coingecko_ohlc'
require 'rubytools/fzf'

%w[bitcoin-cash litecoin chainlink ripple uniswap]
  .fzf_preview('csview.rb {+}_1.csv | head -5 && csview.rb {+}_7.csv | head -5 && csview.rb {+}_90.csv | head -5   && ./daru_describe.rb {} 1')
