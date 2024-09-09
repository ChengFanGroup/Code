function Offspring = KnowTransferCrossover(MatingPool,guidingSolutions,Boundary,MaxOffspring,Index_F)
% 
% 输入: MatingPool,   交配池, 其中每第i个和第i+1个个体交叉产生两个子代, i为奇数
%       Boundary,     决策空间, 其第一行为空间中每维的上界, 第二行为下界
%       Coding,       编码方式, 不同的编码方式采用不同的交叉变异方法
%       MaxOffspring, 返回的子代数目, 若缺省则返回所有产生的子代, 即和交配池的大小相同
% 输出: Offspring, 产生的子代新种群
    
        N = MaxOffspring;
        D = size(MatingPool,2);
        %实值交叉、变异
        %遗传操作参数
        Index_C = find(Index_F==1);

        %模拟二进制交叉-每次交叉生成一个解
        Offspring = zeros(N,D);
        for i = 1 : N
            Index_k = Index_C(randi([1,length(Index_C)],1,1));
            Offspring(i,:) = MatingPool(i,:);
            ProC = rand(1)*0.3 + 0.2;       %交叉概率
            r = randi([1,size(guidingSolutions,1)]);%随机引导解
            x2 = guidingSolutions(r,:);
            for j = Index_C
                if (j == Index_k || rand(1) < ProC)
                    Offspring(i,j)   = x2(1,j);
                end
            end
        end
        


        %多项式变异
        MaxValue = repmat(Boundary(1,:),N,1);
        MinValue = repmat(Boundary(2,:),N,1);

        %越界处理
        Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
        Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
            
            
end