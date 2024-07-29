function pop = InitPop(subspace,subspaceSize,popSize,spaceSize,theta)
%INITPOP 此处显示有关此函数的摘要
%   此处显示详细说明
    subspaceNum = numel(subspaceSize);
    pop = cell(1,subspaceNum);
    for i = 1:subspaceNum
        pop{i} = false(popSize,spaceSize);
        pop{i}(:,subspace(i,:)) = rand(popSize,subspaceSize(i)) > theta;
    end
end

