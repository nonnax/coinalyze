#!/usr/bin/env ruby
# Id$ nonnax 2022-12-15 00:15:39

def filename_to_i(f)
 f.scan(/\d+/).first.to_i
end

def argv_sorted
 ARGV.sort{|a, b| filename_to_i(a)<=>filename_to_i(b)}
end
