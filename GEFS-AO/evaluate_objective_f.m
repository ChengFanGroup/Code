function [f]  = evaluate_objective_f(M, individual_adj)
% 返回 featIdx  在将编码转换为sample个体时使用
% global featSetAndMdlMap  featNumMap  featAccMap;
global   trData   trLabel data label trIdx;
global OMEGA DELT;
global  Ecout

Ecout=Ecout+1;
%% function f = evaluate_objective(x, M, V)
% Function to evaluate the objective functions for the given input vector
% x. x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% V is the number of decision variables. 
%
% This functions is basically written by the user who defines his/her own
% objective function. Make sure that the M and V matches your initial user
% input. Make sure that the 
%
% An example objective function is given below. It has two six decision
% variables are two objective functions.

% f = [];
% %% Objective function one
% % Decision variables are used to form the objective function.
% f(1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
% sum = 0;
% for i = 2 : 6
%     sum = sum + x(i)/4;
% end
% %% Intermediate function
% g_x = 1 + 9*(sum)^(0.25);
% 
% %% Objective function two
% f(2) = g_x*(1 - ((f(1))/(g_x))^2);

%% Kursawe proposed by Frank Kursawe.
% Take a look at the following reference
% A variant of evolution strategies for vector optimization.
% In H. P. Schwefel and R. M鋘ner, editors, Parallel Problem Solving from
% Nature. 1st Workshop, PPSN I, volume 496 of Lecture Notes in Computer 
% Science, pages 193-197, Berlin, Germany, oct 1991. Springer-Verlag. 
%
% Number of objective is two, while it can have arbirtarly many decision
% variables within the range -5 and 5. Common number of variables is 3.
f = [];
% Objective function one
% sum = 0;
% for i = 1 : V - 1
%     sum = sum - 10*exp(-0.2*sqrt((x(i))^2 + (x(i + 1))^2));
% end
% % Decision variables are used to form the objective function.
% f(1) = sum;
% 
% % Objective function two
% sum = 0;
% for i = 1 : V
%     sum = sum + (abs(x(i))^0.8 + 5*(sin(x(i)))^3);
% end
% % Decision variables are used to form the objective function.
% f(2) = sum;

% corrMatrix =  cutAdjMatrix(RMatrix, THRESHOLD, 0);

if ~sum(any(individual_adj)) % ==0 说明矩阵所有元素为零
    f = [10000, 10000]; % 上个版本次数可能有误，不应为[-inf, inf]
    
else
    X = individual_adj;
    qdata = [];
    qdata = trData;
    qdata = qdata(:, (X>0));
    dist = pdist2(qdata, qdata);
    [~, idx] = min(dist + eye(size(qdata, 1)) * max(max(dist) * 2), [], 2);
    y = trLabel(idx);
    y = y == trLabel;
    acc = sum(y) / numel(y);
    err = 1 - acc;
    er= err;
    fm = sum(X);
    f = [er,fm];

    

 
    
    
    
   
end
% 如果是新个体，则加入历史记录中
% if ~isKey(featSetAndMdlMap,THRESHOLD)
%     featSetAndMdlMap(THRESHOLD) = struct('featIdx',featIdx, 'Mdl', mdl);
%     featAccMap(THRESHOLD) = f(1);
%     featNumMap(THRESHOLD) = f(2);
% end

%% Check for error
if length(f) ~= M
    error('The number of decision variables does not match you previous input. Kindly check your objective function');
end
end
