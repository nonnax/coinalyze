#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 11:50:02
require 'thread/n_thread_array_deco'
require 'benchmark'

# using NThreadsExt

puts IO.popen("coingetohlc.rb", &:read) # try to get unless already updated

Benchmark.bm do |b|
  b.report{
    IO.popen("lstrim.rb *.csv", &:readlines)
    .map(&:chomp)
    .map{|e|
     "coinave.rb #{e}*"
    }
    .then{|arr|
     NThreadArray
     .new(arr)
     .map(threads: 8){|cmd|
       IO.popen(cmd, &:read)
     }
    }
    .map{|v|
     puts v
     puts '.'*140
    }
  }
end
# }

