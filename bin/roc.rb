#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 16:59:13
require 'math/math_ext'
require 'file/filer'
require 'df/df_plot_ext'
using MathExt
using DFPlotExt

def ma(f, n, **params)
 st=CSVFile.new(f)
 arr = Filer.read(st).map(&:last).dup
 arr.shift
 arr.rate_change(n).last(70).each_cons(2).map.with_index{|a, i| [i, a].flatten }.plot_bars(**params) #.delta_change.map(&:to_percent).map(&:to_s)
 # arr.moving_average(n).last(70).to_series.plot_bars(**params) #.delta_change.map(&:to_percent).map(&:to_s)
end

n, scale, *files = ARGV
n ||= 11
scale ||= 4

files
 .sort{|a, b| a.scan(/\d+/).first.to_i<=>b.scan(/\d+/).first.to_i }
 .map do |f|
  puts [f, '.'*140].join
  puts ma(f, n.to_i, scale: scale.to_i)
 end
