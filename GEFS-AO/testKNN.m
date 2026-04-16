function [preLabel] = testKNN(trainX,trainY,testX,neighborNum)
%KNN 比fitcknn快1/3,事实上还能更快
%   此处显示详细说明
%     global knn_neighborsNum;
%     neighborNum = 5;
    
    Dis = pdist2(testX,trainX,'euclidean');
    
    testNum = size(testX,1);
    neighborPosition = zeros(testNum,neighborNum); 
    
    for i= 1:neighborNum
        [~,minPos]  = min(Dis,[],2);
        neighborPosition(:,i) = minPos;
        
        for j = 1:testNum
           Dis(j,minPos(j)) = inf; 
        end
    end
    
    for ii=1:testNum
        y(ii,:)=trainY(neighborPosition(ii,:))';
    end
%     y = trainY(neighborPosition);
   
    preLabel = mode(y,2);
    
%     NumNeighbors = 10;
%     Mdl = fitcknn(trainX,trainY,NumNeighbors=NumNeighbors);
%     label = predict(Mdl,testX);
end