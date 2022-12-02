#!/usr/bin/env ruby
# Id$ nonnax 2022-12-02 13:05:22
require 'rubytools/fzf'
n,=ARGV
f=Dir["*9*.csv"]
  .map{|f| File.basename(f, '.*').gsub(/_.+/,'')}
  .fzf_preview("plotpv.rb {} #{n}".strip)

