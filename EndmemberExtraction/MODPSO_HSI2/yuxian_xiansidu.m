function c = yuxian_xiansidu(new_x,X,p,F)

%%%按照pareto等级对种群中的个体进行排序
[pop_num,~]=size(new_x);
c=zeros(1,pop_num);
x_idx=zeros(pop_num,p);
F1=find(F==1);
c(F1)=inf;
for z=1:pop_num
    x_idx(z,:) = find(new_x(z,:)==1);
end
for i=1:pop_num
    if c(i)==0
        temp0=0;
        for j=1:p-1
            for k=j+1:p
                temp=SAM(X(:,x_idx(i,j)),X(:,x_idx(i,k)));
                if temp>temp0
                    temp0=temp;
                end
            end
        end
        c(i)=temp0;
    end
end

end

