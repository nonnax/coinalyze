#!/usr/bin/env ruby
# Id$ nonnax 2022-11-28 15:39:45
require 'file/file_ext'

def cache(timeout:30, path:'/tmp/coinalyze.csv',  &block)
  Dir.mkdir File.dirname(path)  unless Dir.exist?(File.dirname(path))
    # File.write(path, '')
    # return 999_999
  # end
  if File.age(path) > timeout
    block
    .call
    .tap{|s| File.write path, s.to_s}
  else
    File.read(path)
  end
end
