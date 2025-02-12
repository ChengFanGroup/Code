
clear
clc
%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时候使用
% reference = M; %reference of endmembers   端元的参考
% 策略：40个个体组成种群。前20个个体按照f（1）排序，后20个按照f（2）排序。这两个小种群中的最优个体交换1的位置，产生新的个体加入到种群中。

% 选解：
% 初始解均匀分布。
% 
% 无非对称变异，5个个体存储初始化的解
% 扰动
%



load Urban_R162.mat
load end5_groundTruth.mat
reference = M;
X = Y./1000;  %307.307



% load samson_1.mat
% % load end3.mat
% load samson_groundth.mat
% reference = M;
% X = V; %95.95

% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %99.100

% load CupriteS1_R188.mat
% load groundTruth_Cuprite_nEnd12.mat
% reference = M;
% X = Y./1000; %250.190





[L,n] = size(X); %N为像元数，L为波段数
row = 307;
col =307;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
p = 5;   % Number of endmembers   端元数量

%dimension reduction   降维
trans = dim_reduction(p,X,image_3d);  % p=p
X_reduction = trans * X;
trans_1 = dim_reduction(p-1,X,image_3d);  % p=p-1
X_reduction_1 = trans_1 * X;
trans_2 = dim_reduction(p-2,X,image_3d);  % p=p-2
X_reduction_2 = trans_2 * X;
trans_3 = dim_reduction(p+1,X,image_3d);  % p=p-3
X_reduction_3= trans_3 * X;
trans_4 = dim_reduction(p+2,X,image_3d);  % p=p-3
X_reduction_4= trans_4 * X;


%********************************************************************************************************************************************************%
    pop_num=20;
    population=zeros(pop_num,n);
    offspring=zeros(pop_num,n);
    fitness=zeros(pop_num,3);
    %the first objective is f; for the special solution 00...00 (i.e., it does not select any variable) and the solutions with the number of selected variables not smaller than 2*k, set its first objective value as inf.  
    newpopulation=zeros(2*pop_num,n);
    recordfit1=[];
    recordfit2=[];
    temp1=[];
    temp2=[];
        
    for i=1:pop_num
        q=[];        
        for j=1:p
            q(j)=random_choose(floor(n/p),1)+floor(n/p)*(j-1);
        end
        population(i,q) = 1;
    end
    record_SAM = [];
    
    for i=1:pop_num
        fitness(i,1)=unmixed(X,X(:,population(i,:)==1),1);
        fitness(i,3)= p;
        fitness(i,2)=1/volume(X_reduction(:,population(i,:)==1));    
    end 
    [F0,fitness]=non_domination_sort(pop_num,fitness,2);

    [~,idx01]=sort(fitness(:,1));
    [~,idx02]=sort(fitness(:,2));         
    [~,idx04]=sort(fitness(:,4));
    population=population(idx04,:);
    best1=population(idx01(1),:);
    best2=population(idx02(1),:);
    
    T=300;
    for i=1:T
        offspring=population;       
        for j =1:pop_num  
    %randomly select a solution from the population and mutate it to generate a new solution.
            if i<=200
                if rand()<0.2               
                    xxx=offspring(j,:);
                    p1=ones(1,sum(xxx==1));
                    q1=zeros(1,sum(xxx==0));
                    p1(rand(1,numel(p1))<1/numel(p1))=0;
                    q1(rand(1,numel(q1))<1/numel(q1))=1;
                    xxx([find(xxx==1),find(xxx==0)])=[p1,q1];
                    offspring(j,:)=xxx;
                else
