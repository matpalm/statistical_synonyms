#!/usr/bin/env ruby

OUTFILE = ARGV[0] || 'final_res.png'
tmpfile = "/dev/shm/#{$$}.tmp"
tmp = File.new(tmpfile, "w")
tmp.puts "graph {"
tmp.puts 'rankdir="LR";'
STDIN.each do |line|
	num,a1,a2 = line.chomp.split
	tmp.puts "\"#{a1}\" -- \"#{a2}\""
# [penwidth="4"]

end
tmp.puts "}"
tmp.close
`dot -Tpng #{tmpfile} > #{OUTFILE}`
#`rm #{tmpfile}`

