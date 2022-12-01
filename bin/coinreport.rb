#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
# require 'daru'
require 'rubytools/fzf'
# IO.popen("./get.rb")
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*')}
  .map{|f| f.gsub(/_.+/,'')}
  .fzf_preview("echo '1-day' && bin/harry_plotter.rb {}_1.csv | tail && echo '7-days' && bin/harry_plotter.rb {}_7.csv | tail -n 22")
  # .fzf_preview("echo '1-day' && ./harry_plotter.rb {}_1.csv | tail && echo '30-days' && ./harry_plotter.rb {}_30.csv | tail && echo '90-days' && ./harry_plotter.rb {}_90.csv | tail -n 20")
