#!/usr/bin/env ruby

class String
	def without_urls 
		gsub(/http.*?\s/,' ').sub(/http.*?$/,' ') # single regex for this? i'm sleepy
	end

	def without_at_names
		gsub(/@.*\s/,' ')
	end

	def with_amps_spaced
		gsub /&/, ' & '
	end
	
	def without_punctionation
		gsub('\'','').gsub(/[^a-z0-9&]/, ' ')
	end

	def duplicate_spaces_removed
  	gsub(/\s+/, ' ')
	end

	def digits_washed
		gsub(/\d/,'D')
	end

end

STDIN.each do |line|
	line = line.
		chomp.
		downcase.
		without_urls.
		without_at_names.
		with_amps_spaced.
		without_punctionation.
		duplicate_spaces_removed.
		digits_washed.
		strip
	puts line unless line.empty?
end
