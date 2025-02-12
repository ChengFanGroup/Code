%% (μ+λ)-MODE
clear all;
clc

warning off
% format long
TIME1=clock;



% [X,image_3d] = freadenvi('华盛顿去除噪音波段'); 
% image_3d =hyperConvert3d(X',150,150,187);
% image_3d = image_3d./10000;
% X = X.'/10000; 
% [L,N] = size(X);
% row = 150;
% col = 150;


load samson_1.mat
 load end3.mat
load samson_groundth.mat
reference = M;
reference(:,3)=reference(:,3).*0.1;
X = V; %95.95


 %load jasperRidge2_R198.mat
 %load end4.mat
 %reference = M;
 %X = Y./1000; %100.100

%  load CupriteS1_R188.mat
%  load CupriteS1_groundtreth.mat
%  reference = M;
%  X = Y./1000; %250.190

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

record_SAM20=[];
for count=1:1 
record_SAM=[];
tic    

rand('state',sum(100*clock))

popSize = 30;
Maxgen =  10;

P=randperm(N);
P=P(1:popSize*endmember);
P=reshape(P,endmember,popSize);
P=P';


for i = 1:popSize
    fit(i,1) = 1/volume(X_reduction(:,P(i,:)));
%     fit(i,2)= F_rmse(X,X(:,P(i,:)));
    fit(i,2) = unmixed(X,X(:,P(i,:)),3);
end 
fit


% [P,fit,Fnum] = nondSort(P,fit);  
% [P,fit,cd] = CrowDis(P,fit,Fnum); 
% cd=[]; Fnum=[];
%  [GBA,f_GBA] = non_dom_V(P,fit,[],[]); 
 
         [F,MF] = NDSort(fit,4);
        c_distance = CrowdingDistance(P,F);
        F0=find(F(1,:)==1);
        G=[];
        G=P(F0,:); 

 
   recordfit=zeros(2,41);        
   recordfit(1,1)=mean(fit(F0,1));
   recordfit(2,1)=mean(fit(F0,2));
for gen = 1:Maxgen
    
   
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
        ProMod =3; 
        index = selectIndex(popSize,k,ProMod);
        Mut(k,:) = P(index(1),:)+F*(P(index(2),:)-P(index(3),:));
        
        index = selectIndex(popSize,k,ProMod);

        index_1=ceil(rand*size(G,1));
        Mut(k+popSize,:) = P(index(1),:)+rand*(G(index_1,:)-P(index(1),:))+F*(P(index(2),:)-P(index(3),:));
    end

    %  Crossover
    for k = 1:popSize 
        sn = randi(D);
        for i=1:D 
            if rand<CR | i==sn
                C(k,i) = Mut(k,i);
            else
                C(k,i) = P(k,i); 
            end
            if rand<CR | i==sn
                C(k+popSize,i) = Mut(k+popSize,i);
            else
                C(k+popSize,i) = P(k,i); 
            end
        end
        % Check bound constraints
        C(k,:) = CheckBound_r(C(k,:),Xmax,Xmin);
        C(k,:)=round(C(k,:));
        temp=unique(C(k,:));
        if length(temp)<D
            pos=[1:N];
            pos(temp)=[];
            num=randperm(length(pos),D-length(temp));
            temp=[temp,pos(num)];
        end
        C(k,:)=temp;
        
        C(k+popSize,:) = CheckBound_r(C(k+popSize,:),Xmax,Xmin);
        C(k+popSize,:)=round(C(k+popSize,:));
        temp=unique(C(k+popSize,:));
        if length(temp)<D
            pos=[1:N];
            pos(temp)=[];
            num=randperm(length(pos),D-length(temp));
            temp=[temp,pos(num)];
        end
        C(k+popSize,:)=temp;
    end

    for k = 1:popSize*2 
        fit_C(k,1) = 1/volume(X_reduction(:,C(k,:)));
%         fit_C(k,2) = F_rmse(X,X(:,C(k,:)));
        fit_C(k,2) = unmixed(X,X(:,C(k,:)),3);
    end


    
    P=[P;C];
    fit=[fit;fit_C];
    

%     [P,fit,Fnum] = nondSort(P,fit);  
%     [P,fit,cd] = CrowDis(P,fit,Fnum);
%     [GBA,f_GBA] = non_dom_V(P,fit,[],[]); 
%     P = P(1:popSize,:);
%     fit = fit(1:popSize,:);
%     cd=[]; Fnum=[];


        %yan zheng zi dai daunyan chongfu
       if gen==20
           for j = 1:30
               endmember1 = X(:,C(j,:));
               SAM20 = SAMpipei(reference,endmember1);
               [~,SAM20_idx]=sort(SAM20(1,1:endmember));
               SAM20=SAM20(:,SAM20_idx);
               record_SAM20 = [record_SAM20;SAM20(1:3,:)];
           end
           fprintf('第%d次迭代结束\n',gen);
       end
   

        [F,MF] = NDSort(fit,4);
        c_distance = CrowdingDistance(P,F);
        F0=find(F(1,:)==1);
     if mod(gen,5)==0        
        recordfit(1,gen/5+1)=mean(fit(F0,1));
        recordfit(2,gen/5+1)=mean(fit(F0,2));
     end 
        s=fit(F0,:);             
        
        
        G=[];
        G=P(F0,:); 
        [P,f_idx]=elitism(popSize,P,F,MF,c_distance);
        fit=fit(f_idx,:);
    
%     scatter(f_GBA(:,1),f_GBA(:,2));
    

    fprintf('第%d次迭代结束\n',gen);
    

end
    TIME2=clock;

   time3=etime(TIME2,TIME1)
% time3=toc;
Ds=s;
    scatter(Ds(:,1),Ds(:,2));
    xlabel('f1=1/V');
ylabel('f2=RMSE');
 legend('(μ+λ)MODE')
    hold on;
recordfit3=recordfit;


    [best_x_num,~]=size(G);
    
%    匹配光谱矩阵
   for i = 1:best_x_num
       endmember1 = X(:,G(i,:));
       SAM = SAMpipei(reference,endmember1);
       [~,SAM_idx]=sort(SAM(1,1:endmember));
       SAM=SAM(:,SAM_idx);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end
 
Dbest_x=G;
Ds=s;
Drecord_SAM =record_SAM; 

% f=zeros(20,1);
% for i =1:20
% f(i)= unmixed(X,X(:, result(i,:)),3);
% end
save MODE_data Dbest_x Ds Drecord_SAM time3 recordfit3 endmember1

end
