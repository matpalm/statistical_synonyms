class Array

	def mean
		raise "cant calc mean for empty array!!" if length==0
		return first if length==1
		inject{|a,v| a+v}.to_f / length
	end

	# multiple of sparse vectors
	def sparse_distance_to b
	   a = self
	   a_iter = b_iter = 0
	   dist = 0
      while (a_iter < a.size) && (b_iter < b.size)
				a_idx, a_val = a[a_iter]
#				puts "a_iter=#{a_iter} a_idx=#{a_idx} a_val=#{a_val} a[a_iter]=#{a[a_iter].inspect}"
				b_idx, b_val = b[b_iter]
#				puts "b_iter=#{b_iter} b_idx=#{b_idx} b_val=#{b_val}"
				if (a_idx == b_idx)
					diff = (a_val-b_val).abs
					dist += diff * diff
					a_iter += 1
					b_iter += 1
				elsif a_idx < b_idx
					dist += a_val * a_val
					a_iter += 1
				else # a_idx > b_idx
					dist += b_val * b_val
					b_iter += 1
				end
      end
      while a_iter < a.size
         a_val = a[a_iter][1]
         dist += a_val * a_val
         a_iter += 1
      end
      while b_iter < b.size
         b_val = b[b_iter][1]
         dist += b_val * b_val
         b_iter += 1
      end
      Math.sqrt dist
   end

end



