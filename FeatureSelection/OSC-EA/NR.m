function [offspring,flag] = NR(pop, Vars, obj, gen, allerr)
    % NR
    % Modified and commented by Fanrong Kong

    if gen <= 20
        %% 划分子区域，根据不同子区域不同学习方式
        CF = Convergent_sort(obj, allerr, gen);
        p1 = CF == 1;
        p2 = CF == 2;
        p3 = CF == 3;
        p4 = CF == 4;
        pop1 = pop(p1,:);
        pop2 = pop(p2,:);
        pop3 = pop(p3,:);
        pop4 = pop(p4,:);
        obj1 = obj(p1, :);
        obj2 = obj(p2, :);
        obj3 = obj(p3, :);
        obj4 = obj(p4, :);
        parent1 = [];
        parent2 = [];
    
        
        %% from CLPSO  
        % 区域1：错误率和压缩率都好
        offspring1 = zeros(size(pop1,1),Vars);
        for i = 1:size(pop1,1)
            Pc = 0.55 + 0.45*(exp(10*(i - 1)/(size(pop1,1) - 1)) / (exp(10) - 1));
            % exem: 论文中的gs
            % 处于第一层的解向理想点(0, 0)学习
            exem = zeros(1,Vars);  
            d = rand(1,Vars) < Pc;
            offspring1(i,:) = d.*exem + (1-d).*pop1(i,:);
        end
        % 区域2：错误率好，压缩率差
        offspring2 = zeros(size(pop2,1),Vars);
        for i = 1:size(pop2,1)
            Pc = 0.05 + 0.45*(exp(10*(i - 1)/(size(pop2,1) - 1)) / (exp(10) - 1));
            if size(pop1, 1) > 2
                % 向第一层中压缩率好的解(即obj1(:,2))学习
                s1 = TournamentSelection(2,Vars,obj1(:,2));
                Pop = pop1;
                % exem: 论文中的gs
                exem = zeros(1,Vars);
                for j = 1:Vars
                    exem(j) = Pop(s1(j),j);
                end
            else
                exem = zeros(1,Vars);
            end
            Pl = rand(1,Vars);
            d = Pl < Pc;
            offspring2(i,:) = ((d.*pop2(i,:)) & exem) + (1-d).*pop2(i,:); 
        end
        % 错误率差，压缩率好
        offspring3 = zeros(size(pop3,1),Vars);
        for i = 1:size(pop3,1)
            Pc = 0.05 + 0.45*(exp(10*(i - 1)/(size(pop3,1) - 1)) / (exp(10) - 1));
            if size(pop1,1) > 2
                % 向第一层中错误率好的解(即obj1(:,1))学习
                s1 = TournamentSelection(2,Vars,obj1(:,1));
                Pop = pop1;
                for j = 1:Vars
                    exem(j) = Pop(s1(j),j);
                end
            else
                exem = zeros(1,Vars);
            end
            Pl = rand(1,Vars);
            d = Pl < Pc;
            offspring3(i,:) = ((d.*pop3(i,:)) | exem) + (1-d).*pop3(i,:); 
        end
        % 错误率和压缩率都差
        offspring4 = zeros(size(pop4,1),Vars);
        for i = 1:size(pop4,1)
            Pc = 0.05 + 0.45*(exp(10*(i - 1)/(size(pop4,1) - 1)) / (exp(10) - 1));
            if size(pop1,1) > 0
                % 直接向第一层中错误率好的解学习
                s1 = TournamentSelection(2,Vars,obj1(:,1));
                Pop = pop1;
                for j = 1:Vars
                    exem(j) = Pop(s1(j),j);
                end
            else
                exem = zeros(1,Vars);
            end
            Pl = rand(1,Vars);
            d = Pl < Pc;
            k = find(d == 1);
            offspring4(i,:) = d.*exem + (1-d).*pop4(i,:); 
        end
        
        offspring = [offspring1; offspring2; offspring3; offspring4];
        flag = true; 
    else
        %% 第二阶段产生解
        N = size(pop,1);
        parent1 = pop;
        parent2 = pop(randi(N,1,N),:);
        offspring = parent1;
        for i = 1 : N
            k = find(xor(parent1(i, :), parent2(i, :)));
            t = length(k);
            if t > 1
                j = k(randperm(t, randi(t - 1, 1)));
                offspring(i, j) = parent2(i, j);
            end
        end
        flag = false;
    end
    % 变异
    for i = 1:size(offspring,1)
        k = rand(1, Vars) < 1 / Vars;
        offspring(i, k) = ~offspring(i, k);
    end
    
%     offspring = unique(offspring, 'rows');
end