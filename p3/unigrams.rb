#!/usr/bin/env ruby
STDIN.each do |line|
	words = line.split ' '
	non_blank_words = words.select { |word| !word.empty? }
	puts words.join "\n"
end
