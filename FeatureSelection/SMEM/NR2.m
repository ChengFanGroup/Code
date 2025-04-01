   function offspring = NR2(pop1, pop2, obj1, obj2, Vars)
    %% choose parents
    offspring = kBitCross(pop1, pop2, obj1, obj2);
        
    for i = 1 : size(offspring, 1)
        k = rand(1, Vars) < 1 / Vars;
        offspring(i, k) = ~offspring(i, k);
    end

    offspring = unique(offspring, 'rows');
    
   end
   
   function offspring = kBitCross(pop1, pop2, obj1, obj2)
        N = min(size(pop1, 1), size(pop2, 1));
        parent1 = pop1;
        parent2 = pop2;
        offspring = pop1;
        for i = 1 : N
            k = find(xor(parent1(i, :), parent2(i, :)));
            t = length(k);
            if t > 1
                j = k(randperm(t, randi(t - 1, 1)));
                offspring(i, j) = parent2(i, j);
            end
        end

   end
   
   
   
   

   
   