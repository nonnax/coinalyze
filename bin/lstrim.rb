#!/usr/bin/env ruby
# Id$ nonnax 2022-12-12 11:27:56
puts ARGV
.map{|f| File.basename(f, '.*').gsub(/[\d._]/, '')}
.uniq
.compact
.filter_map{|e| e unless e.strip.empty?}
.sort
