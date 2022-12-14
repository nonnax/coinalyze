#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-27 11:26:09 +0800
# require 'rubytools/fzf'
$LOAD_PATH<<'../lib'
require_relative '../lib/cache'
require_relative '../lib/argv_sorted'
require 'rubytools/array_csv'
require 'rubytools/numeric_ext'
require 'rubytools/time_ext'
require 'file/file_ext'
require 'ascii_plot/array_plot_ext'

using ArrayPlotExt

using NumericExt


def plot(f)
  exit unless f
  puts f
  timeout=15
  timeout=0 if File.age(f) > 60

  df = ArrayCSV.new(f, autosave:false)

  df_dup = df.dataframe.dup
  df_dup.shift # remove header
  dataframe = df_dup#.reverse

  def daystamp
    Time.now.strftime("%Y%m%d")
  end

  cache timeout: timeout, path: "plots/hp-#{daystamp}-#{f}" do
   dataframe.last(80).plot_candlestick(scale: 100/10)
  end
  .then(&method(:puts))
  puts
end

argv_sorted.each(&method(:plot))
