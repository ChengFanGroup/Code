function pop = mutation(pop,ProM)
 %标准变异
 [MaxOffspring,D]=size(pop);
 k    = rand(MaxOffspring,D);
 Temp = k<=ProM;%%%%%%%%%小于0.1为1
 pop(Temp) = 1-pop(Temp);