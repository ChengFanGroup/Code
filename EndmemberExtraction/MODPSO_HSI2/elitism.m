function [x,f_idx] = elitism( pop_num,new_pop,pF,MF,c_distance )
for i=1:MF
    F(i).ss=[];
    F(i).ss=find(pF(1,:)==i);
end
f_idx=zeros(1,pop_num);
F(i+1).ss=find(pF(1,:)==inf);
a=length(F(1).ss);
[~,p]=size(new_pop);
x=zeros(pop_num,p);
if a>=pop_num
    for i=1:pop_num
        x(i,:)=new_pop(F(1).ss(i),:);
        f_idx(1,i)=F(1).ss(i);
    end
else
    d=[];
    i=2;
    while a<pop_num
        c=a;
        a=a+length(F(i).ss);
        for j=1:length(F(i-1).ss)
            d=[d,F(i-1).ss(j)];
        end
        b=i;
        i=i+1;
    end
    for j=1:c
        x(j,:)=new_pop(d(j),:);
        f_idx(1,j)=d(j);
    end
    temp=zeros(length(F(b).ss),2);
    for j=1:length(F(b).ss)
        temp(j,1)=c_distance(F(b).ss(j));
        temp(j,2)=F(b).ss(j);
    end
    [~,idx]=sort(temp(:,1));
    temp=temp(idx,:);
    for j=1:(pop_num-c)
        x(c+j,:)=new_pop(temp(length(temp)-j+1,2),:);
        f_idx(1,c+j)=temp(length(temp)-j+1,2);
    end
end
