#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 16:59:13
require 'file/filer'
require 'df/df_plot_ext'
using DFPlotExt

def calc(m, f, n, **params)
 st=CSVFile.new(f)
 arr = Filer.read(st).map(&:last).dup
 arr.shift
 arr.send(m, n).last(70).each_cons(2).map.with_index{|a, i| [i, a].flatten }.plot_bars(**params)
end

def roc(f, n, **params)
 calc(:rate_change, f, n, **params)
end

def ma(f, n, **params)
 calc(:moving_average, f, n, **params)
end

class Array
 def self_array(n)
   each_cons(n).map(&:last).flatten
 end
end

def plain(f, n, **params)
 calc(:self_array, f, n, **params)
end

n, scale, *files = ARGV
n ||= 11
scale ||= 4

files
 .sort{|a, b| a.scan(/\d+/).first.to_i<=>b.scan(/\d+/).first.to_i }
 .map do |f|
  puts [f, '.'*140].join
  puts 'plain'
  puts plain(f, n.to_i, scale: scale.to_i)
  puts 'moving ave'
  puts ma(f, n.to_i, scale: scale.to_i)
  puts 'rate of change'
  puts roc(f, n.to_i, scale: scale.to_i)
 end
