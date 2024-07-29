function fit = LOOCV_KNN(dataX,dataY,Pop)
%KNN 比fitcknn快1/3,事实上还能更快
%   此处显示详细说明
    global evaluateTime;
    evaluateTime = evaluateTime + size(Pop,1);
    errorFun = @getBalanceError;
    popSize = size(Pop,1);
    featureNum = sum(Pop,2);
    maxFeatureNum = max(featureNum);
    error = ones(popSize,1);
    for j = 1:popSize
        if featureNum(j)~=0
            bool = boolean(Pop(j,:));
            data = dataX(:,bool);
            label = dataY;
            Dis = pdist2(data,data,'cityblock');
            Dis(logical(eye(size(data,1)))) = Inf;
            [~,index] = min(Dis,[],2);
            y = label(index);
            error(j) = errorFun(y,label);                      
        else
            featureNum(j) = maxFeatureNum;
        end
    end
    fit = [error,featureNum];
end

