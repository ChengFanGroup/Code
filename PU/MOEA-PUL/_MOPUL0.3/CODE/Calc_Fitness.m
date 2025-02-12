% 
% Created by Guanglong Fu, BIMK, 2019
%
% Parameters:
%               Population:  Current Population
%               evaluation1: The scores estimated by classfier trained via guessed label
%               evaluation2: The accurancy on Positive data
% Outputs:
%               aim1:        Use 1 minus the accurancy of the ground truth 
%                            Positive data
%               aim2:        Score-based fitness
% Use:
%               The second step to calculate two aims' fitness

function [aim1,aim2] =Calc_Fitness(population ,evaluation1,evaluation2)
%%目标函数分为两部分;一是当前模型在正样本上的分类正确率，二是基于预测值，考察排在每一个负样本后的正样本数目，最后求和
     aim1 = zeros(size(population,1),1);
     aim2 = zeros(size(population,1),1);

     unlabeledNum = size(population,2); 
     
     for i = 1:size(population,1)
         [scores,index]=sort(evaluation1(i,:),'descend');
         label = population(i,index);
         sortedScores = [scores;label];
         % if this label is negative then calculate the number of positive
         % label whose score is smaller then this label
         
         for j = 1:size(population,2)-1
             if sortedScores(2,j)==0
                 aim2(i,1) = aim2(i,1) + sum(sortedScores(2,j+1:end));
             end   
         end
         
         aim1(i,1) =  1-evaluation2(i,1);
          %Normalization second aim
         aim2(i,1) =  aim2(i,1)/(unlabeledNum*(unlabeledNum-1)/2); 
        
     end
end