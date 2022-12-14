#!/usr/bin/env ruby
# Id$ nonnax 2022-12-02 17:20:06
module Config
 def data_path(f, dir: 'data/')
  File.join(dir, f)
 end
 def plot_path(f, dir: 'plot/')
  File.join(dir, f)
 end
end
