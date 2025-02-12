clear
clc
rand('state',sum(100*clock))

%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时候使用
% reference = M; %reference of endmembers   端元的参考
% 


% load Urban_R162.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %307.307

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


[L,n] = size(X); %N为像元数，L为波段数
row = 95;
col = 95;
image_3d = zeros(row,col,L);

for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end

% 
% [X,image_3d] = freadenvi('华盛顿去除噪音波段'); 
% image_3d =hyperConvert3d(X',150,150,187);
% image_3d = image_3d./10000;
% X = X.'/10000; 
% [L,n] = size(X);
% row = 95;
% col = 95;

P = 3;   % Number of endmembers   端元数量

%********************************************************************************************************************************************************%
%parameter initialization 参数初始化
pop_num = 100;%number of particles  种群大小
maxiter = 100;%maximum number of iterations  最大迭代次数
record_SAM = [];


%*******************************************************************************************************************************************************%
%dimension reduction   降维
trans = dim_reduction(P,X,image_3d); 
X_reduction = trans * X;
% save urban_mnf9 X_reduction


    T = cputime; %CPU时间
    iter = 0;
    iter_finish = 0; % 收敛性判别 
    c_pool=[0.1,0.2,1.0];%交叉池
    f_pool=[0.6,0.8,1.0];%差分池
    new_x=zeros(3*pop_num,P);
    new_f_x=zeros(3*pop_num,2);
    v1=zeros(pop_num,P);
    v2=zeros(pop_num,P);
%     x = zeros(pop_num,P); 
%     for j=1:pop_num
%         x(j,:) = randi([1,n],1,P);
%     end
x=randperm(n);
x=x(1:pop_num*P);
x=reshape(x,P,pop_num);
x=x'; 
    
    f_x = zeros(pop_num,2); 

    for j = 1:pop_num           %calculate objective function value 计算目标函数值
        f_x(j,1) = 1/volume(X_reduction(:,x(j,:)));
        f_x(j,2) = unmixed(X,X(:,x(j,:)),1);
    end
    f_x
    [F,MF] = NDSort(f_x,2);
    F0=find(F(1,:)==1);
    gbest=x(F0(randperm(numel(F0),1)),:); 
%     [F0,fitness]=non_domination_sort(pop_num,f_x,2);
%     gbest=x(F0(1).ss(randperm(numel(F0(1).ss),1)),:);
   recordfit=zeros(2,41);        
   recordfit(1,1)=mean(f_x(:,1));
   recordfit(2,1)=mean(f_x(:,2));
    

    
    while iter < maxiter
        iter = iter+1;
        temp1=[];
        temp2=[];
        for j=1:pop_num
            r1=randi([1,pop_num],1,1);
            while r1==j ||rand()>((pop_num-r1)/pop_num)^2
                r1=randi([1,pop_num],1,1);
            end
            r2=randi([1,pop_num],1,1);
            while r2==j ||r2==r1||rand()>((pop_num-r2)/pop_num)^2
                r2=randi([1,pop_num],1,1);
            end                
            r3=randi([1,pop_num],1,1);
            while r3==j ||r3==r2||r3==r1||rand()>((pop_num-r3)/pop_num)^2
                r3=randi([1,pop_num],1,1);
            end
            
            v1(j,:)=x(r1,:)+f_pool(randperm(numel(f_pool),1))*(x(r2,:)-x(r3,:));
            v2(j,:)=x(r1,:)+rand()*(gbest-x(r1,:))+f_pool(randperm(numel(f_pool),1))*(x(r2,:)-x(r3,:));
            
            for k=1:P
                rand2=rand();
                if rand2<=c_pool(randperm(numel(c_pool),1))||k==randi([1,P],1,1)
                    while v1(j,k)<1 ||v1(j,k)>=n
                        v1(j,k)=rand()*n;
                    end
                    v1(j,k)=round(v1(j,k));
                else
                    v1(j,k)=x(j,k);
                end
                if rand2<=c_pool(randperm(numel(c_pool),1))||k==randi([1,P],1,1)
                    while v2(j,k)<1 ||v2(j,k)>=n
                        v2(j,k)=rand()*n; 
                    end
                    v2(j,k)=round(v2(j,k));
                else
                    v2(j,k)=x(j,k);
                end
            end
            
            %去重
            temp1=unique(v1(j,:));
            if length(temp1)<P
                m1=randperm(n,P-length(temp1));
                temp1=[temp1,m1];
                v1(j,:)=temp1;
            end
            temp2=unique(v2(j,:));
            if length(temp2)<P
                m2=randperm(n,P-length(temp2));
                temp2=[temp2,m2];
                v2(j,:)=temp2;
            end                
        end     
        %上述产生解部分
        
        
        %种群的合并
        new_x(1:pop_num,:)=x;
        new_x(pop_num+1:2*pop_num,:)=v1;
        new_x(2*pop_num+1:3*pop_num,:)=v2;
    
        
        for j = 1:3*pop_num           %calculate objective function value 计算目标函数值
            new_f_x(j,1) = 1/volume(X_reduction(:,new_x(j,:)));
            new_f_x(j,2) = unmixed(X,X(:,new_x(j,:)),1);
        end       
        
        %非支配排序，拥挤度计算,选出新的种群
        [F,MF] = NDSort(new_f_x,4);
        c_distance = CrowdingDistance(new_f_x,F);
        F0=find(F(1,:)==1);
        gbest=new_x(F0(randperm(numel(F0),1)),:); 
        x=elitism(pop_num,new_x,F,MF,c_distance);

           if mod(iter,5)==0        
               recordfit(1,iter/5+1)=mean(new_f_x(:,1));
               recordfit(2,iter/5+1)=mean(new_f_x(:,2));
           end
        s=new_f_x(F(1,:)==1,:);
        s
%         scatter(s(:,1),s(:,2));
%         drawnow;       
        fprintf('第%d代已完成\n',iter);

    end
    time3 = cputime - T;              %runtime
    recordfit3=recordfit;
    s=new_f_x(F(1,:)==1,:);
%     subplot(2,4,1);
    scatter(s(:,1),s(:,2),'*','DisplayName','(u+λ)MODE');
%     legend('(u+λ)MODE')
    hold on;
    s    
    
    best_x=new_x(F(1,:)==1,:);
    [best_x_num,~]=size(best_x);
    
%    匹配光谱矩阵
   for i = 1:best_x_num
       endmember = X(:,best_x(i,:));
       SAM = SAMpipei(reference,endmember);
       [~,SAM_idx]=sort(SAM(1,1:P));
       SAM=SAM(:,SAM_idx);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end
 
Dbest_x=best_x;
Ds=s;
Drecord_SAM =record_SAM; 
save MODE_data Dbest_x Ds Drecord_SAM time3 recordfit3
   

% num=1:1:L;
% endmember1=X(:,best_x(1,:));
% SAM1 = SAMpipei(reference,endmember1);
% [~,SAM1_idx]=sort(SAM1(1,1:P));
% SAM1=SAM1(:,SAM1_idx);
% subplot(2,4,2); 
% plot(num,endmember1(:,SAM1(2,1)),'k.-','DisplayName','(u+λ)MODE')
% % legend('(u+λ)MODE')
%  hold on;
% subplot(2,4,3);
% % legend('(u+λ)MODE')
% plot(num,endmember1(:,SAM1(2,2)),'k.-','DisplayName','(u+λ)MODE')
%  hold on;
% subplot(2,4,4);
% % legend('(u+λ)MODE')
% plot(num,endmember1(:,SAM1(2,3)),'k.-','DisplayName','(u+λ)MODE')
%  hold on;
% subplot(2,4,5); 
% % legend('(u+λ)MODE')
% plot(num,endmember1(:,SAM1(2,4)),'k.-','DisplayName','(u+λ)MODE')
%  hold on;
 
% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'m.-','linewidth',2)

% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)
% 
% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
%  
% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-',num,endmember1(:,7),'m.-',num,endmember1(:,8),'m.-',num,endmember1(:,9),'m.-',num,endmember1(:,10),num,endmember1(:,11),'m.-',num,endmember1(:,12),'m.-','linewidth',2)
 








