#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
# require 'daru'
require 'rubytools/fzf'
# IO.popen("./get.rb")
center,=ARGV
center||=14

cmd=<<~___
echo '1-day'
&& harry_plotter.rb {}_1.csv | tail
&& echo '#{center}-days'
&& harry_plotter.rb {}_#{center}.csv | tail
&& echo '90-days'
&& harry_plotter.rb {}_90.csv | tail
___
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*')}
  .map{|f| f.gsub(/_.+/,'')}
  .fzf_preview(cmd.gsub(/\n+/, ' '))
