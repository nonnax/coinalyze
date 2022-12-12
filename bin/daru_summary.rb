#!/usr/bin/env ruby
# Id$ nonnax 2022-12-04 20:12:55
require 'file/filer'
require 'daru'
require 'rubytools/numeric_ext'
require 'json'
require 'df/df'
require 'df/df_ext'
using DFExt

Filer.read(MarshalFile.new 'darudesc.mar').map.with_index{|(k, df), i|
 # pp df.methods.sort.each_slice(5).to_a if i.zero?
 [[k, df[:min, :mean, :max].transpose['close'].to_a]].to_h
}
.inject({}){|acc, h|
 acc.merge!(h)
 acc
}
.map{|a| a.flatten}
.inject([]){|df, a|
 df<<a
}
.then{|df| DF.new{df} }
.then{|df| df[1,2]{|a, b| (b+a)/2 if [a, b].all?} }
.then{|df| df[2,3]{|a, b| (b+a)/2 if [a, b].all?} }
# .then{|df| puts df.to_s}
.tap{|df| puts df.to_s(index:true, columns: %w[id min mean max minmean meanmax])}
.then{|df|

 puts df
   .to_a
   .group_by{|k| k.shift.scan(/[\D-]+/).first }
   .transform_values(&:flatten)
   .map{|k, v| [k, v.inject(:+)/v.size.to_f] rescue [0, 0] }
   .to_balanced_array
   .to_table
}
# .then(&JSON.method(:pretty_generate))
# .then(&method(:puts))

