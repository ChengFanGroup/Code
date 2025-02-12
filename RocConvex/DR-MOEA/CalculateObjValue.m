function obj_value = CalculateObjValue(pop,P_set,T_set)
%计算当前分类器种群的目标值FPR、TPR
%   此处显示详细说明
    [popsize,V] = size(pop);
    [datanum,~] = size(P_set);
    obj_value = zeros(popsize,2);
    
    for i = 1:popsize
        temp = zeros(datanum,V);
        for t = 1:datanum
            temp(t,:) = pop(i,:);
        end
        %分类，分类结果在Test_T中
        temp = temp.*P_set;
        Test_T = sum(temp,2);
        for k = 1:datanum
            if(Test_T(k)>=0)
                Test_T(k) = 1;
            else
                Test_T(k) = -1;
            end
        end
        %计算TPR、FPR
        FN=0;TN=0;FP=0;TP=0;
        tempT = Test_T+T_set;
        for j = 1:datanum
            if tempT(j)==3
                TP = TP + 1;
            elseif tempT(j)==2
                FP = FP + 1;
            elseif tempT(j)==1
                FN = FN + 1;
            else
                TN = TN + 1;
            end
        end
        obj_value(i,1) = FP/(FP+TN);
        obj_value(i,2) = TP/(FN+TP);
    end
end

