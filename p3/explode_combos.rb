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
	key,values,values_freq = line.split "\t"
	values =  values.without_squirlies.values
	values_freq = values_freq.without_squirlies.values
	[values, values_freq]
end

def build_value_to_freq_hash values, freqs
	value_to_freq = {}
	values.zip(freqs).each do |vf| 
		v,f = vf
		value_to_freq[v] = f.to_f
	end
	value_to_freq
end

STDIN.each do |line|
	values, values_freq = parse_line line	
	value_to_freq = build_value_to_freq_hash values, values_freq

	value1 = values.shift
	while not values.empty?
		values.each do |value2|
			freq1 = value_to_freq[value1]
			freq2 = value_to_freq[value2]
			ratio = (freq1 > freq2) ? (freq2 / freq1) : (freq1 / freq2)
			puts [value1,value2,ratio].join "\t"
		end
		value1 = values.shift
	end

end

