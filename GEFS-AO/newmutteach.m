function [NewChrom] = newmutteach(NewChrom,teacher)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
     [m,n] = size(NewChrom);
     for i = 1:m

         stu = NewChrom(i,:);
         stu = find(stu>0);
         a = intersect(stu,teacher);
         b = union(stu,teacher);
         c = rand;

         if c < length(a)/length(b) & length(a) >2
            interge = randi([1,length(a)]);
            NewChrom(i,a(interge)) =0;
         end

     end    
end