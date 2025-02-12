function     [off1,off2] = SBX( x1, x2,n)
% SBX 模拟二进制交叉
yita1 = 1;
x_num=length(x1);
off1=zeros(1,x_num);
off2=zeros(1,x_num);
for i=1:x_num
    r=rand;
    if r<=0.5
        beta=(2*r)^(1/(1+yita1));
    else
        beta=1/((2*(1-r))^(1/(1+yita1)));
    end
    
    off1(i)=round(0.5*((1-beta)*x1(i)+(1+beta)*x2(i)));
    off2(i)=round(0.5*((1-beta)*x2(i)+(1+beta)*x1(i)));
    %规范后代范围
    while(off1(i)>=n)||(off1(i)<1)
       off1(i)=round(n*rand());
    end
    while(off2(i)>=n)||(off2(i)<1)
       off2(i)=round(n*rand());
    end    
end
    
% 多项式变异
if rand<1/(x_num*2)
    yita2=5;
    r=randperm(x_num);
    ind=r(1);        %选中变异的位置
    r=rand; 
    if r<0.5
        delta=(2*r)^(1/(1+yita2))-1;
    else
        delta=1-(2*(1-r))^(1/(yita2+1));
    end
    off1(ind)=round(off1(ind)+delta*n);
    off2(ind)=round(off2(ind)+delta*n);
     %规范后代范围
    while(off1(ind)>n)||(off1(ind)<1)
       off1(ind)=round(n*rand());
    end
    while(off2(ind)>n)||(off2(ind)<1)
       off2(ind)=round(n*rand());
    end

end
temp1=unique(off1);
if length(temp1)<x_num
    m1=randperm(n,x_num-length(temp1));
    temp1=[temp1,m1];
    off1=temp1;
end     
temp2=unique(off2);
if length(temp2)<x_num
    m2=randperm(n,x_num-length(temp2));
    temp2=[temp2,m2];
    off2=temp2;
end 
end

