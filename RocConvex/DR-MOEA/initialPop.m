function [population] = initialPop(poplength,N)
%INITIALPOP 此处显示有关此函数的摘要
%   此处显示详细说明
       minvalue  =  repmat(ones(1,poplength),N,1)*(-1);        %个体最小值
       maxvalue  =  repmat(ones(1,poplength),N,1);             %个体最大值       
       population  =  rand(N,poplength).*(maxvalue-minvalue)+minvalue;    %产生新的初始种群
end

