#!/usr/bin/env ruby
require 'array_extensions'
require 'word_idx'
require 'pp'


word_idx = WordIdx.new

#lines = STDIN.to_a.collect { |line| line.chomp.split }
lines = [ 'the cat blah', 'a cat blah' ].map(&:split)

=begin
build uber word matrix
word_matrix[word1][word2] = array of relative positions across corpus of word1 to word2 
eg 
	["the", "fat", "cat", "sat", "on", "the", "mat"]
becomes
	{5=>{0=>[-6, -1], 1=>[-5], 2=>[-4], 3=>[-3], 4=>[-2]},
	 0=>{5=>[6, 1], 1=>[1, -4], 2=>[2, -3], 3=>[3, -2], 4=>[4, -1]},
	 1=>{5=>[5], 0=>[-1, 4], 2=>[1], 3=>[2], 4=>[3]},
	 2=>{5=>[4], 0=>[-2, 3], 1=>[-1], 3=>[1], 4=>[2]},
	 3=>{5=>[3], 0=>[-3, 2], 1=>[-2], 2=>[-1], 4=>[1]},
	 4=>{5=>[2], 0=>[-4, 1], 1=>[-3], 2=>[-2], 3=>[-1]}}
=end
word_matrix = {}
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
pp word_matrix


=begin
now convert from hash of hashes form to hash of arrays, ordered by key, with averages taken for each array
above hash now becomes
	{5=>[0, -3.5, 1, -5, 2, -4, 3, -3, 4, -2],
	 0=>[1, -1.5, 2, -0.5, 3, 0.5, 4, 1.5, 5, 3.5],
	 1=>[0, 1.5, 2, 1, 3, 2, 4, 3, 5, 5],
	 2=>[0, 0.5, 1, -1, 3, 1, 4, 2, 5, 4],
	 3=>[0, -0.5, 1, -2, 2, -1, 4, 1, 5, 3],
	 4=>[0, -1.5, 1, -3, 2, -2, 3, -1, 5, 2]}
=end
word_matrix.each do |id1,id2s|
	sorted_id2s_and_averages = []
	id2s.keys.sort.each do |id2|
		sorted_id2s_and_averages << id2
		sorted_id2s_and_averages << id2s[id2].mean
	end
	word_matrix[id1] = sorted_id2s_and_averages
end
pp word_matrix

