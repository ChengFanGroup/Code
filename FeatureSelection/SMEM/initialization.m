function [pop, obj] = initialization(Vars, popsize, traindata, trainlabel, n)
    %% initilize population
%     pop = rand(popsize, Vars).*(Upper - Lower) + Lower;
%     popsize = 50;
%    pop = randi([0,1], popsize, Vars);
%     pop = zeros(popsize, Vars);
%     for i = 1:popsize
%         k = randperm(ceil(Vars/2),1);
%         s = randperm(Vars,k);
%         pop(i,s) = 1;
%     end
%     pop = zeros(popsize,Vars);
%     
    pop = {};
    obj = {};
    for i = 1 : n
        t1 = (i - 1) * (round(Vars/n));
        pop{i} = zeros(popsize/n, Vars);
        for j = 1 : popsize / n
            k = randperm(min(round(Vars/n), Vars - t1), 1);
            s = t1 + randperm(min(round(Vars/n), Vars - t1), k);
            pop{i}(j, s) = 1;
        end
    end
    
    %% evaluate individual
%     obj = zeros(popsize, 2);
    for j = 1 : n
        for i = 1:size(pop{j}, 1)
            obj{j}(i, :) = evaluation(pop{j}(i, :), Vars, traindata, trainlabel);
        end
    end
end