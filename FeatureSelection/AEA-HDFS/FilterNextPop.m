function [pop,fitness] = FilterNextPop(pop,newPop,fitness,newFitness,stage)
%FILTERNEXTPOP 此处显示有关此函数的摘要
%   此处显示详细说明
    if stage==1
         popNum = size(pop{1},1);
        for i = 1:numel(pop)
            [pop{i},fitness{i}] = EnvironmentalSelection(vertcat(pop{i},newPop{i}),vertcat(fitness{i},newFitness{i}),popNum);
        end

    elseif stage==2
%% front==1 and minErr
        N = size(pop,1);
        pop = [pop{1};newPop{1}];
        objs = [fitness{1};newFitness{1}];

        % Remove duplicate
        [~,idx] = unique(pop,'rows');
        pop = pop(idx,:);
        objs = objs(idx,:);
         

        [FrontNo,~] = NDSort(objs,1);
        Next = FrontNo == 1;
        tempPop1 = pop(Next, :);
        tempFitness1 = objs(Next, :);

        [~,index] = sortrows(objs);
        Next = index(1:(N-size(tempPop1)));
        tempPop2 = pop(Next, :);
        tempFitness2 = objs(Next, :);

        pop = {[tempPop1;tempPop2]};
        fitness = {[tempFitness1;tempFitness2]};

    end
end

