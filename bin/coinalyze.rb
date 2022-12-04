#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
# require 'daru'
require 'optparse'
require 'rubytools/fzf'
require 'rubytools/thread_ext'
# IO.popen("./get.rb")

def template(day)
  <<~___
    echo '1-day'
    && harry_plotter.rb {}_1.csv | tail
    && echo '#{day}-days'
    && harry_plotter.rb {}_#{day}.csv | tail
    && echo '90-days'
    && harry_plotter.rb {}_90.csv | tail
  ___
end

def summary(day, autoupdate: false, &block)
  day||=14
  if autoupdate
    th=
    Thread.new do
      loop do
        IO.popen("coingetohlc.rb", &:read)
        sleep 60*5
      end
    end
  end

  cmd=block.call(day)

  f=Dir["*9*.csv"]
    .map{|f| File.basename(f, '.*')}
    .map{|f| f.gsub(/_.+/,'')}
    .fzf_preview(cmd.gsub(/\n+/, ' '))
ensure
  if th
    puts 'waiting for thread to finish...'
    th.exit
  end
end


opts={}
OptionParser.new{|o|
  o.on('-a', '--autoupdate')
  o.on('-c', '--charts')
  o.on('-u', '--update')
  o.on('-d', '--describe')
}.parse!(into:opts)

day=ARGV.pop

case opts
in {update:true}
  puts IO.popen("coingetohlc.rb", &:read)
in {charts:true}
  puts IO.popen("plotfzf.rb", &:read)
in {autoupdate:true}
  summary(day, **opts){|day| template(day) }
in {describe:true}
  puts IO.popen("coindesc.rb", &:read)
else
  summary(day){|day| template(day) }
end
