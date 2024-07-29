function [error] = getBalanceError(predict,label)
%BALANCEERROR According predict and label,then return balance Error
%   predict: predict label
%   label: true label
%   error: error rate
    flag = predict==label;
    
    tbl = tabulate(label);
    labelClass = tbl(:,1);
    classNum = size(tbl,1);
    classAcc = ones(classNum,1);
    for i = 1: classNum
        idx = label == labelClass(i);
        right = sum(flag(idx));
        classAcc(i) = right/tbl(i,2);
    end
    error = 1 - mean(classAcc(~isnan(classAcc)));
end

