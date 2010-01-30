#!/usr/bin/env ruby
require 'set'

# prototype for stat syn in ruby
# heavy use of of lists over hashes to mirror 
# pig data structures

def new_freq_hash
	hash = {}
	hash.default = 0
	hash
end

def slurp iter
	result = []
	iter.each { |line| result << line.chomp }
	result
end

def build_freq_table lines
	total_num_terms = 0
	freq = new_freq_hash
	lines.each do |line|
		line.split(' ').each do |word|
			freq[word] += 1
			total_num_terms += 1
		end
	end
	freq.keys.each do |key|
		freq[key] = freq[key].to_f / total_num_terms
	end
	freq
end

def build_n_grams lines, n_gram_size
	n_grams = []
	lines.each do |line|
		words = line.split ' '
		non_blank_words = words.select { |word| !word.empty? }
		next unless non_blank_words.size >= n_gram_size
		n_gram = []
		n_gram_size.times { n_gram << non_blank_words.shift }
		n_grams << n_gram.clone
		while !non_blank_words.empty?
			n_gram.shift
			n_gram << non_blank_words.shift
			n_grams << n_gram.clone
		end
	end
	n_grams
end

def build_n_grams_freq n_grams
	freq = new_freq_hash
	n_grams.each { |n_gram| freq[n_gram] += 1 }
	freq
end

def uniq_xy_pairs n_grams_freq
	uniq_xy = Set.new
	n_grams_freq.keys.each do |ngram|
		x,a,y = ngram
		uniq_xy << [x,y]
	end
	uniq_xy
end

# calculate xy_weights hash 
# (also rescaled to 0.0001 -> 1) 
# { [:x1,:x1] => 0.5, 
#   [:x2,:y2] => 0.2 }
def build_normalised_xy_weights_from uniq_xy_pairs, freq
	weights = {}
	min,max = 1.0/0, -1.0/0
	uniq_xy_pairs.each do |tuple|
#		puts tuple.inspect
		x,y = tuple
		weight = freq[x] * freq[y]
#		puts "x=#{x} y=#{y}"
		weights[[x,y]] = weight
		min = weight if weight < min
		max = weight if weight > max
#		puts "weight=#{weight} min=#{min} max=#{max}"
	end
	diff = max - min
	weights.keys.each do |key|
		weights[key] = (weights[key] - min) / diff		
	end
	weights
end

def build_middle_values n_grams_freq
	middle_values = {} 	
	n_grams_freq.each do |ngram,freq|
		x,a,y = ngram
		middle_values[[x,y]] ||= new_freq_hash
		middle_values[[x,y]][a] += freq 
	end
	middle_values
end

def remove_uniq_middle_values middle_values_hash
	middle_values_non_unique = []
	middle_values_hash.each do |pair,middle_values|
		next if middle_values.size == 1
		middle_values_non_unique << [pair,middle_values]
	end
end

def explode_combos_for middle_value
	result = []
	middle_value.each do |pair, middle_values|
		x, y = pair
		middle_values_terms = middle_values.keys.sort
		a1 = middle_values_terms.shift
		a1_freq = middle_values[a1]
		while !middle_values_terms.empty? do
			middle_values_terms.each do |a2|
				a2_freq = middle_values[a2]
				a1a2_relative_freq = a1_freq.to_f / a2_freq
				a1a2_relative_freq = 1/a1a2_relative_freq if a1a2_relative_freq>1
				result << [x,y,a1,a2,a1a2_relative_freq]	
			end
			a1 = middle_values_terms.shift
			a1_freq = middle_values[a1]
		end
	end
	result
end

# [x1,y1,a1,a2,0.25]
A1A2_WEIGHT_PROPORTION = 0.5#.7
XY_WEIGHT_PROPORTION = 0.5 #- A1A2_WEIGHT_PROPORTION
def combined_weights_for exploded_combos, normalised_xy_weights
#	exploded_combos.collect do |combo|    # on large datasets when just puts this blows things up
	exploded_combos.each do |combo|
		x,y,a1,a2,a1a2_weight = combo
		xy_weight = normalised_xy_weights[[x,y]]
