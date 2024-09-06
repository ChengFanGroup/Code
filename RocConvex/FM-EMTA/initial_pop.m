function population = initial_pop(popnum,P_Maxlength,Index_Fs,TaskFlag)
%INITIAL_POP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
        minvalue = repmat(ones(1,P_Maxlength),popnum,1)*(-1);
        maxvalue = repmat(ones(1,P_Maxlength),popnum,1);
        population = rand(popnum,P_Maxlength).*(maxvalue-minvalue) + minvalue;
        for i = 1 : size(Index_Fs,1)
            Index_F = Index_Fs(i,:);
            population(TaskFlag==i , Index_F == 0) = 0; 
        end
end

