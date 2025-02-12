function [pop,obj] = Diversity_ES(pop, popsize, obj, epsilon)
%% delete dup solution
    Pop = [pop,obj];
    Pop = unique(Pop,'rows');
    pop = Pop(:,1:end - 2);
    obj = Pop(:,end-1:end);
   
%% Epsilon-constraint
    d = pdist2(obj,[0,0]);
    feasible = d <= epsilon;
    if size(pop,1) > popsize
        if sum(feasible) >= popsize
            [pop, obj] = EnvironmentalSelection(pop(feasible,:), popsize, obj(feasible,:));
        else
            infeasible = ~feasible;
            pop1 = pop(infeasible,:);
            obj1 = obj(infeasible,:);
            d = pdist2(obj1,[0,0]);
            [~,s] = sort(d);
            pop = [pop(feasible,:);pop1(s(1:popsize - sum(feasible)),:)];
            obj = [obj(feasible,:);obj1(s(1:popsize - sum(feasible)),:)];
        end
    end
end