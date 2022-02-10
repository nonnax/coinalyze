#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'rubytools/fzf'
f=Dir["*.csv"].fzf_preview("./daru_describe.rb {} 7")
