#!/usr/bin/env ruby
# Id$ nonnax 2022-12-02 12:43:44
coin,n=ARGV

n||=10

names=
Dir["plots/h*#{coin}*"]
.select{|f| f.match?(/\d/)}
.reject{|f| f.match?(/14/)}
.sort{|a, b| a.scan(/\d+\./)[0].to_i<=>b.scan(/\d+\./)[0].to_i}

names
.map{|f| File.read(f).lines.last(n.to_i)}
.map{|a| a.join }
.then{|arr| names.map{|f| File.basename(f, '.*')}.zip(arr).to_h}
.map{|k, v| puts [k.gsub(/hp-\d+/,''), v].join("\n")}
