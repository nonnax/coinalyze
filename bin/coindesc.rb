#!/usr/bin/env ruby
# Id$ nonnax 2021-11-12 23:53:26 +0800
# require_relative 'coingecko_ohlc'
require 'rubytools/fzf'

%w[bitcoin-cash litecoin chainlink ripple uniswap]
  .fzf_preview('harry_plotter.rb {}_1.csv | tail -n14 && echo 1 && daru_describe.rb {}_1.csv && echo 90 && daru_describe.rb {}_90.csv')
