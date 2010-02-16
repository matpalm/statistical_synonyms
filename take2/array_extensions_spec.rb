require 'array_extensions'
describe 'array extensions test' do

   it 'should calc distance from array to itself as 0' do
      a = [1,1, 2,2]
      a.sparse_distance_to(a).should == 0
   end
   
   it 'should calc distance from array to another array of same indexes' do
      a = [1,1, 2,2]
      b = [1,2, 2,3]
      a.sparse_distance_to(b).should == Math.sqrt(2)
   end

   it 'should calc distance from array to another array of same length with differing indexes, first array idx less' do
      a = [1,1, 2,2]
      b = [1,2, 3,3]
      a.sparse_distance_to(b).should == Math.sqrt(14)
   end

   it 'should calc distance from array to another array of same length with differing indexes, first array idx more' do
      a = [1,1, 4,2]
      b = [1,2, 3,3]
      a.sparse_distance_to(b).should == Math.sqrt(14)
   end

end
