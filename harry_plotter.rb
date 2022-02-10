#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-27 11:26:09 +0800
# require 'rubytools/fzf'
require 'rubytools/ascii_plot'
require 'rubytools/array_csv'
require 'rubytools/numeric_ext'
require 'rubytools/time_and_date_ext'
require 'rubytools/ascii_bars'

f = ARGV.first
df = ArrayCSV.new(f)

df_dup = df.dataframe.dup
df_dup.shift
dataframe = df_dup.reverse

# t=[]
dataframe.plot_df do |b, r|
  # t<<Thread.new(b, r) do |b, r|
  puts [b, r.values_at(:title).first.to_date.strftime('%x'), r.values_at(:high, :low)]
  # hbars << [b, r.values_at(:title).first.to_date.strftime('%x'), r.values_at(:high, :low)]
    .flatten
    .map { |e| e.to_s.rjust(10) }
    .join(' ')
  # end
end

# t.map(&:join)
