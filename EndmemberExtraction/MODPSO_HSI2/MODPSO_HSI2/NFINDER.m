  tic
clear all;
clc
TIME1=clock;
% im=multibandread('D:\1result\mnf',[200 200 5],'float32',0,'bil','ieee-le',...
% {'Band','Range',[1 4]});   %读取高光谱图像数�?
% A=reshape(im,200*200,4);%重构光谱向量
% A=A';%A矩阵的每�?列表示一个像素的光谱向量

%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时�?�使�?
% reference = M; %reference of endmembers   端元的参�?
% 
% load Urban_R1621.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %2-dimensional input image  输入�?2维图�? ?为什么除�?1000


load samson_1.mat
load end3.mat
reference = M;
reference(:,3)=reference(:,3).*0.1;
X = V;

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190
% 
% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100


[L,N] = size(X);
row = 95;
col = 95;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
P = 3;   % Number of endmembers

pop_num = 30;%number of particles
maxiter = 200;%maximum number of iterations
prob=0.2;%the probability of generating random velocity 
record_SAM = [];
GBA = [];  %GBA:Global Best Archive
f_GBA = [];
v_record = zeros(pop_num,maxiter);
T = cputime;
%*******************************************************************************************************************************************************%
%dimension reduction
trans = dim_reduction(P,X,image_3d);
X_reduction = trans * X;
recordfit=zeros(2,41);         
recordfit(1,1)=0.01;
t=1;
E=1:P;
for j=1:P
%     V0=unmixed(X,X(:,E),3);
    V0 = 1/volume(X_reduction(:,E));
    for i=1:N
        if ismember(i,E)==1
            continue;
        else
            E1=E;
            E1(j)=i;
%             V1=unmixed(X,X(:,E1),3);
            V1=1/volume(X_reduction(:,E1));
            if V1<V0
                E=E1;
                V0=V1;
            end
        end
        if mod((j-1)*95*95+i,676)==0 
            t=t+1;
            recordfit(1,t)=V0;
        end
    end
end  
% V0=unmixed(X,X(:,E),3);
scatter(V0,0,'+','DisplayName','NFINDER'); % 绘图
endmember = X(:,E);
SAM = SAMpipei(reference,endmember);
[~,SAM_idx]=sort(SAM(1,1:P));
SAM6=SAM(:,SAM_idx);
recordfit6 = recordfit;
       TIME2=clock;
        time6=etime(TIME2,TIME1);%runtime

save NFINDER_data V0 E SAM6 time6 recordfit6

