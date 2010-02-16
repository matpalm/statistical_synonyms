#!/usr/bin/env ruby
require 'array_extensions'
require 'word_idx'
require 'pp'


word_idx = WordIdx.new

lines = STDIN.to_a.collect { |line| line.chomp.split }.select { |words| words.size>1 }
#lines = [ 'the fat cat','the fat dog' ].map(&:split)
#lines = [lines.first]

=begin
build uber word matrix
word_matrix[word1][word2] = array of relative positions across corpus of word1 to word2 
eg 
	["the", "fat", "cat"]
becomes
 [{1=>[1], 2=>[2]}, {0=>[-1], 2=>[1]}, {0=>[-2], 1=>[-1]}]

0 -> the, 1 -> fat, 2 -> cat
eg
 {0=>[-1], 2=>[1]} as the 2nd entry relates the term 'fat'
 1st key/value pair means 0th term (the) appears one word before 'fat'

=end
word_matrix = []
lines.each do |words|
	ids = word_idx.indexes_for words
	puts "#{words.inspect}"
	(0...ids.size).each do |idx1|
		id1 = ids[idx1]		
		((idx1+1)...ids.size).each do |idx2|
			id2 = ids[idx2]
			next if id1 == id2			
			puts "idx1=#{idx1} id1=#{id1} word1=#{word_idx.word_for(id1)}      idx2=#{idx2} id2=#{id2} word2=#{word_idx.word_for(id2)} "
			word_matrix[id1] ||= {}
			word_matrix[id1][id2] ||= []
			word_matrix[id1][id2] << (idx2-idx1)
			word_matrix[id2] ||= {}
			word_matrix[id2][id1] ||= []
			word_matrix[id2][id1] << (idx1-idx2)
		end		
	end
end
word_idx.dump_lexicon

=begin
now convert from hash of hashes form to hash of arrays, ordered by key, with averages taken for each array
above 
	[{1=>[1, 1], 2=>[2], 3=>[2]},
	 {0=>[-1, -1], 2=>[1], 3=>[1]},
	 {0=>[-2], 1=>[-1]},
	 {0=>[-2], 1=>[-1]}]
now becomes
	[ [1,1, 2,2, 3,2],
    [0,0, 2,1, 3,1],
    [0,-2, 1,-1],
    [0,-2, 1,-1]
  ]
=end
word_matrix.collect! do |id2_to_pos|
	key_values_sorted = []
	id2_to_pos.keys.sort.each do |id2|
		key_values_sorted << [id2, id2_to_pos[id2].mean]
	end
	key_values_sorted
end

word_matrix.each_with_index do |word_vectors, idx|
	puts "idx=#{idx} word_vectors=#{word_vectors.inspect}"
end

(0...word_matrix.size).each do |id1|
	proximity_vector1 = word_matrix[id1]
	((id1+1)...word_matrix.size).each do |id2|
		proximity_vector2 = word_matrix[id2]
		puts "DISTS #{word_idx.word_for(id1)} #{word_idx.word_for(id2)} #{proximity_vector1.sparse_distance_to(proximity_vector2)}"
	end
end
