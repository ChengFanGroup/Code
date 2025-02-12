function newpop = GeneticOpt(pop,boundary)
%模拟二进制交叉（1）+多项式变异（0.3）
%   此处显示详细说明
    [popsize,V] = size(pop);
    newpop = zeros(popsize,V);
    
    miu = 1; % 交叉：计算beta的参数
    miu2 = 5; %变异：计算delta的参数
    for i = 1:2:popsize-1
        x1 = pop(i,:);
        x2 = pop(i+1,:);
        y1 = pop(i,:);
        y2 = pop(i+1,:);
        %模拟二进制交叉
        for j = 1:V
            randnum = rand(1);
            if randnum<=0.5
               beta = (randnum*2)^(1/(1+miu));
            else
               beta = 1/((2*(1-randnum))^(1/(1+miu)));
            end
            y1(j) = 0.5*((1+beta)*x1(j)+(1-beta)*x2(j));
            y2(j) = 0.5*((1-beta)*x1(j)+(1+beta)*x2(j));
        end
        %多项式变异
        if(rand(1)<1/V)%变异概率
            for j = 1:V
                randnum = rand(1);
                if(randnum<0.5)
                    delta = (2*randnum)^(1/(miu2+1))-1;
                else
                    delta = 1-(2*(1-randnum))^(1/(miu2+1));
                end
                    y1(j)=y1(j)+delta;
            end
        end
        %越界处理
          Max = boundary(1,:);
          Min = boundary(2,:);
          y1(y1>Max) = Max(y1>Max);
          y1(y1<Min) = Min(y1<Min);
          y2(y2>Max) = Max(y2>Max);
          y2(y2<Min) = Min(y2<Min);
        %存储新解y1，y2
          newpop(i,:) = y1;
          newpop(i+1,:) = y2;
    end
end

