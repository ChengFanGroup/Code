function [F,popfit] = non_domination_sort(pop_num,popfit,f_num)
pareto_rank = 1;
F(pareto_rank).ss=[];%pareto等级为pareto_rank的集合
p=[];%每个个体p的集合
for i = 1:pop_num
    %%%计算出种群中每个个体p的被支配个数n和该个体支配的解的集合s
    p(i).n=0;%支配i个体数目n
    p(i).s=[];%i支配的解的集合s
    for j = 1:pop_num
        less=0;%目标函数值小于个体的目标函数值数目
        equal=0;%目标函数值等于个体的目标函数值数目
        greater=0;%目标函数值大于个体的目标函数值数目
        for k = 1:f_num
            if (popfit(i,k)<popfit(j,k))
                less = less + 1;
            elseif (popfit(i,k)==popfit(j,k))
                equal = equal +1;
            else
                greater =  greater + 1;
            end
        end
        if (less == 0 && equal ~= f_num)
            p(i).n = p(i).n + 1;%支配i个体数目n+1
        elseif (greater == 0 && equal~=f_num)
            p(i).s=[p(i).s j];%i支配j,j并入集合
        end
    end
        %%%将种群中参数为n的个体放入集合F(1)中
    if (p(i).n==0)
        popfit(i,f_num+2)=1;%储存个体的等级信息
        F(pareto_rank).ss=[F(pareto_rank).ss i];
    end
end
%%%求pareto等级
while ~isempty(F(pareto_rank).ss)
    temp=[];
    for i=1:length(F(pareto_rank).ss)
        if  ~isempty(p(F(pareto_rank).ss(i)).s) 
            for j=1:length(p(F(pareto_rank).ss(i)).s)
                p(p(F(pareto_rank).ss(i)).s(j)).n = p(p(F(pareto_rank).ss(i)).s(j)).n-1;
                if p(p(F(pareto_rank).ss(i)).s(j)).n == 0
                    %储存个体的等级信息
                    popfit(p(F(pareto_rank).ss(i)).s(j),f_num+2)=pareto_rank+1;
                    temp = [temp p(F(pareto_rank).ss(i)).s(j)];
                end
            end
        end
    end
    pareto_rank=pareto_rank+1;
    F(pareto_rank).ss=temp;
end
end