function [pop,obj] = Convergent_ES(pop, popsize, obj, allerr, gen)
    CF = Convergent_sort(obj, allerr, gen);
    p1 = CF == 1;
    pop1 = pop(p1,:);
    obj1 = obj(p1, :);
    N = size(pop,1);
    if N > popsize
        if size(pop1,1) < popsize
            if sum(CF == 2) + sum(CF == 3) >= popsize-size(pop1,1)
                pop2 = [pop(CF == 2,:);pop(CF == 3,:)];
                obj2 = [obj(CF == 2,:);obj(CF == 3,:)];
                d = pdist2(obj2,[0,0]);
                [~,s] = sort(d);
                pop = [pop1;pop2(s(1:popsize-size(pop1,1)),:)];
                obj = [obj1;obj2(s(1:popsize-size(pop1,1)),:)];
            else
                tpop = pop(CF ~= 4,:);
                tobj = obj(CF ~= 4,:);
                pop2 = pop(CF == 4,:);
                obj2 = obj(CF == 4,:);
                d = pdist2(obj2,[0,0]);
                [~,s] = sort(d);
                pop = [tpop;pop2(s(1:popsize-size(tpop,1)),:)];
                obj = [tobj;obj2(s(1:popsize-size(tpop,1)),:)];
            end
    
        else
            d = pdist2(obj1,[0,0]);
            [~,s] = sort(d);
            pop = pop1(s(1:popsize),:);
            obj = obj1(s(1:popsize),:);
        end
    end
    Pop = [pop,obj];
    Pop = unique(Pop,'rows');
    pop = Pop(:,1:end - 2);
    obj = Pop(:,end-1:end);  
end