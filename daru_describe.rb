#!/usr/bin/env ruby
# Id$ nonnax 2021-11-13 00:07:03 +0800
require 'daru'
id, days=ARGV
id=File.basename(id, ".*")
id, days=id.split(/_/)
id.gsub!(/_.+$/,'')
days ||= 1
f="#{id}_#{days}.csv"
dfbank=Daru::DataFrame.from_csv(f, header_converters:[:symbol])
# p dfbank
# p dfbank.describe
rotated=dfbank.describe.transpose
rotated['max-min']=(rotated[:max]-rotated[:min])
rotated['high/mean']=(rotated[:max]/rotated[:mean])
rotated['low/mean']=(rotated[:min]/rotated[:mean])
p rotated.transpose
