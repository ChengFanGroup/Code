function [gbest1] = converse(gbest2)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
     global  featNum kNeigh;
     index = find(gbest2);
     a = zeros(featNum, kNeigh);
     a(index,:) = 1;
     gbest1 = reshape(a, 1,featNum* kNeigh);

    
end