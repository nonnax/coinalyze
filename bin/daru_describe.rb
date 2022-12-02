#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'json'
require 'rubytools/array_table'
require 'rubytools/numeric_ext'

id, days = ARGV

id = File.basename(id, '.*')
id, days = id.split(/_/)
id.gsub!(/_.+$/, '')
days ||= 1
f = "#{id}_#{days}.csv"

dfbank = Daru::DataFrame.from_csv(f, header_converters: [:symbol])
# p dfbank
# p dfbank.describe
rotated =
dfbank
  .describe
  .transpose

rotated['max-min'] = (rotated[:max] - rotated[:min])
rotated['delta'] = (rotated[:min]/rotated[:max]-1)*100
rotated['mean_delta'] = (rotated[:mean]/rotated[:max]-1)*100
# rotated['high/mean'] = (rotated[:max] / rotated[:mean])
# rotated['low/mean'] = (rotated[:min] / rotated[:mean])

lines =
rotated
  .transpose
  .inspect
  .to_s
  .lines

lines.shift

arr =
CSV.parse(
lines
  .map(&:strip)
  .map(&:split)
  .map { |e| e.join(',') }
  .join("\n")
)

arr[0].prepend ' '
arr.map! { |e| e.prepend ' ' }

puts arr.pad_rows.to_table(delimiter: '   ')
