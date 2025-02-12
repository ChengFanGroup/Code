%% (μ+λ)-MODE
clear all;
clc

warning off
% format long

% [X,image_3d] = freadenvi('华盛顿去除噪音波段'); 
% image_3d =hyperConvert3d(X',150,150,187);
% image_3d = image_3d./10000;
% X = X.'/10000; 
% [L,N] = size(X);
% row = 150;
% col = 150;


load samson_1.mat
% load end3.mat
load samson_groundth.mat
reference = M;
reference(:,3)=reference(:,3).*0.1;
X = V; %95.95


% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190

% load Urban_R162.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %307.307

[L,N] = size(X);
row = 95;
col = 95;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end

endmember = 3;     
global D;
D=endmember;
global M;
M=2;
Xmax=N*ones(1,D);
Xmin=1*ones(1,D);

trans = dim_reduction(endmember,X,image_3d);
X_reduction = trans * X;

for count=1:1 

tic    

rand('state',sum(100*clock))

popSize = 10;
Maxgen =  100;

P=randperm(N);
P=P(1:popSize*endmember);
P=reshape(P,endmember,popSize);
P=P';


for i = 1:popSize
    fit(i,1) = 1/volume(X_reduction(:,P(i,:)));
%     fit(i,2)= F_rmse(X,X(:,P(i,:)));
    fit(i,2) = unmixed(X,X(:,P(i,:)),1);
end 
fit
    c_pool=[0.1,0.2,1.0];%交叉池
    f_pool=[0.6,0.8,1.0];%差分池
    v1=zeros(popSize,endmember);
    v2=zeros(popSize,endmember);
[P,fit,Fnum] = nondSort(P,fit);  
[P,fit,cd] = CrowDis(P,fit,Fnum); 
cd=[]; Fnum=[];
 [GBA,f_GBA] = non_dom_V(P,fit,[],[]); 
   recordfit=zeros(2,41);        
   recordfit(1,1)=mean(f_GBA(:,1));
   recordfit(2,1)=mean(f_GBA(:,2));
for gen = 1:Maxgen
          temp1=[];
        temp2=[];  
   
    for k = 1:popSize
        l=rand;
        if l <= 1/3
            F  = .6;
        elseif l <= 2/3
            F= 0.8;
        else
            F = 1.0;
        end
        
        l=rand;
        if l <= 1/3
            CR  = .1;
        elseif l <= 2/3
            CR = 0.2;
        else
            CR = 1.0;
        end
%         ProMod =3; 
%         index = selectIndex(popSize,k,ProMod);
        
            r1=randi([1,popSize],1,1);
            while r1==k ||rand()>((popSize-r1)/popSize)^2
                r1=randi([1,popSize],1,1);
            end
            r2=randi([1,popSize],1,1);
            while r2==k ||r2==r1||rand()>((popSize-r2)/popSize)^2
                r2=randi([1,popSize],1,1);
            end                
            r3=randi([1,popSize],1,1);
            while r3==k ||r3==r2||r3==r1||rand()>((popSize-r3)/popSize)^2
                r3=randi([1,popSize],1,1);
            end
%         index=[r1,r2,r3];    
%             
%         Mut(k,:) = P(index(1),:)+F*(P(index(2),:)-P(index(3),:));
%         
% %         index = selectIndex(popSize,k,ProMod);
%         index=[r1,r2,r3];  
%         
        index_1=ceil(rand*size(GBA,1));
%         Mut(k+popSize,:) = P(index(1),:)+rand*(GBA(index_1,:)-P(index(1),:))+F*(P(index(2),:)-P(index(3),:));
%     end

%     %  Crossover
%     for k = 1:popSize 
%         sn = randi(D);
%         for i=1:D 
%             if rand<CR | i==sn
%                 C(k,i) = Mut(k,i);
%             else
%                 C(k,i) = P(k,i); 
%             end
%             if rand<CR | i==sn
%                 C(k+popSize,i) = Mut(k+popSize,i);
%             else
%                 C(k+popSize,i) = P(k,i); 
%             end
%         end
%         % Check bound constraints
%         C(k,:) = CheckBound_r(C(k,:),Xmax,Xmin);
%         C(k,:)=round(C(k,:));
%         temp=unique(C(k,:));
%         if length(temp)<D
%             pos=[1:N];
%             pos(temp)=[];
%             num=randperm(length(pos),D-length(temp));
%             temp=[temp,pos(num)];
%         end
            v1(k,:)=P(r1,:)+f_pool(randperm(numel(f_pool),1))*(P(r2,:)-P(r3,:));
            v2(k,:)=P(r1,:)+rand()*(GBA(index_1,:)-P(r1,:))+f_pool(randperm(numel(f_pool),1))*(P(r2,:)-P(r3,:));
            
            for z=1:D
                rand2=rand();
                if rand2<=c_pool(randperm(numel(c_pool),1))||z==randi([1,D],1,1)
                    while v1(k,z)<1 ||v1(k,z)>=N
                        v1(k,z)=rand()*N;
                    end
                    v1(k,z)=round(v1(k,z));
                else
                    v1(k,z)=P(k,z);
                end
                if rand2<=c_pool(randperm(numel(c_pool),1))||k==randi([1,D],1,1)
                    while v2(k,z)<1 ||v2(k,z)>=N
                        v2(k,z)=rand()*N; 
                    end
                    v2(k,z)=round(v2(k,z));
                else
                    v2(k,z)=P(k,z);
                end
            end
            
            %去重
            temp1=unique(v1(k,:));
            if length(temp1)<endmember
                m1=randperm(N,endmember-length(temp1));
                temp1=[temp1,m1];
                v1(k,:)=temp1;
            end
            temp2=unique(v2(k,:));
            if length(temp2)<endmember
                m2=randperm(N,endmember-length(temp2));
                temp2=[temp2,m2];
                v2(k,:)=temp2;
            end                
        end 
%         C(k,:)=temp;
%         
%         C(k+popSize,:) = CheckBound_r(C(k+popSize,:),Xmax,Xmin);
%         C(k+popSize,:)=round(C(k+popSize,:));
%         temp=unique(C(k+popSize,:));
%         if length(temp)<D
%             pos=[1:N];
%             pos(temp)=[];
%             num=randperm(length(pos),D-length(temp));
%             temp=[temp,pos(num)];
%         end
%         C(k+popSize,:)=temp;
%     end
    C(1:popSize,:)=v1;
    C(popSize+1:2*popSize,:)=v2;

    for k = 1:popSize*2 
        fit_C(k,1) = 1/volume(X_reduction(:,C(k,:)));
%         fit_C(k,2) = F_rmse(X,X(:,C(k,:)));
        fit_C(k,2) = unmixed(X,X(:,C(k,:)),1);
    end


    P=[P;C];
    fit=[fit;fit_C];
    

    [P,fit,Fnum] = nondSort(P,fit);  
    [P,fit,cd] = CrowDis(P,fit,Fnum);
    [GBA,f_GBA] = non_dom_V(P,fit,[],[]); 
    P = P(1:popSize,:);
    fit = fit(1:popSize,:);
    cd=[]; Fnum=[];
%     scatter(f_GBA(:,1),f_GBA(:,2));
    f_GBA
    if mod(gen,5)==0        
        recordfit(1,gen/5+1)=mean(f_GBA(:,1));
        recordfit(2,gen/5+1)=mean(f_GBA(:,2));
    end

       
    fprintf('第%d次迭代结束\n',gen);
    

end

time3=toc;
    scatter(f_GBA(:,1),f_GBA(:,2));
    hold on;
recordfit3=recordfit;


    [best_x_num,~]=size(GBA);
    record_SAM = [];
%    匹配光谱矩阵
   for i = 1:best_x_num
       endmember1 = X(:,GBA(i,:));
       SAM = SAMpipei(reference,endmember1);
       [~,SAM_idx]=sort(SAM(1,1:endmember));
       SAM=SAM(:,SAM_idx);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end
 
Dbest_x=GBA;
Ds=s;
Drecord_SAM =record_SAM; 

save MODE_data Dbest_x Ds Drecord_SAM time3 recordfit3

end
