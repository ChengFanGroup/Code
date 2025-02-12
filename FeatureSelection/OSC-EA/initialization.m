function [pop, obj] = initialization(Vars, popsize, trainData, trainLabel)
    %% initilize population
    pop = randi([0,1], popsize, Vars);
    
    %% evaluate individual
    obj = zeros(popsize, 2);
    for i = 1:popsize
        obj(i, :) = LOOCV_KNN(trainData, trainLabel, pop(i, :));
    end
end