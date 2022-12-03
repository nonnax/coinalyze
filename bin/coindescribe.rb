#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
require 'json'
require 'rubytools/array_table'
require 'rubytools/numeric_ext'
require 'rubytools/ansi_color'

def describe(f)
  dfbank = Daru::DataFrame.from_csv(f, header_converters: [:symbol])
  # p dfbank
  # p dfbank.describe
  rotated =
  dfbank
    .describe
    .transpose

  rotated['miav-buy'] = ((rotated[:mean]+rotated[:min])/2)
  rotated['mxav-sell'] = (rotated[:mean]+rotated[:max])/2
  rotated['mxav-gain'] = ((rotated['mxav-sell']/rotated['miav-buy'])-1)*100
  rotated['miav_s_05p'] = (rotated['miav-buy']*1.05)
  rotated['miav_s_10p'] = (rotated['miav-buy']*1.1)
  rotated['mean_delta'] = (rotated[:mean]/rotated[:max]-1)*100
  rotated['delta'] = (rotated[:min]/rotated[:max]-1)*100
  rotated['max-min'] = (rotated[:max] - rotated[:min])

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
  arr.pad_rows.to_table(delimiter: '   ')

end

def name_to_i(name)
  File.basename(name, '.*').scan(/\d+$/)&.last.to_i
end

ARGV
.sort{|a, b| name_to_i(a)<=>name_to_i(b)}
.map{|name|
  puts name.yellow
  table=describe(name)
  table.each_with_index{|r, i|
    if (i % 2).zero?
      puts r.white
    else
      puts r.green
    end
  }
  width=table.first.size
  puts ('-'*width).magenta
}
