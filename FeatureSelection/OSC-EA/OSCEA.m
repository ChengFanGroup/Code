function [solution, trainFitness, recordProcess] = OSCEA(trainData, trainLabel)
    %  An Objective Space Constraint-Based Evolutionary Method 
    %  for High-Dimensional Feature Selection
    % 
    %  based on NSGAⅡ for Feature Selection on High-Dimensional
    %  written by ZhangRui
    %  2020/12/12
    %
    %  Modified by Fanrong Kong

    % clear;
    % clc;
    % close all;
    %% parameter
    popsize = 100;
    Gen = 100;
    maxEvals = 100 * Gen;
    % 跳出局部最优
    k = 10;
    % true第一阶段 false第二阶段
    flag = true;
    % true需要初始化epsilon值
    flag_epsilon = true;
    Evals = 0;
    gen = 1;
    m = 0;
    
    archive = [];
    recordProcess = cell(1, Gen);
    Vars = size(trainData, 2);
    
    %% Main Loop
    while Evals < maxEvals
        count = 0;
        g = 1;
        m = m + 1;
    
        if gen == 1
            [pop, obj] = initialization(Vars, popsize, trainData, trainLabel);
        else
            % 当连续k次最低错误率不变时，会重新初始化种群来跳出局部最优
            [pop, obj] = initialization_1(Vars, popsize, trainData, trainLabel, pop, obj);
        end
        
        while count <= k && Evals < maxEvals 
            % Record non-dominated solutions
            [FrontNo, ~] = NDSort(obj, size(obj, 1));
            recordProcess{gen} = obj(FrontNo, :);
            % 最低错误率
            me = min(obj(:, 1));
            if flag 
                % 第一阶段
                obj1 = unique(obj(:, 1), 'rows');
                resy = sort(obj1);
                % 取中位数的错误率
                allerr = resy(ceil(length(resy)/2));
            end
            % 产生子代
            [offspring, flag] = NR(pop, Vars, obj, g, allerr);
            Evals = Evals + size(offspring, 1);
            offspring_obj = zeros(size(offspring, 1), 2);
            for j = 1:size(offspring,1)
                offspring_obj(j, :) = LOOCV_KNN(trainData, trainLabel, offspring(j, :));
            end
            
            pop = [pop; offspring];
            obj = [obj; offspring_obj];

            if flag
                % CDP
                epsilon = 0;
            else
                % Epsilon constraint
                if flag_epsilon
                    d = pdist2(obj,[0,0]);
                    [~,s] = sort(d);
                    e0 = d(s(0.05 * popsize));
                    flag_epsilon = false;
                end
                if gen < Gen
                    epsilon = e0 * power( 1 / (1 - (gen / (Gen))), 1);
                else
                    epsilon = inf;
                end
            end
            if flag
                [pop,obj] = Convergent_ES(pop, popsize, obj, allerr, gen);
            else 
                [pop,obj] = Diversity_ES(pop, popsize, obj, epsilon);
            end
    
            % 连续k次最低错误率不变
            if ~flag
                if me == min(obj(:, 1))
                    count = count + 1;
                else
                    count = 0;
                end
            end
            gen = gen + 1;
            g = g + 1;
        end
        [PF, ~] = nondominated_sort(obj, size(obj, 1));
        F = pop(PF == 1,:);
        FO = obj(PF == 1,:);
        km = find(obj(:, 1) == min(obj(:, 1)));
        % 非支配第一层的和最低错误率的解都加入到档案
        archive = [archive;[F,FO];[pop(km,:),obj(km,:)]];
        archive = unique(archive,'rows');
    end
    % 去除档案冗余
    archive = unique(archive, 'rows');
    solution = archive(:, 1:Vars);
    trainFitness = archive(:, Vars+1:end);

end
