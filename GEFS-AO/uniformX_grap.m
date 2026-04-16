function [NewChrom] = uniformX_grap(OldChrom,idx,px,pm,chromosome_f,g1,g2,g3)
%UNIFORMX 此处显示有关此函数的摘要
%   此处显示详细说明
[M,N] = size(OldChrom);


chromidx = repmat(idx,M,1);
aa = rand(M,N);
chromidx = chromidx > aa;

template_x = logical(randsrc(M,N, [1,0;px,1-px]));

% child_1 = OldChrom(parent_2,:) & template + OldChrom(parent_1,:) & ~template;
% child_2 = OldChrom(parent_1,:) & template + OldChrom(parent_2,:) & ~template;

child_1 = OldChrom .* template_x + chromidx .* ~template_x;
child_2 = OldChrom .* ~template_x + chromidx .* template_x;

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