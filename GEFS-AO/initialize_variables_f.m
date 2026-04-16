function [f] = initialize_variables_f(N, M, V)



f = randi([0,1], N, V); % f 为种群,V 为长度


% f = f.*logical(templateAdj).*templateAdj;

for i = 1 : N
   
    [f(i,V + 1: V+M)] = evaluate_objective_f(M,f(i,1:V));
end