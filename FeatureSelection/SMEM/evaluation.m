function obj = evaluation(pop, Vars, traindata, trainlabel)
%   objective1 - the number of select features
%   objective1 - classification error rate
%     global choice;
%     temp = pop > choice;
%     if (sum(temp) == 0) 
%         add = randperm(Vars, Vars / 10);
%         temp(add) = 1;
%     end
    %% objective1 
    temp = pop;
%     if (sum(temp) == 0) 
%         add = randperm(Vars, 1);
%         temp(add) = 1;
%     end
    f1 = sum(temp) / Vars;
    
    %% objective2
%     f2 = KNNClassifier(traindata, trainlabel, temp);
    f2 = KNNLOOCV(traindata, trainlabel, temp);
    obj = [f1, f2];
end