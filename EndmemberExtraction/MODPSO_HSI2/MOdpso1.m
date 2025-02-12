clear
clc
%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时候使用
% reference = M; %reference of endmembers   端元的参考
% 策略：随机初始化种群20个个体。
% 
% 更新：随机选取一个个体进行翻转。
% 
% 排序：1、父代完全优于子代，不变。2、互不支配，比较1/v这个值，取小的。3、子代完全优于父代，随机选取其中的一个替换。
% 
% 去重：种群中存在重复个体时，除去重复，随机初始化
% 
% 外部档案：f_GBA 存放优秀的子代

% load Urban_data.mat
% 
% X = Y./1000;  %2-dimensional input image  输入的2维图像 ?为什么除以1000
load samson_1.mat
X = V;

[L,n] = size(X); %N为像元数，L为波段数
row = 95;
col = 95;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
k = 4;   % Number of endmembers   端元数量

%********************************************************************************************************************************************************%
%parameter initialization 参数初始化
pop_num = 20;%number of particles  种群大小
record_SAM = [];
GBA = [];  %GBA:Global Best Archive  全局最优解存档
f_GBA = [];
%*******************************************************************************************************************************************************%
%dimension reduction   降维
trans4 = dim_reduction(2,X,image_3d);  % p=2
X_reduction4 = trans4 * X;
trans5 = dim_reduction(3,X,image_3d);  % p=3
X_reduction5 = trans5 * X;
trans6 = dim_reduction(4,X,image_3d);  % p=4
X_reduction6= trans6 * X;
trans7 = dim_reduction(5,X,image_3d);  % p=5
X_reduction7 = trans7 * X;
trans8 = dim_reduction(6,X,image_3d);  % p=6
X_reduction8 = trans8 * X;



%     T = cputime; %CPU时间
%     iter = 0;
%     iter_finish = 0; % 收敛性判别
    
    %initialize the candidate solution set (called "population"): generate a Boolean string with all 0s (called "solution").
    population=zeros(pop_num,n);
    %fitness: record the two objective values of a solution.
    fitness=zeros(pop_num,3);
    for j=1:pop_num
        p=randi([k-2,k+2],1,1);
        population(j,random_choose(n,p)) = 1;
    end
    
    
    
    for j = 1:pop_num           %calculate objective function value 计算目标函数值
  
        fitness(j,2) = sum(population(j,:));
        fitness(j,1) = unmixed(X,X(:,population(j,:)==1),1);
        if fitness(j,2)== 2
            fitness(j,3)=1/volume(X_reduction4(:,population(j,:)==1));
        elseif fitness(j,2) ==3
            fitness(j,3)=1/volume(X_reduction5(:,population(j,:)==1));
        elseif fitness(j,2) ==4
            fitness(j,3)=1/volume(X_reduction6(:,population(j,:)==1));
        elseif fitness(j,2) ==5
            fitness(j,3)=1/volume(X_reduction7(:,population(j,:)==1));
        elseif fitness(j,2) ==6
            fitness(j,3)=1/volume(X_reduction8(:,population(j,:)==1));
        end       
    end
    fitness
    %repeat to improve the population; the number of iterations is set as 2*e*k^2*n suggested by our theoretical analysis.
    T=500;
    for i=1:T
        %randomly select a solution from the population and mutate it to generate a new solution.
        offspring=abs(population(randi([1,pop_num],1,1),:)-randsrc(1,n,[1,0; 1/n,1-1/n]));
        %compute the fitness of the new solution.
        offspringFit=zeros(1,3);
        offspringFit(2)= sum(offspring);
   
        if offspringFit(2)<(k-2) || offspringFit(2)>(k+2)
            offspringFit(1)=inf; 
            offspringFit(2)=inf;
            offspringFit(3)= inf;
        else
            offspringFit(1)=unmixed(X,X(:,offspring(1,:)==1),1);
            if offspringFit(2)== 2
                offspringFit(3)=1/volume(X_reduction4(:,offspring(1,:)==1));
            elseif offspringFit(2) ==3
                offspringFit(3)=1/volume(X_reduction5(:,offspring(1,:)==1));
            elseif offspringFit(2) ==4
                offspringFit(3)=1/volume(X_reduction6(:,offspring(1,:)==1));
            elseif offspringFit(2) ==5
                offspringFit(3)=1/volume(X_reduction7(:,offspring(1,:)==1));
            elseif offspringFit(2) ==6
                offspringFit(3)=1/volume(X_reduction8(:,offspring(1,:)==1));
            end
        end

        %use the new solution to update the current population.            
        if sum((fitness(1:pop_num,1)<=offspringFit(1)).*(fitness(1:pop_num,2)<offspringFit(2)))+sum((fitness(1:pop_num,1)<offspringFit(1)).*(fitness(1:pop_num,2)<=offspringFit(2)))>0  % 父带完全优自带
            continue;
        elseif sum((fitness(1:pop_num,1)<offspringFit(1)).*(fitness(1:pop_num,2)>offspringFit(2)))>0 || sum((fitness(1:pop_num,1)>offspringFit(1)).*(fitness(1:pop_num,2)<offspringFit(2)))>0      
            
            for j=1:pop_num
                if (fitness(j,1)<offspringFit(1))*(fitness(j,2)>offspringFit(2))>0 || (fitness(j,1)>offspringFit(1))*(fitness(j,2)<offspringFit(2))>0
                    if fitness(j,3) < offspringFit(3)
                        fitness(j,:) = fitness(j,:);
                    else
                        fitness(j,:)=offspringFit(1,:);
                        population(j,:)= offspring(1,:);
                        [GBA,f_GBA] = non_dom(GBA,f_GBA,offspring,offspringFit);
                        break;
                    end
                end
            end
        else % 子带最优时
            
            for j=1:pop_num
                if (fitness(j,1)>=offspringFit(1))*(fitness(j,2)>=offspringFit(2))>0 
                    fitness(j,:)=offspringFit(1,:);
                    population(j,:)= offspring(1,:);
                    break;
                end   
            end
            [GBA,f_GBA] = non_dom(GBA,f_GBA,offspring,offspringFit);
        end
%         % 重启
%         [population,id_x] = unique(population,'row');
%         if length(id_x)<pop_num
%             fprintf('重启了');
%             for j = length(id_x)+1:pop_num
%                 p=randi([k-2,k+2],1,1);
%                 population(j,random_choose(n,p)) = 1;
%                 fitness(j,1) = unmixed(X,X(:,population(j,:)==1),1);
%                 fitness(j,2) = sum(population(j,:));
%                 if fitness(j,2)== 4
%                     fitness(j,3)=1/volume(X_reduction4(:,population(j,:)==1));
%                 elseif fitness(j,2) ==5
%                     fitness(j,3)=1/volume(X_reduction5(:,population(j,:)==1));
%                 elseif fitness(j,2) ==6
%                     fitness(j,3)=1/volume(X_reduction6(:,population(j,:)==1));
%                 elseif fitness(j,2) ==7
%                     fitness(j,3)=1/volume(X_reduction7(:,population(j,:)==1));
%                 elseif fitness(j,2) ==8
%                     fitness(j,3)=1/volume(X_reduction8(:,population(j,:)==1));
%                 end                 
%             end
%         end
        fprintf('第%d代已完成\n',i);
        scatter3(fitness(:,2),fitness(:,1),fitness(:,3),'filled'); % 绘图
        hold on;
        drawnow;
        
    end
    %select the final solution according to the constraint k on the number of selected variables.
    






