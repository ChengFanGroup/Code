clear
clc
%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时候使用
% reference = M; %reference of endmembers   端元的参考
% 
load Urban_data.mat
load end6_groundTruth.mat
reference = M;
X = Y./1000;  %2-dimensional input image  输入的2维图像 ?为什么除以1000


% load samson_1.mat
% load end3.mat
% reference = M;
% X = V;

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190

% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100


[L,N] = size(X); %N为像元数，L为波段数
row = 307;
col = 307;
image_3d = zeros(row,col,L);

for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
P = 6;   % Number of endmembers   端元数量

%********************************************************************************************************************************************************%
%parameter initialization 参数初始化
pop_num = 20;%number of particles  种群大小
maxiter = 300;%maximum number of iterations  最大迭代次数
prob=0.2;%the probability of generating random velocity   随机速度生成概率
record_SAM = [];
GBA = [];  %GBA:Global Best Archive  全局最优解存档
f_GBA = [];
v_record = zeros(pop_num,maxiter);
rmse_record = zeros(pop_num,maxiter);
GBA_record1= zeros(maxiter,1);
GBA_record2= zeros(maxiter,1);
%*******************************************************************************************************************************************************%
%dimension reduction   降维
trans = dim_reduction(P,X,image_3d); 
X_reduction = trans * X;
% save urban_mnf9 X_reduction


    T = cputime; %CPU时间
    iter = 0;
    iter_finish = 0; % 收敛性判别
    
    
    x = zeros(pop_num,N); %初始化粒子群的位置
    for j=1:pop_num
        x(j,random_choose(N,P)) = 1;
    end
    pbest = x;
    f_x = zeros(pop_num,2);
    
    
    for j = 1:pop_num           %calculate objective function value 计算目标函数值
        f_x(j,1) = 1/volume(X_reduction(:,x(j,:)==1));
        f_x(j,2) = unmixed1(X,X(:,x(j,:)==1));
     end
    f_pbest = f_x;
    [GBA,f_GBA] = non_dom(GBA,f_GBA,pbest,f_pbest);  
%     scatter(f_GBA(:,1),f_GBA(:,2));
    
    while iter < maxiter && iter_finish == 0
        iter = iter+1;
        
       gbest = FindGlobalBest(GBA,f_GBA,x,f_x);
        %5.update velocity and position更新速度和位置
        
        for j=1:pop_num
            %5.1 update velocity更新速度
%             if iter<=200
                vp = pbest(j,:) - x(j,:);%calculate the velocity pointed to the individual best计算速度个体最好
                vg = gbest(j,:) - x(j,:);%calculate the velocity pointed to the global best计算全局最优速度
                vs= vp+vg;
                if all(vs<=0)% generate random velocity随机产生初始速度
                    zero_idx = find(x(j,:)==0);
                    one_idx = find(x(j,:)==1);
                    v_positive_idx = zero_idx(random_choose(length(zero_idx),1));%randomly generate positive velocity  在x中随机选出一个0的位置，置为1
                    v_negative_idx = one_idx(random_choose(length(one_idx),1));%randomly generate negative velocity  在x中随机选出一个1的位置，置为0
                else
                    positive_idx = find(vs>0);
                    negative_idx = find(vs<0);
                    if (positive_idx)
                        v_positive_idx = positive_idx(random_choose(length(positive_idx),1));%choose one positive velocity randomly随机选择一个正速度
                        v_negative_idx = negative_idx(random_choose(length(negative_idx),1));%choose one negative velocity randomly随机选择一个负速度
                    else %already at the best position, then randomly generate velocity已经在最佳位置，然后随机产生速度
                        zero_idx = find(x(j,:)==0);
                        one_idx = find(x(j,:)==1);
                        v_positive_idx = zero_idx(random_choose(length(zero_idx),1));
                        v_negative_idx = one_idx(random_choose(length(one_idx),1));
                    end
                end
                %5.2 update position 更新粒子位置
                x(j,v_positive_idx)=1;
                x(j,v_negative_idx)=0;
%                 % particle_position_history{j} = [particle_position_history{j};x(j,:)];

            
        end
        
         %3.update the best solution更新最优解
        for j=1:pop_num
            f_x(j,1) = 1/volume(X_reduction(:,x(j,:)==1));
            f_x(j,2) = unmixed1(X,X(:,x(j,:)==1));
           
            v_record(j,iter) = f_x(j,1);
            rmse_record(j,iter) = f_x(j,2);
            
            n = ((f_x(j,1)<f_pbest(j,1)) + (f_x(j,2)<f_pbest(j,2)));
            if n==2
                pbest(j,:) = x(j,:);
                f_pbest(j,:) = f_x(j,:);
            end
            
            % 最优解存档
            if n==1
                if rand() > 0.5
                    GBA = [GBA;pbest(j,:)];
                    f_GBA = [f_GBA;f_pbest(j,:)];
                    pbest(j,:) = x(j,:);
                    f_pbest(j,:) = f_x(j,:);
                else
                    GBA = [GBA;x(j,:)];
                    f_GBA = [f_GBA;f_x(j,:)];
                end
            end
                              
        end
        % 重启
        [x,id_x] = unique(x,'row');
        pbest = pbest(id_x,:);
        f_pbest=f_pbest(id_x,:);
        if length(id_x)<pop_num
            for j = length(id_x)+1:pop_num
                x(j,randperm(N,P)) =1;
                pbest(j,:)=x(j,:);
                f_x(j,1) = 1/volume(X_reduction(:,x(j,:)==1));
                f_x(j,2) = unmixed1(X,X(:,x(j,:)==1));
                f_pbest(j,:) = f_x(j,:);
            end
        end
              
        
        [GBA,f_GBA] = non_dom(GBA,f_GBA,pbest,f_pbest);  

        GBA_record1(iter)= min(f_GBA(:,1));
        GBA_record2(iter)= min(f_GBA(:,2));
        
%       4.judge convergence 判断收敛性
        if max(f_pbest)-min(f_pbest)==0
            iter_finish = 1;
        end
%         if iter==199
%             f_GBA
%         end
        fprintf('第%d代已完成\n',iter);
        scatter(f_GBA(:,1),f_GBA(:,2)); % 绘图
        drawnow;
    end
    scatter(f_GBA(:,1),f_GBA(:,2)); % 绘图
    hold on;
    f_GBA
    time = cputime - T;              %runtime
    [n,~] = size(GBA);
    
    
    

    
%    匹配光谱矩阵
   for i = 1:n
       endmember = X(:,GBA(i,:)==1);
       SAM = SAMpipei(reference,endmember);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end

% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-','linewidth',2)

% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)

% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
 
% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-',num,endmember1(:,7),'m.-',num,endmember1(:,8),'m.-',num,endmember1(:,9),'m.-',num,endmember1(:,10),num,endmember1(:,11),'m.-',num,endmember1(:,12),'m.-','linewidth',2)
 


