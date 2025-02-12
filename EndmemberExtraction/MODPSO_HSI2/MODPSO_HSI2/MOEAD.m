clear 
clc
%参数
load samson_1.mat 
load end3.mat
reference = M;
X = V;
[L,n] = size(X); %N为像元数，L为波段数
row = 95;
col = 95;
image_3d = zeros(row,col,L);


for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
P = 3;   % Number of endmembers   端元数量
trans = dim_reduction(P,X,image_3d); 
X_reduction = trans * X;
%********************************************************************************************************************************************************%
%parameter initialization 参数初始化

record_SAM = [];



global x_max x_min f_num  lamdaMat  z
f_num=2;  %目标个数
x_num=P; %问题维度
x_max=n;
x_min=1;    
pop_num = 20;          % 种群大小
lamdaMat = generateLamda(pop_num,f_num); % 产生权重向量
T = floor(pop_num/10);          % 邻居规模大小
Maxgen =  300;

% 初始化邻居
B0 = zeros(pop_num,pop_num);

for i = 1:pop_num
    for j = 1:pop_num
        l = lamdaMat(i,:)-lamdaMat(j,:);
        B0(i,j)=sqrt(l*l');
    end
end

% 返回邻居索引
for i = 1:pop_num
    [s,sindex] = sort(B0(i,:));
     B(i,:) = sindex(1:T);     %B中存储邻居的索引                           
end
% 初始化个体
x = zeros(pop_num,P); 
    for j=1:pop_num
        x(j,:) = randi([1,n],1,P);
    end 
%个体的函数值
    f_x = zeros(pop_num,2); 

    for j = 1:pop_num           %calculate objective function value 计算目标函数值
        f_x(j,1) = 1/volume(X_reduction(:,x(j,:)));
        f_x(j,2) = unmixed(X,X(:,x(j,:)),1);
    end
% 初始化z值为目标最优值
for i=1:f_num
    z(i) = min(f_x(:,i));
end

% 开始迭代
for gen =1:Maxgen    
for i = 1:pop_num  
    % 生成父母
    index = randperm(T);
    r1 = B(i,index(1));
    r2 = B(i,index(2));
    y = gen_jiaocha_bianyi( x(r1,:), x(r2,:)); %基因重组产生新的解y

    y_fit(1) = 1/volume(X_reduction(:,y));
    y_fit(2) = unmixed(X,X(:,y),1);   
    %更新
     for j=1:f_num
        z(j) = min(z(j),y_fit(j));
     end
    
    % 更新邻居 
    [x,f_x] = updateNeigh(x,f_x,B(i,:),y,y_fit);  
end
%打印输出
    scatter(f_x(:,1),f_x(:,2));
    drawnow
end
 


