function [Population,FunctionValue] = EnvironmentalSelection(Population,pop1,FunctionValue,dataUN,dataPositive)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
N=100;
        [aim1,aim2] = Fitness(pop1,dataUN,dataPositive);
    FunctionValue2= [aim1,aim2];
     Population = [Population;pop1];
      FunctionValue = [FunctionValue;FunctionValue2];
     
    [FrontNo,MaxFront] = ND_sort(FunctionValue,'half');
    Cdistance   = distance(FunctionValue,FrontNo);
 
        Next        = zeros(1,N);
        NoN         = numel(FrontNo,FrontNo<MaxFront);
        Next(1:NoN) = find(FrontNo<MaxFront);
        
        Last          = find(FrontNo==MaxFront);
        [~,Rank]      = sort(Cdistance(Last),'descend');
        Next(NoN+1:N) = Last(Rank(1:N-NoN));
        
        Population    = Population(Next,:);
     %   FrontNo    = FrontNo(Next);
       FunctionValue = FunctionValue(Next,:);
      %  CrowdDistance = CrowdDistance(Next);
end