%                 best1_idx=find(best1==1);
%                 best2_idx=find(best2==1);
%                 opp_idx=find(population(randi([1,10],1,1),:)==1);
%                 off_idx=opp_idx+abs(floor(rand()*(best1_idx-opp_idx)+rand()*(best2_idx-opp_idx)));
%                 if any(off_idx>n)
%                     off_idx = find(population(j,:)==1);
%                 end                 
%                 offspring(j,off_idx)=1;
% %                     best=population(randi([1,10],1,1),:);
                    vs =best2-offspring(j,:);
                    positive_idx = find(vs>0);
                    negative_idx = find(vs<0);
                    if (positive_idx)
                        v_positive_idx = positive_idx(random_choose(length(positive_idx),1));%choose one positive velocity randomly随机选择一个正速度                   
                        v_negative_idx = negative_idx(random_choose(length(negative_idx),1));%choose one negative velocity randomly随机选择一个负速度
                        offspring(j,v_positive_idx)=1;
                        offspring(j,v_negative_idx)=0;                                  
                    else %already at the best position, then randomly generate velocity已经在最佳位置，然后随机产生速度
                        xxx=offspring(j,:);
                        p1=ones(1,sum(xxx==1));
                        q1=zeros(1,sum(xxx==0));
                        p1(rand(1,numel(p1))<1/numel(p1))=0;
                        q1(rand(1,numel(q1))<1/numel(q1))=1;
                        xxx([find(xxx==1),find(xxx==0)])=[p1,q1];
                        offspring(j,:)=xxx;
                    end
                end               
            else
                one_idx = find(offspring(j,:)==1);
                p1=sum(offspring(j,:));      
                one_idx = one_idx +randi([-3,3],1,p1)*row+randi([-4,4],1,p1);
                if any(one_idx>n)||any(one_idx<=0)
                    one_idx = find(offspring(j,:)==1);
                end              
                offspring(j,:)=zeros(1,n);
                offspring(j,one_idx)=1;
            end
            
            while sum(offspring(j,:))~=p
                offspring(j,:)=zeros(1,n);
                offspring(j,random_choose(n,p))=1;
            end 
        end   

        %%%%%上为产解部分
        
        
        
        newpopulation=[population;offspring]; 
        % 取出=p的个体
        temp1=newpopulation(sum(newpopulation,2)==p,:);
        temp2=newpopulation(sum(newpopulation,2)~=p,:);
        [temp1,id_x1] = unique(temp1,'row');
        [r1,r11] = size(temp1);
        temp1fit=zeros(r1,4);
        for k=1:r1
            temp1fit(k,1)=unmixed(X,X(:,temp1(k,:)==1),1);
            temp1fit(k,3)= p;
            temp1fit(k,2)=1/volume(X_reduction(:,temp1(k,:)==1));    
        end
  
        
        %非支配排序
        if r1 >0
            [F1,temp1fit]=non_domination_sort(r1,temp1fit,2);
%             temp1_1=temp1fit(temp1fit(:,4)==1,:);

            [~,idx1]=sort(temp1fit(:,4));            
            [~,idx11]=sort(temp1fit(:,1));
            [~,idx12]=sort(temp1fit(:,2));         
            temp1_1=temp1(idx1,:);
            
            best1=temp1(idx11(1),:);
            best2=temp1(idx12(1),:);
            temp1=cat(1,best1,best2,temp1_1);
            r1=r1+2;
            
            best1fit=temp1fit(idx11(1),1);
            best2fit=temp1fit(idx12(1),2);
            
            
%             temp1=[best1;temp1];
%             temp1=[best2;temp1];
%             [temp1,id_x1] = unique(temp1,'row');

            temp=temp1(temp1fit(:,4)==1,:); %取出第一等级数据
            tempfit=temp1fit(temp1fit(:,4)==1,:);
        end
        
        
        
      
        
%存解

        population(1:pop_num,:)=temp1(1:pop_num,:);  
%        if 0<r1&&r1<15
%            population(1:r1,:)=temp1;                
%            population((r1+1):pop_num,:)=temp2(1:(pop_num-r1),:);                    
%        elseif r1>=15
%            
%            population(1:15,:)=temp1(1:15,:);
%            for j=16:pop_num
%                 population(j,:)=zeros(1,n);
%                 population(j,random_choose(n,p))=1;
%            end
%        end
       if i==199
           tempfit
           [~,idx_3]=sort(tempfit(:,1));
           tempfit=tempfit(idx_3,:);
           tempfit
       end
       
       
       fprintf('第%d代已完成\n',i);
       if r1>0 
           scatter(tempfit(:,2),tempfit(:,1));
           drawnow;
       end
       if r1>0
           fit(1,1)=best1fit;
           fit(1,2)=best2fit;
       else
           fit(1,1)=10;
           fit(1,2)=10;
       end

%        plot(i,fit(1,1),'r.-',i,fit(1,2),'y.-','linewidth',2)            
%        hold on
       recordfit1=[recordfit1;fit(1,1)];
       recordfit2=[recordfit2;fit(1,2)];
    end
    generations=1:300;
    plot(generations,recordfit1,'r.-',generations,recordfit2,'y.-','linewidth',2)
    saveas(gcf,'shoulian.jpg')
    
    for i=1:pop_num
        fitness(i,1)=unmixed(X,X(:,population(i,:)==1),1);
    %the second objective is the number of selected variables, i.e., the sum of all the bits.
        fitness(i,3)= sum(population(i,:));
        if fitness(i,3)==p
            fitness(i,2)=1/volume(X_reduction(:,population(i,:)==1));
        end  
        one_idx5 = find(population(i,:)==1)
    end
    fitness
    [~,idx_4]=sort(fitness(:,1));
    fitness=fitness(idx_4,:)
%     scatter(temp1fit(1:15,2),temp1fit(1:15,1));
%     drawnow;
    

%    匹配光谱矩阵
   for i = 1:10
       endmember = X(:,population(i,:)==1);
       SAM = SAMpipei(reference,endmember);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end   
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-','linewidth',2)


% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)



 
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
% 



% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-',num,endmember1(:,7),'m.-',num,endmember1(:,8),'m.-',num,endmember1(:,9),'m.-',num,endmember1(:,10),num,endmember1(:,11),'m.-',num,endmember1(:,12),'m.-','linewidth',2)


