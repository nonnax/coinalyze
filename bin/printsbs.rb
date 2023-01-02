#!/usr/bin/env ruby
# Id$ nonnax 2022-12-20 18:24:32
require 'rubytools/console_ext'
require 'rubytools/core_ext'
require 'fiber/fiber_tags'
using CoreExt

# FiberTags makes alternate looping code simple and clean

fa, fb, width = ARGV
width ||= 90
width = width.to_i

_x, width = winsize unless width

lines_a=File.readlines(fa, chomp:true)
lines_b=File.readlines(fb, chomp:true)

def make_same_height(lines_a, lines_b)
  # when one file is longer than the other
  # pad to make their heights the same

  short = lines_a.size <=> lines_b.size
  diff = (lines_a.size - lines_b.size).abs

  if short.negative?
    lines_a+=Array.new(diff){' '}
  else
    lines_b+=Array.new(diff){' '}
  end
  [lines_a, lines_b]
end

lines_a, lines_b = make_same_height(lines_a, lines_b)

divider=Array.new(lines_a.size){"\t"}
newlines=Array.new(lines_a.size){"\n"}

def print_trim(l, width)
  print l.split(//).take(width).join.ljust(width)
end

FiberTags.new do

  each lines_a do |l|
   print_trim l, width
  end

  each divider do |div|
   print div
  end

  each lines_b do |l|
   print_trim l, width
  end

  each newlines do |sp|
   print sp
  end
end


