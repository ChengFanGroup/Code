function [indivNet] = decodeNet(f)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
global kNeigh;
global featNum;
global kNeiMatrix;
global kNeiZout


% tic
K = kNeiZout;%squareform(adj);
MODE = zeros(size(K));

rShapeF = reshape(f, featNum, kNeigh);
STD = kNeiMatrix.*rShapeF;
for i = 1:1:featNum
%     save('2.mat','STD','featNum')
%     cccc
    idx = find(STD(i,:));
    MODE(i,STD(i,idx)) = 1;
end

indivNet = MODE.*K;
% TT=toc
% TTT(end+1)=TT;
end

