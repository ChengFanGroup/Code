function c_distance = crowding_distance_sort( F,popfit)

%%%按照pareto等级对种群中的个体进行排序
[pop_num,~]=size(popfit);
c_distance=zeros(pop_num,1);
for i=1:length(F)-1
    temp1=zeros(length(F(i).ss),2);
    temp2=zeros(length(F(i).ss),2);
    for j=1:length(F(i).ss)
        temp1(j,1)=popfit(F(i).ss(j),1);
        temp1(j,2)=F(i).ss(j);
        temp2(j,1)=popfit(F(i).ss(j),2);
        temp2(j,2)=F(i).ss(j);
    end
    [~,idx1]=sort(temp1(:,1));
    temp1=temp1(idx1,:);
    [~,idx2]=sort(temp2(:,1));
    temp2=temp2(idx2,:);
    c_distance(temp1(1,2))=inf;
    c_distance(temp1(length(F(i).ss),2))=inf;
    f1_min=temp1(1,1);
    f1_max=temp1(length(F(i).ss),1);
    f2_min=temp2(1,1);
    f2_max=temp2(length(F(i).ss),1);
    a=2;
    while a<length(F(i).ss)
        c_distance(temp1(a,2))=(temp1(a+1,1)-temp1(a-1,1))/(f1_max-f1_min)+(temp2(a+1,1)-temp2(a-1,1))/(f2_max-f2_min);
        a=a+1;
    end
end

end

