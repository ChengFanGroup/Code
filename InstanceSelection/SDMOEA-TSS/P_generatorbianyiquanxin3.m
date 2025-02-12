function Offspring = P_generatorbianyiquanxin3(MatingPool,Boundary,Coding,MaxOffspring,i2,pop,pop_index)
% 交叉,变异并生成新的种群
% 输入: MatingPool,   交配池, 其中每第i个和第i+1个个体交叉产生两个子代, i为奇数
%       Boundary,     决策空间, 其第一行为空间中每维的上界, 第二行为下界
%       Coding,       编码方式, 不同的编码方式采用不同的交叉变异方法
%       MaxOffspring, 返回的子代数目, 若缺省则返回所有产生的子代, 即和交配池的大小相同
% 输出: Offspring, 产生的子代新种群

    [N,D] = size(MatingPool);
    if nargin < 3 || MaxOffspring < 1 || MaxOffspring > N
        MaxOffspring = N;
    end
    
    switch Coding
        %实值交叉、变异
        case 'Real'
            %遗传操作参数
            ProC = 1;       %交叉概率
            ProM = 1/D;     %变异概率
            DisC = 20;   	%交叉参数
            DisM = 20;   	%变异参数

            %模拟二进制交叉
            Offspring = zeros(N,D);
            for i = 1 : 2 : N
                beta = zeros(1,D);
                miu  = rand(1,D);
                beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
                beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
                beta = beta.*(-1).^randi([0,1],1,D);
                beta(rand(1,D)>ProC) = 1;
                Offspring(i,:)   = (MatingPool(i,:)+MatingPool(i+1,:))/2+beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
                Offspring(i+1,:) = (MatingPool(i,:)+MatingPool(i+1,:))/2-beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
            end
            Offspring = Offspring(1:MaxOffspring,:);

            %多项式变异
            if MaxOffspring == 1
                MaxValue = Boundary(1,:);
                MinValue = Boundary(2,:);
            else
                MaxValue = repmat(Boundary(1,:),MaxOffspring,1);
                MinValue = repmat(Boundary(2,:),MaxOffspring,1);
            end
            k    = rand(MaxOffspring,D);
            miu  = rand(MaxOffspring,D);
            Temp = k<=ProM & miu<0.5;
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
            Temp = k<=ProM & miu>=0.5; 
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));

            %越界处理
            Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
            Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
            
        %二进制交叉、变异
        case 'Binary'
            %均匀交叉并和邻域交叉
            b1=4/5;
            b2=1/5;
            Offspring1 = zeros(round(33*b1),D);
            m=round(size(MatingPool,1)*b1);%%选2/3自己交叉，剩余1/3邻域交叉
            if mod(m,2)==1
                m1=m-1;
            else
                m1=m;
            end
            for i = 1 : 2 : m1
                k = logical(randi([0,1],1,D));
                Offspring1(i,:)   = MatingPool(i,:);   
                Offspring1(i+1,:) = MatingPool(i+1,:);
                Offspring1(i,k)   = MatingPool(i+1,k);
                Offspring1(i+1,k) = MatingPool(i,k);
            end
            if floor(26/m1)~=1
                for i=1:(floor(26/m1)-1)
                Offspring1=[Offspring1;Offspring1];  
                end
            end
            if m1<26
              Offspring1 = [Offspring1;MatingPool(1:(26-size(Offspring1,1)),:)];
              else
              Offspring1=Offspring1(1:26,:);   
            end
            %%%对于matingpool中剩余个体领域交叉
            m2=round(size(MatingPool,1)*b2);
            jiaopeichi=MatingPool(m+1:end,:);
            if i2==1
                a=pop_index{1,i2+1};
                b=a(randperm(length(a)));
                b=b(1);
                p=pop{1,i2+1};
                p=p(b,:);    %%%随机选出第二区域的第一前沿面的一个个体
                Offspring2=jiaopeichi;
                for i=1:m2
                    k = logical(randi([0,1],1,D));         
                    Offspring2(i,k)=p(1,k);
                end 
                Offspring=[Offspring1;Offspring2];
                if size(Offspring,1)<33
                    Offspring=[Offspring;MatingPool(1:(33-size(Offspring,1)),:)];
                else
                    Offspring=Offspring(1:33,:);
                end
                    
            end

            if i2==2
               a1=pop_index{1,i2-1};
               b1=a1(randperm(length(a1)));
               b1=b1(1);
               p1=pop{1,i2-1};
               p1=p1(b1,:);    %%%随机选出第一区域的第一前沿面的一个个体
               a2=pop_index{1,i2+1};
               b2=a2(randperm(length(a2)));
               b2=b2(1);
               p2=pop{1,i2+1};
               p2=p2(b2,:);    %%%随机选出第三区域的第一前沿面的一个个体
               m3=round(m2*0.5);
               Offspring2=jiaopeichi(1:m3,:);
               Offspring3=jiaopeichi(m3+1:end,:);
               for i=1:m3
                  k = logical(randi([0,1],1,D));
                  Offspring2(i,k)=p1(1,k);
               end
                for i=1:(m2-m3)
                  k = logical(randi([0,1],1,D));
                  Offspring3(i,k)=p2(1,k);
                end
            Offspring=[Offspring1;Offspring2;Offspring3];
             if size(Offspring,1)<33
                    Offspring=[Offspring;MatingPool(1:(33-size(Offspring,1)),:)];
                else
                    Offspring=Offspring(1:33,:);
             end
            end
            if i2==3
                a=pop_index{1,i2-1};
                b=a(randperm(length(a)));
                b=b(1);
                p=pop{1,i2-1};
                p=p(b,:);    %%%随机选出第二区域的第一前沿面的一个个体
                Offspring2=jiaopeichi;
                for i=1:m2
                    k = logical(randi([0,1],1,D));         
                    Offspring2(i,k)=p(1,k);
                end    
            Offspring=[Offspring1;Offspring2];
            if size(Offspring,1)<33
                    Offspring=[Offspring;MatingPool(1:(33-size(Offspring,1)),:)];
                else
                    Offspring=Offspring(1:33,:);
            end
            end
            %%%不同i2变异不一样
             if i2==1
             pm0=0.05;
             pm1=0.15;
            elseif i2==2
               pm0=0.05;
               pm1=0.15;
            elseif i2==3
                 pm0=0.05;
                 pm1=0.15;
             end
      if i2==1
           for i=1:2:32   %%交叉里压缩
               for j=1:D
                   if Offspring(i,j)~=Offspring(i+1,j)
                      if rand(1,1)<0.5
                         if Offspring(i,j)==1
                          Offspring(i,j)=0;
                        elseif Offspring(i,j)==0
                             if rand(1,1)<0.15
                                 Offspring(i,j)=1;
                             end
                          end
                      %%第二个子代
                       if Offspring(i+1,j)==1
                          Offspring(i+1,j)=0;
                         elseif Offspring(i+1,j)==0
                            if rand(1,1)<0.15
                              Offspring(i+1,j)=1;
                            end
                        end
                      end
                   end
               end
            end
      end
            
            %%%%%变异操作
            for h=1:33
            for i=1:D %---------------------变异
                    if(Offspring(h,i)==0)
                        if rand(1,1)<pm1
                            Offspring(h,i)=1;
                        end
                    end
                    if(Offspring(h,i)==1)
                        if rand(1,1)<pm0
                            Offspring(h,i)=0;
                        end
                    end
             end
                while(1)
                if(sum(Offspring(h,:))==0)||(sum(Offspring(h,:))==1)  
                  Offspring(h,:)=restart(D);%重开始
                end
                  if sum(Offspring(h,:))>1
                      break;
                 end
                end
            end
            
        %用于0-1背包问题的二进制交叉、变异
        case 'Binary-MOKP'
            %遗传操作参数
            ProM = 0.01;	%变异概率
            %均匀交叉
            Offspring = zeros(N,D);
            for i = 1 : 2 : N
                k = logical(randi([0,1],1,D));
                Offspring(i,:)   = MatingPool(i,:);   
                Offspring(i+1,:) = MatingPool(i+1,:);
                Offspring(i,k)   = MatingPool(i+1,k);
                Offspring(i+1,k) = MatingPool(i,k);
            end
            Offspring = Offspring(1:MaxOffspring,:);

            %改进的点翻转变异
            for i=1:N
                c=find(Offspring(i,:)==1);
                c1=randsrc(size(c,2),1,[1 0; 0.95 0.05]);
                Offspring(i,c)=c1';
              if c==0
                  Offspring(i,:)=randsrc(1,D,[0,1]);
                  c=find(Offspring(i,:)==1);
               else
               end
            end
            for i=1:N
                c0=find(Offspring(i,:)==0);
                if c0==D
                   Offspring(i,:)=randsrc(1,D,[0,1]);
                   c0=find(Offspring(i,:)==0);
                else
                end
                c2=randsrc(size(c0,2),1,[1 0; 0.001 0.999]);
                Offspring(i,c0)=c2';
            end

            %修复
            Offspring = P_objective('repair','MOKP',NaN,Offspring);
    end
end