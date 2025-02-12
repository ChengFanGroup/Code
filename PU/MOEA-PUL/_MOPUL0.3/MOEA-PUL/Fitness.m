
function [aim1,aim2] =Fitness(population ,dataUN,dataPos)
%%目标函数分为两部分;一是当前模型在正样本上的分类正确率，二是基于预测值，考察排在每一个负样本后的正样本数目，最后求和
    [r,c] = size(population);
     evaluation1 = zeros(r,c);
     evaluation2 =  zeros(r,1);
     
% ----------------------------------First aim------------------------------
     for i =1:r
         guessedP = dataUN(:,population(i,:)==1);
         guessedN = dataUN(:,population(i,:)==0);
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

