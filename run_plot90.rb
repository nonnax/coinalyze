#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'rubytools/fzf'
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*').gsub(/_.+/,'')}
  .fzf_preview("./harry_plotter.rb {}_90.csv && echo  && echo '30-days' && echo && ./harry_plotter.rb {}_30.csv | tail ")
