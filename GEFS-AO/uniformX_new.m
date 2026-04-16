function [NewChrom] = uniformX_new(OldChrom,px,pm,chromosome_f,g1,g2,g3)
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

template_x = logical(randsrc(M,N, [1,0;px,1-px]));

% child_1 = OldChrom(parent_2,:) & template + OldChrom(parent_1,:) & ~template;
% child_2 = OldChrom(parent_1,:) & template + OldChrom(parent_2,:) & ~template;

child_1 = OldChrom(parent_2,:) .* template_x + OldChrom(parent_1,:) .* ~template_x;
child_2 = OldChrom(parent_1,:) .* template_x + OldChrom(parent_2,:) .* ~template_x;

child_1 = mut(child_1, pm); % 变异
child_2 = mut(child_2, pm); % 变异

NewChrom((1:2:2*M),:) = double(child_1);
NewChrom((2:2:2*M),:) = double(child_2);


[lia,loc] =ismember(NewChrom,chromosome_f,"rows");
ipnewmut = find(lia);
if length(ipnewmut) > 0 
    NewChrom = newmut1(NewChrom,ipnewmut,g1,g2,g3);

end   

% save('111.mat','child_1','template_x','OldChrom','NewChrom')
% ccc
end