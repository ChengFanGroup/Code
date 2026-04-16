function [DEG] = my_degree(Gadj,featSeq)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
global vWeight1;
global vWeight;
    if sum(isnan(vWeight1))
       vWeight1 = vWeight; 
    end
lastWeg = vWeight1(end,:);
% orideg = degree(G);
orideg = sum(logical(Gadj),2);
% Gadj = full(adjacency(G,'weighted'));
oriweg = sum(Gadj, 2);
DEG = round(sqrt(orideg(featSeq).*oriweg(featSeq).*(1*lastWeg(featSeq)')));%新增节点（特征）权重
% DEG0 = round(sqrt(orideg.*oriweg));
% DEGdiff = DEG-DEG0; %debug
% oriweg = sum(Gadj, 2)^2;
% DEG = round((orideg.*oriweg).*(1/3));
end

