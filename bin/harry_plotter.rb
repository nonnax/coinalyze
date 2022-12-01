#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-27 11:26:09 +0800
# require 'rubytools/fzf'
$LOAD_PATH<<'../lib'
require_relative '../lib/cache'
require 'rubytools/ascii_plot'
require 'rubytools/array_csv'
require 'rubytools/numeric_ext'
require 'rubytools/time_and_date_ext'
# require 'rubytools/ascii_bars'
using NumericExt

f = ARGV.first
df = ArrayCSV.new(f, autosave:false)

df_dup = df.dataframe.dup
df_dup.shift
dataframe = df_dup.reverse

plot_view=[]
cache path: "plots/hplot-#{f}" do
  dataframe.plot_df do |b, r|
    [b, r[:title].to_date.strftime('%x'), r.values_at(:high, :low)]
    .flatten
    .map{|e| e.to_s.tr('_','').is_number? ? e.to_i : e } # integers make it easier to spot changes
    .map{|e| e.to_s.rjust(13) }
    .join(' ')
    .then{|s| plot_view<<s}
  end
  plot_view.join("\n")
end
.then(&method(:puts))
