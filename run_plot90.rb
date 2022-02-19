#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'rubytools/fzf'
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*').gsub(/_.+/,'')}
  .fzf_preview("echo '90-days' && ./harry_plotter.rb {}_90.csv && echo '30-days' && ./harry_plotter.rb {}_30.csv | tail ")
