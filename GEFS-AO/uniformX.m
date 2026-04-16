function [NewChrom] = uniformX(OldChrom,px,pm)
%UNIFORMX 此处显示有关此函数的摘要
%   此处显示详细说明
[M,N] = size(OldChrom);

parent_1 = 1:M;
parent_2 = randperm(M);

eqIdx = parent_1==parent_2;
while(sum(eqIdx))
    parent_2(eqIdx) = randi([1,M], 1,sum(eqIdx));
    eqIdx = parent_1==parent_2;
end

template = logical(randsrc(M,N, [1,0;px,1-px]));
template = logical(mut(template, pm)); % 变异
% child_1 = OldChrom(parent_2,:) & template + OldChrom(parent_1,:) & ~template;
% child_2 = OldChrom(parent_1,:) & template + OldChrom(parent_2,:) & ~template;

child_1 = OldChrom(parent_2,:) .* template + OldChrom(parent_1,:) .* ~template;
child_2 = OldChrom(parent_1,:) .* template + OldChrom(parent_2,:) .* ~template;

NewChrom((1:2:2*M),:) = double(child_1);
NewChrom((2:2:2*M),:) = double(child_2);

end