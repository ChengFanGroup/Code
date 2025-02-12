function     y = gen_jiaocha_bianyi( x1, x2)
global x_max x_min 
% SBX 模拟二进制交叉
yita1 = 2 ;
x_num=length(x1);

for i=1:x_num
    r=rand;
    if r<=0.5
        beta=(2*r)^(1/(1+yita1));
    else
        beta=1/((2*(1-r))^(1/(1+yita1)));
    end
    
    y(i)=round(0.5*((1-beta)*x1(i)+(1+beta)*x2(i)));
    %规范后代范围
    if(y(i)>x_max)
       y(i)=round(x_max*rand());
    elseif(y(i)<x_min)
       y(i)=round(x_max*rand());
    end
end
    
% 多项式变异
if rand<1/x_num
    yita2=5;
    r=randperm(x_num);
    ind=r(1);        %选中变异的位置
    r=rand; 
    if r<0.5
        delta=(2*r)^(1/(1+yita2))-1;
    else
        delta=1-(2*(1-r))^(1/(yita2+1));
    end
    y(ind)=round(y(ind)+delta*(x_max-x_min));
     %规范后代范围
    if(y(ind)>x_max)
       y(ind)=round(x_max*rand());
    elseif(y(ind)<x_min)
       y(ind)=round(x_max*rand());
    end
end

