function [traindata, trainlabel,testdata,testlabel,archive] = main(dataset,dataName)
%% parameter
popsize = 120;
Gen = 100;
maxEvals = 100*Gen;
%子空间数量
n = 8;
Evals = 0;
gen = 1;
flag = true;

archive = [];


%% load data
[traindata, trainlabel,testdata,testlabel] = data_process(dataset);
Vars = size(traindata, 2);

%% Main Loop
[Pop, Obj] = initialization(Vars, popsize, traindata, trainlabel, n);
while gen <= 20

    for i = 1 : n
        offspring = NR1(Pop{i}, Obj{i}, flag, Vars, i, round(Vars/n));
    %     Evals = Evals + size(offspring,1);
        offspring_obj = zeros(size(offspring,1), 2);
        for j = 1 : size(offspring, 1)
            offspring_obj(j, :) = evaluation(offspring(j, :), Vars, traindata, trainlabel);
        end
        pop = [Pop{i}; offspring];
        obj = [Obj{i}; offspring_obj];
        [Pop{i}, Obj{i}] = EnvironmentalSelection(pop, popsize/n, obj);
    end
    gen = gen + 1;
    
end
flag = false;
while gen <= 100
    alpha = 10;
    if length(Pop) >= 2
        tmpPop = {};
        tmpObj = {};
        k = 1;
        for i = 1 : 2 : length(Pop)
            if(i==length(Pop))
                offspring = NR2(Pop{i}, Pop{i}, Obj{i}, Obj{i}, Vars);
                offspring_obj = zeros(size(offspring,1), 2);
                for j = 1 : size(offspring, 1)
                    offspring_obj(j, :) = evaluation(offspring(j, :), Vars, traindata, trainlabel);
                end
                pop = [Pop{i};offspring];
                obj = [Obj{i};offspring_obj];
            else
                offspring = NR2(Pop{i}, Pop{i+1}, Obj{i}, Obj{i+1}, Vars);
                offspring_obj = zeros(size(offspring,1), 2);
                for j = 1 : size(offspring, 1)
                    offspring_obj(j, :) = evaluation(offspring(j, :), Vars, traindata, trainlabel);
                end
                pop = [Pop{i};Pop{i+1}; offspring];
                obj = [Obj{i};Obj{i+1}; offspring_obj];
            end
            
            
            [tmpPop{k}, tmpObj{k}] = EnvironmentalSelection(pop, 2 * (popsize/length(Pop)), obj);
            k = k + 1;
        end
        Pop = tmpPop;
        Obj = tmpObj;
    end
    while alpha > 0 && gen <= 100
        alpha = alpha - 1;
        for i = 1 : length(Pop)
            offspring = NR1(Pop{i}, Obj{i}, flag, Vars, i, round(Vars/n));
            offspring_obj = zeros(size(offspring,1), 2);
            for j = 1 : size(offspring, 1)
                offspring_obj(j, :) = evaluation(offspring(j, :), Vars, traindata, trainlabel);
            end
            pop = [Pop{i}; offspring];
            obj = [Obj{i}; offspring_obj];
            [Pop{i}, Obj{i}] = EnvironmentalSelection(pop, popsize/length(Pop), obj);
        end
        gen = gen + 1;
    end
    gen = gen + 1;
    
end
    Pop = Pop{1};
    Obj = Obj{1};
    [PF, ~] = nondominated_sort(Obj, popsize);
    m = min(Obj(:, 2)) == Obj(:, 2);
    archive = [Pop(PF == 1, :), Obj(PF == 1, :)];
    archive = [archive; [Pop(m, :),Obj(m, :)]];

end

