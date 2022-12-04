#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'json'
require 'rubytools/array_table'
require 'rubytools/numeric_ext'
require 'rubytools/ansi_color'

id, days = ARGV

id = File.basename(id, '.*')
id, days = id.split(/_/)
id.gsub!(/_.+$/, '')
days ||= 1
f = "#{id}_#{days}.csv"

dfbank = Daru::DataFrame.from_csv(f, header_converters: [:symbol])
# p dfbank
# p dfbank.describe.transpose

rotated =
dfbank
  .describe
  .transpose

rotated['mimx-delta'] = (rotated[:min]/rotated[:max]-1)*100
rotated['miav-buy'] = ((rotated[:mean]+rotated[:min])/2)
rotated['mxav-sell'] = (rotated[:mean]+rotated[:max])/2
rotated['mxav-gain'] = ((rotated['mxav-sell']/rotated['miav-buy'])-1)*100
rotated['sell_5p'] = (rotated['miav-buy']*1.05)
rotated['sell_10p'] = (rotated['miav-buy']*1.1)
# rotated['mean_delta'] = (rotated[:mean]/rotated[:max]-1)*100
# rotated['max-min'] = (rotated[:max] - rotated[:min])
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
