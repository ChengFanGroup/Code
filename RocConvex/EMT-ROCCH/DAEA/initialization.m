function [pop, obj] = initialization(Vars, popsize, traindata, trainlabel)
    %% initilize population
%     pop = rand(popsize, Vars).*(Upper - Lower) + Lower;
    pop = randi([0,1], popsize, Vars);
%     pop = zeros(popsize, Vars);
%     for i = 1:popsize
%         k = randperm(ceil(Vars/2),1);
%         s = randperm(Vars,k);
%         pop(i,s) = 1;
%     end
%     pop = zeros(popsize,Vars);
%     alpha = 0.05;
%     p = 1;
%     for j = 1:5
%         k = randperm(ceil(Vars*0.05),0.2*popsize) + ceil((alpha - 0.05) * Vars);
%         for h = 1:length(k)
%             t = randperm(Vars,k(h));
%             pop(p,t) = 1;
%             p = p + 1;
%         end
%         alpha = alpha + 0.05;
%     end
%     obj = zeros(popsize, 2);
    
    %% evaluate individual
    for i = 1:popsize
        obj(i, :) = evaluation(pop(i, :), Vars, traindata, trainlabel);
    end
end