
clear
clc
TIME1=clock;
% 相对与MYEA5，去除了无用的初始化策略，两个父代都是由二元竞标赛选出，种群数40 

% load samson_1.mat
% % load end3.mat
% load samson_groundth.mat
% reference = M;
% reference(:,3)=reference(:,3).*0.1;
% X = V; %95.95


load jasperRidge2_R198.mat
load end4.mat
reference = M;
X = Y./1000; %100.100

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190

% load Urban_R162.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %307.307


[L,n] = size(X); 
row =100;
col =100;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
p = 4;   % Number of endmembers   

% [X,image_3d] = freadenvi('华盛顿去除噪音波段'); 
% image_3d =hyperConvert3d(X',150,150,187);
% image_3d = image_3d./10000;
% X = X.'/10000; 
% [L,n] = size(X);
% row = 150;
% col = 150;

% p = 6;   % Number of endmembers   端元数量


%dimension reduction   
trans = dim_reduction(p,X,image_3d);  % p=p
X_reduction = trans * X;


T = cputime; %CPU时间
%********************************************************************************************************************************************************%
    pop_num=30;
    maxiter=200;
    population=zeros(pop_num,n);
    off=zeros(pop_num,n);
    f_x=zeros(pop_num,2);
    f_off=zeros(pop_num,2);
    %the first objective is f; for the special solution 00...00 (i.e., it does not select any variable) and the solutions with the number of selected variables not smaller than 2*k, set its first objective value as inf.  
    new_x=zeros(2*pop_num,n);
    new_f_x=zeros(2*pop_num,2);
    temp2=[];
    temp1=[];
    record_SAM = [];
    record_SAM160 = [];

    
x=randperm(n);
x=x(1:pop_num*p);
x=reshape(x,p,pop_num);
x=x'; 
    for i=1:pop_num
        population(i,x(i,:))=1;       
    end

    for i=1:pop_num
        f_x(i,1)=1/volume(X_reduction(:,population(i,:)==1));       
        f_x(i,2)=unmixed(X,X(:,population(i,:)==1),3);
    end 
    f_x
    [F,MF] = NDSort(f_x,5);
    F0=find(F(1,:)==1);
    
   recordfit=zeros(2,41);         
   recordfit(1,1)=mean(f_x(F0,1));
   recordfit(2,1)=mean(f_x(F0,2));



    for i=1:maxiter
        off=zeros(pop_num,n);
        new_x=zeros(2*pop_num,n);
        for j =1:pop_num  
            
            a1=TournamentSelection((maxiter*3)/4,1,f_x(:,1),f_x(:,2));
            a2=TournamentSelection(2,1,f_x(:,1),f_x(:,2));


            z_p = ((f_x(a1,1)<f_x(a2,1)) + (f_x(a1,2)<f_x(a2,2)));

            pa1=population(a1,:);
            pa2=population(a2,:);
            if i<=(maxiter*4)/5 
                if z_p==2
                    off(j,:)=fdcby(pa1);
                else
                    off(j,:)=fdcby(pa2);
                end
            else
                if z_p==2
                    pa1_idx = find(pa1==1);
                else
                    pa1_idx = find(pa2==1);
                end
                k=randi([1,p],1,1);
                pa1_idx(k) = pa1_idx(k) +randi([-6,6],1,1)*row+randi([-6,6],1,1);
                while any(pa1_idx>n)||any(pa1_idx<=1)
                    if z_p==2
                        pa1_idx = find(pa1==1);
                    else
                        pa1_idx = find(pa2==1);
                    end
                    pa1_idx(k) = pa1_idx(k) +randi([-6,6],1,1)*row+randi([-6,6],1,1);
                end
                pa1_idx=unique(pa1_idx);
                if length(pa1_idx)<p
                    m1=randperm(n,p-length(pa1_idx));
                    pa1_idx=[pa1_idx,m1];
                end                             
                off(j,pa1_idx)=1;
            end 
        end
        [off,id_off] = unique(off,'row');
        if length(id_off)<pop_num
            for j = length(id_off)+1:pop_num
                off(j,:)=zeros(1,n);
                off(j,randperm(n,p)) = 1;
            end
        end
            for j = 1:pop_num

            f_off(j,1) = 1/volume(X_reduction(:,off(j,:)==1));
            f_off(j,2) = unmixed(X,X(:,off(j,:)==1),3);
        end 
        
        new_x=[population;off];
        new_f_x=[f_x;f_off];
        
%     [new_x,new_f_x,Fnum] = nondSort(new_x,new_f_x);  
%     [new_x,new_f_x,cd] = CrowDis_y(new_x,new_f_x,Fnum);
%     population = new_x(1:pop_num,:);
%     f_x = new_f_x(1:popSize,:);
%     cd=[]; Fnum=[];        
    
        [F,MF] = NDSort(new_f_x,4);
%         c_distance = CrowdingDistance(new_f_x,F);
        c_distance = yuxian_xiansidu(new_x,X,p,F);
        [population,f_idx]=elitism(pop_num,new_x,F,MF,c_distance);
        f_x=new_f_x(f_idx,:);

        
        
          if mod(i,5)==0   
               F0=find(F(1,:)==1);
               recordfit(1,i/5+1)=mean(new_f_x(F0,1));
               recordfit(2,i/5+1)=mean(new_f_x(F0,2));
          end
       
        s=new_f_x(F(1,:)==1,:);
        s
%         scatter(s(:,1),s(:,2));  
%         drawnow;       
        fprintf('%d iter is ok\n',i); 
        
       if i==(((maxiter*4)/5)-1)
            s=new_f_x(F(1,:)==1,:);
            [~,idx_4]=sort(s(:,1));
            s160=s(idx_4,:);    
           scatter(s(:,1),s(:,2));  
           hold on;  
           best_x=new_x(F(1,:)==1,:);
           [best_x_num,~]=size(best_x);
           for k = 1:best_x_num
               endmember = X(:,best_x(k,:)==1);
               SAM160 = SAMpipei(reference,endmember);
               [~,SAM_idx]=sort(SAM160(1,1:p));
               SAM160=SAM160(:,SAM_idx);
               record_SAM160 = [record_SAM160;SAM160(1:3,:)];
           end
       end
            
    end
   TIME2=clock;

   time4=etime(TIME2,TIME1);
%  time4 = cputime - T;              %runtime
 recordfit4=recordfit;
        s=new_f_x(F(1,:)==1,:);
%         subplot(2,4,1); 
        scatter(s(:,1),s(:,2),'filled','h','DisplayName','MY');
%         legend('MY')        
        hold on;


        fprintf('%.6f %.6f\n',s');
%     generations=1:T;
%     plot(generations,recordfit1,'r.-',generations,recordfit2,'y.-','linewidth',2)
%     hold on;

   
    [~,idx_4]=sort(s(:,1));
    s=s(idx_4,:)    

   best_x=new_x(F(1,:)==1,:);
   [best_x_num,~]=size(best_x);
   for i = 1:best_x_num
       endmember = X(:,best_x(i,:)==1);
       SAM = SAMpipei(reference,endmember);
       [~,SAM_idx]=sort(SAM(1,1:p));
       SAM=SAM(:,SAM_idx);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end 
Mbest_x_noSAD=best_x;
Ms_noSAD=s;
Mrecord_SAM_noSAD =record_SAM; 
save MYEA_data_noSAD Mbest_x_noSAD Ms_noSAD Mrecord_SAM_noSAD  
   
   
   
   