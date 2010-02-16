class WordIdx

	def initialize
		@word_to_idx = {}
		@words = []
		@seq = -1
	end

	def indexes_for words
		words.collect {|word| index_for word }
	end

	def index_for word
		idx = @word_to_idx[word]
		return idx if idx
		@seq += 1	
		@word_to_idx[word] = @seq
		@words << word
		@seq
	end

	def words_for idxs
		idxs.collect {|idx| word_for idx }
	end

	def word_for idx
		@words[idx]
	end

	def dump_lexicon
		@words.each_with_index { |w,idx| puts "#{idx}\t#{w}" }
	end

end
