function [solution12] = encode12(elite_pop1,Index_F,pop2_Vnum)
%编码由1迁到2种群的解
%   此处显示详细说明
    N = size(elite_pop1,1);
    
    solution12 = zeros(N,pop2_Vnum);
    
    solution12(1:N,Index_F) = elite_pop1;
    
end

