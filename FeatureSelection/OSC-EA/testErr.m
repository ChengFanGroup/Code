function [err] = testErr(testX,testY,trainX,trainY,pop)
%TEST 此处显示有关此函数的摘要
%   此处显示详细说明
    errorFun = @getBalanceError;
    popNum = size(pop,1);
    err = ones(popNum,1);
    feature = sum(pop,2);

    for i = 1:popNum
        if feature(i) ~= 0
            featureIndex = boolean(pop(i,:));
            pre = KNN(trainX(:,featureIndex),trainY,testX(:,featureIndex));
            err(i) = errorFun(pre,testY);
        end
    end
    
end

