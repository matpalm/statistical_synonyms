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

def build_middle_values n_grams
	middle_values = {}
	n_grams.each do |ngram|
		x,a,y = ngram
		middle_values[[x,y]] ||= Set.new
		middle_values[[x,y]] << a
	end
	middle_values
end

def remove_uniq_middle_values middle_values_hash
	middle_values_hash.keys.each do |pair|
		num_values = middle_values_hash[pair].size
		middle_values_hash.delete(pair) if num_values==1
	end
end

def explode_combos_for middle_values
	middle_values.each do |pair, middle_values|
		middle_values_terms = middle_values.sort
		a1 = middle_values_terms.shift
		while !middle_values_terms.empty? do
			middle_values_terms.each do |a2|
				puts "#{a1}\t#{a2}"
			end
			a1 = middle_values_terms.shift
		end
	end
end


#--------------------------------------------------------------

# read all lines of standard
lines = slurp STDIN

# expand text in 3grams and 
# [ [:x1, :a1, :x2], 
#   [:x2, :a2, :y2] ] 
n_grams = build_n_grams lines, 3

# uniqify list, we don't care for frequencies
n_grams.uniq!

# convert to structure relating for each x,y the middle values for a
# [[:x1,y1] => [:a2]]
# [[:x2,y2] => [:a1,:a2,:a3]]
middle_values = build_middle_values n_grams

# filter middle values that only have one entry in middle value hash
# [[:x2,y2] => [:a1,:a2,:a3]]
remove_uniq_middle_values middle_values

# explode combos for the middle values
# includes calulating the relative frequencies
# [:a1,:a2]
# [:a1,:a3]
# [:a2,:a3]
explode_combos_for middle_values

