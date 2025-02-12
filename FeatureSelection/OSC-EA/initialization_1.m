function [pop, obj] = initialization_1(Vars, popsize, trainData, trainLabel, pop, obj)
    %% initilize population
    N = popsize;
    [PF,~] = nondominated_sort(obj,size(obj,1));
    Obj = obj(PF == 1,:);
    Pop = pop(PF == 1,:);
    k = zeros(1, Vars);
    for i = 1:size(Pop,1)
     k = k | Pop(i,:);
    end
    Pop1 = pop(PF > 1,:);
    kk = zeros(1, Vars);
    for i = 1:size(Pop1,1)
     kk = kk | Pop1(i,:);
    end
    s = find(k == 1);
    ss = find(kk == 1);
    newPop = zeros(N,Vars);
    for i = 1:N
        select = s .* randi([0,1],1,length(s));
        select(select == 0) = [];
        newPop(i,select) = 1;
        k1 = randperm(length(ss),1);
        newPop(i,ss(k1)) = 1;
    end
     
     
            
    %% evaluate individual
    newObj = zeros(N, 2);
    for i = 1:N
        newObj(i, :) = LOOCV_KNN(trainData, trainLabel, newPop(i, :));
    end
    
    pop = newPop;
    obj = newObj;
end