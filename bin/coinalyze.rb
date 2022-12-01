#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
# require 'daru'
require 'rubytools/fzf'
require 'rubytools/thread_ext'
# IO.popen("./get.rb")
arg,=ARGV
th=nil
if arg && arg.to_i.zero?
  th=Thread.new do
    loop do
      IO.popen("coingetohlc.rb", &:read)
      sleep 60*5
    end
  end
  arg=nil
end

arg||=14

cmd=<<~___
echo '1-day'
&& harry_plotter.rb {}_1.csv | tail
&& echo '#{arg}-days'
&& harry_plotter.rb {}_#{arg}.csv | tail
&& echo '90-days'
&& harry_plotter.rb {}_90.csv | tail
___
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*')}
  .map{|f| f.gsub(/_.+/,'')}
  .fzf_preview(cmd.gsub(/\n+/, ' '))

puts 'waiting for thread to finish...'
th.exit if th
