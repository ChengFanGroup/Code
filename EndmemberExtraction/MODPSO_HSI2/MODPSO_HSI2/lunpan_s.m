function [newpop] = lunpan_s(p,fitvalue)      
fitvalue=1./fitvalue;
totalfit = sum(fitvalue);
p_fitvalue = fitvalue./totalfit;     %每个适应度对应的概率
p_fitvalue = cumsum(p_fitvalue);        %概率列向量向下累加成一列
ms = sort(rand(p,1));                 %随机点产生，从小到大排列
fitin = 1;
newin = 1;
newpop=[];
while newin <= p
      if(ms(newin)) < p_fitvalue(fitin)      %每个随机点与轮盘比较，点到的位置保留         
          newpop=[newpop,fitin];   %随机点对应的个体保留
          newin = newin+1;
      else
          fitin = fitin+1;
      end
end
end