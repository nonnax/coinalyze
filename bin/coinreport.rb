#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 11:50:02
require 'thread/n_threads_ext'
require 'benchmark'

using NThreadsExt

Benchmark.bm do |b|
  b.report{
    IO.popen("lstrim.rb *.csv", &:readlines)
    .map(&:chomp)
    .map{|e|
     "coinave.rb #{e}*"
    }
    .then{|arr|
     vals=[]
     ThreadArray.new(arr).map_threads(threads: 8){|cmd|
       vals<<IO.popen(cmd, &:read)
     }
     vals
    }
    .map{|v|
     puts v
     puts '.'*140
    }
  }
end
# }

