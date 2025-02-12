function [solution21] = encode21_new(oral_pop,Index_F,help_pop,Boundary)
%ENCODE21 此处显示有关此函数的摘要
%   此处显示详细说明
     tempSlo = oral_pop(:,Index_F);
     [tralnum,Vnum_hpop] = size(tempSlo);
     solution21 = zeros(tralnum,Vnum_hpop);
     h_num = size(help_pop,1);
     
     for i = 1:tralnum
        dir = tempSlo(i,:)./norm(tempSlo(i,:));
        d = help_pop(randperm(h_num,1),:);
        solution21(i,:) = norm(d).*dir;
     end
     %越界处理
     MaxValue = repmat(Boundary(1,:),tralnum,1);
     MinValue = repmat(Boundary(2,:),tralnum,1);
     solution21(solution21>MaxValue) = MaxValue(solution21>MaxValue);
     solution21(solution21<MinValue) = MinValue(solution21<MinValue);
end

