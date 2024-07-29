function [newPop] = GetNewPop(pop,fitness,searchSpace)
%GETNEWPOP The subspace corresponds to the population for cross-mutation operation
%   pop: the Population/solutions
%   fitness: the fitness of Population
%   searchSpace: the area of search

    searchSpaceNum = size(searchSpace,1);
    popSize = size(pop{1});
    if mod(popSize(1),2)
        MatingNum = popSize(1)+1;
    else
        MatingNum = popSize(1);
    end
    newPop = cell(1,searchSpaceNum);

    for i = 1:searchSpaceNum
        MatingPool = TournamentSelection(2,MatingNum,fitness{i}(:,1),fitness{i}(:,2));
        temp = OperatorGABin(pop{i}(MatingPool,searchSpace(i,:)),{1,20,1,20});
        newPop{i} = zeros(popSize(1),popSize(2));
        newPop{i}(1:popSize(1),searchSpace(i,:)) = temp(1:popSize(1),:);
    end

end

