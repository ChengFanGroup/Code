function [index] = wheelSelection(score)
%WHEELSELECTION 此处显示有关此函数的摘要
%   此处显示详细说明
	data=score;           % 原始几率数据
	a=data./sum(data);        % 归一化
	b=cumsum(a);              % 区域向量
	select=find(b>=rand);     % 下标数组
    index = select(1);
end

