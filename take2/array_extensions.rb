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
      while (a_iter <= a.size-2) && (b_iter <= b.size-2)
   	   a_idx, a_val = a[a_iter], a[a_iter+1]
   	   b_idx, b_val = b[b_iter], b[b_iter+1]
         if (a_idx == b_idx)
            diff = (a_val-b_val).abs
            dist += diff * diff
            a_iter += 2
            b_iter += 2            
         elsif a_idx < b_idx
            dist += a_val * a_val
            a_iter += 2
         else # a_idx > b_idx
            dist += b_val * b_val
            b_iter += 2
         end
      end
      while a_iter <= a.size - 2
         a_val = a[a_iter+1]
         dist += a_val * a_val
         a_iter += 2
      end
      while b_iter <= b.size - 2
         b_val = b[b_iter+1]
         dist += b_val * b_val
         b_iter += 2
      end
      Math.sqrt dist
   end

end



