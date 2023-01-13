#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 10:09:47
require 'file/filer'
require 'df/df_ext'
# require 'rubytools/core_ext'
require 'rubytools/numeric_ext'
require 'math/math_ext'
using DFExt
# using CoreExt
using MathExt
using NumericExt

def ave(f)
 st=CSVFile.new(f)
 df=Filer.read(st)

 df
 .transpose
 .group_by(&:shift)
 .transform_values(&:flatten)
 .filter_map do |k, v|
  [k, v.mean] unless k.match?(/date/)
 end

rescue
  return
end

begin
ARGV
.sort{|a, b| a.scan(/\d+/).first.to_i<=>b.scan(/\d+/).first.to_i}
.map{ |f| [[File.basename(f,'.*'), ave(f).to_h]].to_h }
.inject({}){|acc, h| acc.merge(h.transform_values(&:values))} # get values of inner hash
.map{|k, v| [k, v<<v.mean] } # simple ave, 4-decimal
.to_h
.to_flat_array
.reshape
.then{|arr| arr.prepend %w[coin open high low close mean] }
.transpose
.tap{|arr|
  h, *t=arr
  h+=['mean']
  t.map!{|r|
    head, *tail= r
    # v=(tail.sum/tail.size.to_f).to_s(4) rescue nil
    v=tail.mean rescue nil
    tail<<v
    [head]+tail
  }
  [h]+t
}
.map{|r|
  r.map{|r| r.numeric? && r<1 ? r.human(5) : r.human }
}
.to_table
.then(&method(:puts))

# rescue=>e
  # puts 'coinave.rb <glob>'
  # puts e.backtrace
end
