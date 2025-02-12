function [pop,boundary] = initializePop(popsize,V)
%初始种群+规定种群范围（-1~1）
    pop = rand(popsize,V);
    pop = pop.*2-1;
    boundary = zeros(2,V);
    boundary(1,1:V) = boundary(1,1:V)+1;
    boundary(2,1:V) = boundary(2,1:V)-1;
end

