#!/usr/bin/env ruby -wKU

z = Array.new
f = File.new(ARGV[0])
text = f.readlines
text.each do |line|
  if line.match(/http:\/\/sports.yahoo.com\/mlb\/players\/(\d+?)\"/)
    puts "#{ARGV[1]},#{$1}"
    z << $1
  end
end

puts "#{z.join(',')}"