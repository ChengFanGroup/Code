%%%辅助种群V的P = P, 使用拥挤,不用DE，采用MP

clear
clc
TIME=clock;
% load Urban_R1621.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %2-dimensional input image  输入的2维图像 ?为什么除以1000

load samson_1.mat
load end3.mat
reference = M;
reference(:,3)=reference(:,3).*0.1;
X = V;

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190

% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100


[L,N] = size(X);
global row;
row = 95;
global col; 
col = 95;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
global P; 
P = 3;   % Number of endmembers
trans = dim_reduction(P,X,image_3d);
X_reduction = trans * X;
%%
%%
%********************************************************************************************************************************************************%
%parameter initialization
NP = 20;%number of particles
maxiter = 200;%maximum number of iterations
%算法的作用就是将初始随机生成的种群pop 通过迭代使个体向这两个根集聚并在结束前达到要求的精确度
global xl xu;
Xmax=N*ones(1,P);
Xmin=1*ones(1,P);%来定义问题中每个变量的搜索范围，两个向量的长度为 P
xl=Xmin;
xu=Xmax;
pop=randperm(N);
pop=pop(1:NP*P);
pop=reshape(pop,P,NP);%P行，NP列矩阵
pop=pop';%转置NP行，P列矩阵
pop1=randperm(N);
pop1=pop1(1:NP*P);
pop1=reshape(pop1,P,NP);
pop1=pop1';%转置NP行，P列矩阵，每行一个个体

F=0.5;%大的缩放因子会导致大幅度的变异操作
CR=0.9;%交叉概率
numb=5;%5
st = 3;%DE mut ways
%--------保存当代目标函数值-------
fx = zeros(NP,2);
for i=1:NP                        % check the remaining members 
    fx(i,1) = 1/volume(X_reduction(:,pop(i,:)));
    fx(i,2) = unmixed(X,X(:,pop(i,:)),3);
end
fx1 = zeros(NP,2);
for i=1:NP                        % check the remaining members 
    fx1(i,1) = 1/volume(X_reduction(:,pop1(i,:)));
    fx1(i,2) = unmixed(X,X(:,pop1(i,:)),1);
end

pop = sort(pop,2);%每一行将独立排序，每个个体在每一行中的值将按升序排列
pop1 = sort(pop1,2);%每个个体像素序号排序
       % best member of current iteration

[F,MF] = NDSort(fx,6);%将fx中个体非支配排序，将排序后的等级存在F中，最佳解的数量存在MF中
F0=find(F(1,:)==1);%非支配排序后第一层中的个体索引
G=pop(F0,:); %存 Pareto 前沿解

[F1,MF1] = NDSort(fx1,6);
F10=find(F1(1,:)==1);
G1=pop1(F10,:);
%%
iter = 0;
while iter < maxiter
    iter = iter+1; 
    index_1=ceil(rand*size(G,1));% 生成一个随机整数索引 index_1，该索引的范围是从1到 G
    bpar = G(index_1,:); %获取随机选中的参考个体bpar      
    pop = sort(pop,2);%每个个体的像元顺序按升序排列。在差分进化算法中，个体通常被表示为像元的顺序，排序有助于确保相应的像元位置正确匹配。
    pop1 = sort(pop1,2);
        %-------遍历种群个体------------
        for j=1:NP/2
            %-------主种群-----------
            a1=TournamentSelection(2,NP/2,fx(:,1),fx(:,2));%锦标赛从 NP/2 个个体中选出两个
           a1
            p1=pop(a1,:);%根据索引找到个体
            p1
            bm=G(ceil(rand*size(G,1))); %从前沿解G中随机选一个个体作为最优解
            off(j,:) = MP3(p1,N,P,j,G, iter/maxiter);%差分进化，生成新个体 off(j,:)，该个体将p1中的两个个体与bm进行混合（交叉操作），并应用一些变异操作
            off(j,:)=round(off(j,:));%将新生成的个体中的像元值四舍五入，确保每个像元值是整数。
            %------辅助
            a2=TournamentSelection(2,NP/2,fx1(:,1),fx1(:,2));
            p2=pop1(a2,:);            
            bm=G1(ceil(rand*size(G,1))); %最优解
            off1(j,:) = MP3(p2,N,P,j,G1, iter/maxiter);
            off1(j,:)=round(off1(j,:));            
        end        
    %%
    % 去重
    [off,id_x] = unique(off,'row');
    if length(id_x)<NP/2
        for j = length(id_x)+1:NP
            off(j,:) =randperm(N,P);
        end
    end
    off = sort(off,2);
    for i=1:NP/2
        offfx(i,1) = 1/volume(X_reduction(:,off(i,:)));
        offfx(i,2) = unmixed(X,X(:,off(i,:)),3);
    end
    [off1,id_x1] = unique(off1,'row');
    if length(id_x1)<NP/2
        for j = length(id_x1)+1:NP
            off1(j,:) =randperm(N,P);
        end
    end
    off1 = sort(off1,2);
    for i=1:NP/2
        offfx1(i,1) = 1/volume(X_reduction(:,off1(i,:)));
        offfx1(i,2) = unmixed(X,X(:,off1(i,:)),1);
    end    
    
  %% 精英选择
        new_x=[pop;off;off1];
        new_f_x=[fx;offfx;offfx1];        
        [F1,MF1] = NDSort(new_f_x,5);
        c_distance = CrowdingDistance(new_f_x,F1);
        [pop,f_idx]=elitism(NP,new_x,F1,MF1,c_distance);
        fx=new_f_x(f_idx,:);
        F0=find(F1(1,:)==1);
        G=new_x(F0,:); 
        fG = new_f_x(F0,:);       
        pop = sort(pop,2);       
  %% 精英选择
        new_x1=[pop1;off;off1];
        new_f_x1=[fx1;offfx;off1];        
        [F2,MF2] = NDSort(new_f_x1,4);
        c_distance2 = CrowdingDistance(new_f_x1,F2);
        [pop1,f_idx1]=elitism(NP,new_x2,F2,MF2,c_distance2);
        fx1=new_f_x1(f_idx1,:);
        F20=find(F2(1,:)==1);
        G1=new_x1(F20,:); 
        fG1 = new_f_x1(F20,:);     
% scatter(fG(:,1),fG(:,2));
% drawnow;
    fprintf('%d th is ok \n',iter);
end 

[F1,MF1] = NDSort(fx,4);
F0=find(F1(1,:)==1);
G=pop(F0,:); 
s=fx(F0,:);
scatter(s(:,1),s(:,2));
hold on;

[best_x_num,~]=size(G);
%    匹配光谱矩阵
record_SAM =[];
for i = 1:best_x_num
   endmember1 = X(:,G(i,:));
   SAM = SAMpipei(reference,endmember1);
   [~,SAM_idx]=sort(SAM(1,1:P));
   SAM=SAM(:,SAM_idx);
   record_SAM = [record_SAM;SAM(1:3,:)];
end