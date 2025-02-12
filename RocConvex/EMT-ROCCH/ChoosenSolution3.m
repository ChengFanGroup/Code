function [traIndex] = ChoosenSolution3(point,traSlonum)
%CHOOSENSOLUTION2 此处显示有关此函数的摘要
%   此处显示详细说明
    traIndex = [];
    N = size(point,1);
    while(length(traIndex) < traSlonum)
        Cand_index = setdiff( 1:N , traIndex );
        traIndex = [traIndex Cand_index(randi([1,length(Cand_index)],1,traSlonum-length(traIndex)))];
        traIndex = unique(traIndex);
    end
end

