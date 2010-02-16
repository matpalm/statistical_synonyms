require 'array_extensions'
describe 'array extensions test' do

   it 'should calc distance from array to itself as 0' do
      a = [[1,1], [2,2]]
      a.sparse_distance_to(a).should == 0
   end
   
   it 'should calc distance from array to another array of same indexes' do
      a = [[1,1], [2,2]]
      b = [[1,2], [2,3]]
      a.sparse_distance_to(b).should == Math.sqrt(1+1)
   end

   it 'should calc distance from array to another array of same length with differing indexes' do
      a = [[1,1], [2,2]]
      b = [[1,2], [3,3]]
      a.sparse_distance_to(b).should == Math.sqrt(1+4+9)
      b.sparse_distance_to(a).should == Math.sqrt(1+4+9)
   end

   it 'should calc distance from array to another array of differing length' do
      a = [[1,1], [4,2]]
      b = [[1,2], [3,3], [4,3]]
      a.sparse_distance_to(b).should == Math.sqrt(1+9+1)
      b.sparse_distance_to(a).should == Math.sqrt(1+9+1)
   end

   it 'should calc distance from array to another array of differing length' do
      a = [[1,1], [4,2]]
      b = [[1,2], [3,3], [4,3]]
      a.sparse_distance_to(b).should == Math.sqrt(1+9+1)
      b.sparse_distance_to(a).should == Math.sqrt(1+9+1)
   end

   it 'should calc distance from array to another array of differing length with different final indexes' do
      a = [[1,1], [4,2]]
      b = [[1,2], [3,3], [5,3]]
      a.sparse_distance_to(b).should == Math.sqrt(1+9+4+9)
      b.sparse_distance_to(a).should == Math.sqrt(1+9+4+9)
   end

   it 'should calc distance from array to another array of differing length with different initial indexes' do
      a = [[2,1], [4,2]]
      b = [[1,2], [3,3], [4,3]]
      a.sparse_distance_to(b).should == Math.sqrt(4+1+9+1)
      b.sparse_distance_to(a).should == Math.sqrt(4+1+9+1)
   end

end
