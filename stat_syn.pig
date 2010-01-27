text = load 'sample.tweets';

tokens = stream text through `ruby unigrams.rb` as (token:chararray);
tokens_grouped = group tokens by token;

ngrams = stream text through `ruby n_grams.rb 3` as (f1:chararray, f2:chararray, f3:chararray);
ngrams_grouped = group ngrams by (f1,f2,f3);
ngrams_freqs = foreach ngrams_grouped generate flatten(group), SIZE(ngrams) as freq;

store ngrams_freqs into 'freqs.tsv';
middle_values = group ngrams_freqs by (f1,f3);
middle_values2 = foreach middle_values generate group, ngrams_freqs.f2, ngrams_freqs.freq;
exploded = stream middle_values2 through `ruby explode_combos.rb` as (s1:chararray, s2:chararray, weight:float);
exploded_grouped = group exploded by (s1,s2);
non_unique_exploded = filter exploded_grouped by SIZE(exploded)>1;
exploded_mean = foreach non_unique_exploded generate flatten(group), SUM(exploded.weight);
store exploded_mean into 'exploded_mean.tsv';
