#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 10:09:47
require 'file/filer'
require 'df/df_ext'
require 'rubytools/numeric_ext'
using DFExt

def ave(f)
 st=CSVFile.new(f)
 c=Filer.read(st)

 c.transpose.group_by(&:shift).transform_values(&:flatten).filter_map do |k, v|
  [k, v.inject(:+)/v.size.to_f] unless k.match?(/date/)
 end

rescue
  return
end

begin
ARGV
.sort{|a, b| a.scan(/\d+/).first.to_i<=>b.scan(/\d+/).first.to_i}
.map{ |f| [[File.basename(f,'.*'), ave(f).to_h]].to_h }
.inject({}){|acc, h| acc.merge(h.transform_values(&:values))}
.map{|k, v|
  [k, v<<v.sum/v.size.to_f]
}.to_h
.to_flat_array
.to_balanced_array
.then{|arr| arr.prepend(%w[coin open high low close average])}
.transpose
.tap{|arr|
  first=arr.shift+['average']
  arr.map{|r|
    name=r.shift
    v=r.sum/r.size.to_f rescue nil
    r.prepend(name)
    r<<v
    r
  }
  arr.prepend(first)
}
.to_table
.then(&method(:puts))

rescue=>e
  puts 'coinave.rb <glob>'
  puts e.backtrace
end
