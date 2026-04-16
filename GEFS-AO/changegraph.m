function [g2] = changegraph(inputArg1,g1)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
    
    lensubg = length(inputArg1);
    randIndex = randperm(size(inputArg1,2));
    inputArg2 = inputArg1(:,randIndex);
    for i = 1:lensubg -1
       g1(inputArg2(i),inputArg2(i+1)) =1;
       g1(inputArg2(i+1),inputArg2(i)) =1;
    end  
    g1(inputArg2(1),inputArg2(lensubg))=1;
    g1(inputArg2(lensubg),inputArg2(1))=1;
    g2 = g1;
end