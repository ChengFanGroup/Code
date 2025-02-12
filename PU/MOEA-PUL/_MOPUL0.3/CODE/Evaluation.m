 % 
% Created by Guanglong Fu, BIMK, 2019
%
% Parameters:
%               Population: Current Population
%               dataUN:     Unlabeled data
%               dataPos:    Positive data
% Outputs:
%               evaluation1: The scores estimated by classfier trained via guessed label
%               evaluation2: the accurancy on Positive data
% Use:
%               The first step to calculate two aims' fitness

function [evaluation1,evaluation2] = Evaluation(Population,dataUN,dataPos)
     [r,c] = size(Population);
     evaluation1 = zeros(r,c);
     evaluation2 =  zeros(r,1);
     
% ----------------------------------First aim------------------------------
     for i =1:r
         guessedP = dataUN(:,Population(i,:)==1);
         guessedN = dataUN(:,Population(i,:)==0);
         X = [dataPos,guessedP,guessedN];%full training 
         train_instance = sparse(X);
         Y = [ones(size([dataPos,guessedP],2),1);ones(size(guessedN,2),1)*(-1)];
         train_label = Y;
         model = train(train_label, train_instance');
    
         W = model.w;
         evaluation1(i,:) = W*dataUN;% the scores of every unlabeled datas.
 % -------------------------------Second aim-------------------------------
  % predict ground-truth positive label use model trained by guessed label.
         labelPos = ones(size(dataPos,2),1);
          test_instance = sparse(dataPos');
         [~, accuracy, ~] = predict(labelPos,test_instance, model);
         evaluation2(i,1) = accuracy(1)/100;
     end
end
