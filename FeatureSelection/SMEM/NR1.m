   function offspring = NR1(pop, obj, flag, Vars, i, d)
    %% choose parents
    range_min = d * (i - 1);
    range_max = min(Vars, d * i);
    if flag
        offspring = SingleCrossOver(pop, range_min, range_max);    
    else
        offspring = kBitCross(pop, obj);
    end

        
    for i = 1 : size(offspring, 1)
        k = rand(1, Vars) < 1 / Vars;
        offspring(i, k) = ~offspring(i, k);
    end

        offspring = unique(offspring, 'rows');
    
   end
   
   function offspring = SingleCrossOver(pop, range_min, range_max)
        N = size(pop,1);
        Vars = size(pop, 2);
        n = N;
        p = randperm(N, round(n/2));
        temp = zeros(1, N);
        temp(p) = 1;
        temp = logical(temp);
        parent1 = pop(temp, :);
        parent2 = pop(~temp, :);
        n = min(size(parent1,1),size(parent2,1));
        cut = randperm(range_max - range_min, 1);
        k = repmat(1:Vars,n,1) > repmat(randi(cut + range_min, n,1),1,Vars);
        offspring1    = parent1;
        offspring2    = parent2;
        offspring1(k) = parent2(k);
        offspring2(k) = parent1(k);
        offspring     = [offspring1;offspring2]; 
   end
   
   function offspring = kBitCross(pop, obj)
        N = size(pop, 1);
        parent1 = pop;
        parent2 = pop(TournamentSelection(2, N, obj(:, 2)), :);
        offspring = pop;
        for i = 1 : N
            k = find(xor(parent1(i, :), parent2(i, :)));
            t = length(k);
            if t > 1
                j = k(randperm(t, randi(t - 1, 1)));
                offspring(i, j) = parent2(i, j);
            end
        end

   end
   
  

   
   