class Array

	def mean
		raise "cant calc mean for empty array!!" if length==0
		return first if length==1
		inject{|a,v| a+v}.to_f / length
	end

	def sparse_distance_to b
	   a = self
	   a_iter = b_iter = 0
	   dist = 0
      while (a_iter <= a.size-2) && (b_iter <= b_iter.size-2)
   	   a_idx, a_val = a[a_iter], a[a_iter+1]
   	   b_idx, b_val = b[b_iter], b[b_iter+1]
         puts "a_idx=#{a_idx} a_val=#{a_val}"
         puts "b_idx=#{b_idx} b_val=#{b_val}"         
         if (a_idx == b_idx)
            diff = (a_val-b_val).abs
            dist += diff * diff
            a_iter += 2
            b_iter += 2            
            puts "a_idx==b_idx; use diff of both; dist=#{dist}"
         elsif a_idx < b_idx
            dist += a_val * a_val
            a_iter += 2
            puts "a_idx < b_idx; use just a, dist=#{dist}"
         else # a_idx > b_idx
            dist += b_val * b_val
            b_iter += 2
            puts "a_idx > b_idx; use jsut b, dist=#{dist}"
         end
      end
      while a_iter <= a.size - 2
         a_val = a[a_iter+1]
         dist += a_val * a_val
         a_iter += 2
         puts "for drain a_val=#{a_val} dist=#{dist}"
      end
      while b_iter <= b.size - 2
         b_val = b[b_iter+1]
         dist += b_val * b_val
         b_iter += 2
         puts "for drain b_val=#{b_val} dist=#{dist}"
      end
      puts "FINAL dist_sum=#{dist}"
      Math.sqrt dist
   end

end