#		combined_weight = (a1a2_weight * A1A2_WEIGHT_PROPORTION) * (xy_weight * XY_WEIGHT_PROPORTION)
		puts [x,y,xy_weight,a1,a2,a1a2_weight,].join("\t")
#		[a1, a2, combined_weight]
	end
end

#--------------------------------------------------------------

# read all lines of standard
lines = slurp STDIN

# build normalised freq table of terms
# { :x1 => 0.015, :y2 => 0.0001 }
term_freq = build_freq_table lines
#puts "FREQ #{freq.inspect}"

# expand text in 3grams and 
# [ [:x1, :a1, :x2], 
#   [:x2, :a2, :y2] ] 
n_grams = build_n_grams lines, 3
#puts n_grams.inspect

# convert to hash for ease of ruby 'group by' operator
# { [:x1, :a1, :x2] => 4,
#   [:x2, :a2, :y2] => 3 } 
n_grams_freq = build_n_grams_freq n_grams
#puts n_grams_freq.inspect#.inspect each { |f| puts f.inspect }

# build list of unique x/y pairs
# [ [:x1,:x1], [:x2,:y2] ]
uniq_xy_pairs = uniq_xy_pairs n_grams_freq
#puts "uniq_xy_pairs"; puts uniq_xy_pairs.inspect

# calculate xy_weights hash 
# (also rescaled to 0.0001 -> 1) 
# { [:x1,:x1] => 0.5, 
#   [:x2,:y2] => 0.2 }
normalised_xy_weights = build_normalised_xy_weights_from uniq_xy_pairs, term_freq
#puts "normalised_xy_weights"
#normalised_xy_weights.each { |xy_pair, freq| puts "#{freq} #{xy_pair.inspect}" }
#exit 0

# convert to structure relating for each x,y the
# frequency of middle values for a
# [[:x1,y1], {:a2 => 1}]
# [[:x2,y2], {:a1 => 1, :a2 => 2}]
middle_values_hash = build_middle_values n_grams_freq
#middle_values_hash.each { |f| puts f.inspect }

# filter middle values that only have one entry in middle value hash
# [[:x2,y2], {:a1 => 2, :a2 => 4, :a3 => 1}]
non_unique_middle_values = remove_uniq_middle_values middle_values_hash

# explode combos for the middle values
# includes calulating the relative frequencies
# [x2,y2,a1,a2,0.5]
# [x2,y2,a1,a3,0.5]
# [x2,y2,a2,a3,0.25]
# [x1,y1,a1,a2,0.25]
exploded_combos = explode_combos_for non_unique_middle_values
#exploded_combos.each { |ec| puts ec.inspect }

# combine weights; both the a12 frequency just calculated and the normalised_xy_weights 
# [a1, a2, 0.3]
# [a1, a3, 0.25]
# [a1, a2, 0.18]
combined_weights = combined_weights_for exploded_combos, normalised_xy_weights
#combined_weights.each { |cw| puts cw.inspect }

# collate weights for each unique a1, a2 pair
a1a2_weights = {}
combined_weights.each do |weights|
	a1,a2,weight = weights
	a1a2_weights[[a1,a2]] ||= []
	a1a2_weights[[a1,a2]] << weight
end
#puts "a1a2_weights"; a1a2_weights.each { |a1a2,weights| puts "#{a1a2.inspect} #{weights.inspect}" }

# remove those with only one weight
# TODO: this could done at combining_weights step
keys_to_remove = []
a1a2_weights.keys.each do |a1a2|
	num_weights = a1a2_weights[a1a2].size
	keys_to_remove << a1a2 if num_weights == 1	
end
keys_to_remove.each { |key| a1a2_weights.delete key }
#puts "keys removed"; a1a2_weights.each { |a1a2,weights| puts "#{a1a2.inspect} #{weights.inspect}" }

=begin
a1a2_weights.each do |a1a2pair, list_of_weights|
	a1,a2 = a1a2pair
	sum = list_of_weights.inject{|a,v| a+v}	
	printf "%20s %20s %0.10f %d\n",a1,a2,sum.to_f,list_of_weights.size
end
=end
