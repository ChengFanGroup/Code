function population = initial_pop(popnum,P_Maxlength,Index_Fs,TaskFlag)
%INITIAL_POP 此处显示有关此函数的摘要
%   此处显示详细说明
        minvalue = repmat(ones(1,P_Maxlength),popnum,1)*(-1);
        maxvalue = repmat(ones(1,P_Maxlength),popnum,1);
        population = rand(popnum,P_Maxlength).*(maxvalue-minvalue) + minvalue;
        for i = 1 : size(Index_Fs,1)
            Index_F = Index_Fs(i,:);
            population(TaskFlag==i , Index_F == 0) = 0; 
        end
end

