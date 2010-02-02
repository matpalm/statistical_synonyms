#!/usr/bin/env ruby

OUTFILE = ARGV[0] || 'final_res.png'

points = []
max_num, min_num = -1.0/0, 1.0/0
STDIN.each do |line|
	num,a1,a2 = line.chomp.split
	num = num.to_i
	points << [num,a1,a2]
	max_num = num if num > max_num
	min_num = num if num < min_num
end

diff = max_num - min_num
points.each do |point|
	point[0] = ((((point[0] - min_num).to_f / diff ) *4) +1).to_i
end

tmpfile = "/dev/shm/#{$$}.tmp"
tmp = File.new(tmpfile, "w")
tmp.puts "graph {"
tmp.puts 'rankdir="LR";'
points.each do |point|
	n,a1,a2 = point
	tmp.puts "\"#{a1}\" -- \"#{a2}\" [penwidth=\"#{n}\"]"
end
tmp.puts "}"
tmp.close
`dot -Tpng #{tmpfile} > #{OUTFILE}`
#`rm #{tmpfile}`

