#!/usr/bin/env ruby
# ((x1,y1),{(a),(b),(d)},{(2L),(1L),(2L)})

class String
	def without_squirlies
		self =~ /\{(.*)\}/ && $1
	end
	def values
		self.split(',').collect{|v| v =~ /^\((.*)\)$/ && $1 }
	end
end

def parse_line line
	key,values = line.split "\t"
	values.without_squirlies.values
end

STDIN.each do |line|
	values = parse_line line	
	value1 = values.shift
	while not values.empty?
		values.each do |value2|
			puts "#{value1}\t#{value2}"
		end
		value1 = values.shift
	end

end

