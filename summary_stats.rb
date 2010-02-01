#!/usr/bin/env ruby
class A1A2

	def initialize a1,a2
		@a1=a1; @a2=a2
		@weights = []
		@xy_weights = []
		@num_weights = @total_xy_weight = @total_weight = 0
	end

	def add_weights xy_weight, weight
		@xy_weights << xy_weight
		@weights << weight
		@total_xy_weight += xy_weight
		@total_weight += weight
		@num_weights += 1		
	end

	def dump
		average_xy_weight = @total_xy_weight/@num_weights
		average_weight = @total_weight/@num_weights
		printf "%s\t%s\t%d\t%0.20f\t%0.20f\t%0.5f\t%0.5f\n", @a1, @a2, @num_weights, @total_xy_weight, average_xy_weight, @total_weight, average_weight
	end

end

a1a2s = {}
STDIN.each do |line|
	x,x_freq, y,y_freq, a1,a1_freq, a2,a2_freq, a1a2_weight = line.split("\t")
	a1a2s[[a1,a2]] ||= A1A2.new a1,a2
	a1a2s[[a1,a2]].add_weights x_freq.to_f*y_freq.to_f, a1a2_weight.to_f
end

a1a2s.values.each { |a1a2| a1a2.dump }
