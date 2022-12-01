#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'rubytools/fzf'
p IO.popen("./get.rb", &:read)
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*').gsub(/_.+/,'')}
  .fzf_preview("./get.rb 1>/dev/null && echo '1-day' && ./harry_plotter.rb {}_1.csv | head && echo '30-days' && ./harry_plotter.rb {}_30.csv | tail && coins")
