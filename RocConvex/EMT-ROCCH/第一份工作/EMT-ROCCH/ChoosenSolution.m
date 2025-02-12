function [returnindex] = ChoosenSolution(Type,FN,CD,traSlonum)
%CHOOSENSOLUTION 此处显示有关此函数的摘要
%   此处显示详细说明
        A = [FN',-CD'];
    if Type==1
        [~,index] = sortrows(A);
        returnindex = index(1:traSlonum);
    elseif Type==2
        [~,index] = sortrows(A,'descend');
        returnindex = index(1:traSlonum);
    end
    
end

