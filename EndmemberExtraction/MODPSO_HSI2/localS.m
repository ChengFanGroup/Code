
clear
clc

% 相对与MYEA5，去除了无用的初始化策略，两个父代都是由二元竞标赛选出，种群数40 

% load samson_1.mat
% % load end3.mat
% load samson_groundth.mat
% reference = M;
% reference(:,3)=reference(:,3).*0.1;
% X = V; %95.95


% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190

load Urban_R162.mat
load end6_groundTruth.mat
reference = M;
X = Y./1000;  %307.307


[L,n] = size(X); 
row =307;
col =307;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
p = 6;   % Number of endmembers   



%dimension reduction   
trans = dim_reduction(p,X,image_3d);  % p=p
X_reduction = trans * X;


T = cputime; %CPU时间
%********************************************************************************************************************************************************%
    pop_num=30;
    maxiter=40;
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


    
x=randperm(n);
x=x(1:pop_num*p);
x=reshape(x,p,pop_num);
x=x'; 
    for i=1:pop_num
        population(i,x(i,:))=1;       
    end
%  load('C:\Users\chnk\Desktop\data\samson\MYEA_data4.mat')   
% load('C:\Users\chnk\Desktop\data\jasper\MYEA_data2.mat') 
load('C:\Users\chnk\Desktop\data\urban\MYEA_data5.mat')
 [c1,c2]=size(Mbest_x);
 population(1:c1,:)=Mbest_x;
 f_x(1:c1,:)=Ms;

          
  for i=1:pop_num
        f_x(i,1)=1/volume(X_reduction(:,population(i,:)==1));       
        f_x(i,2)=unmixed(X,X(:,population(i,:)==1),3);
  end  
    [F,MF] = NDSort(f_x,5);
    F0=find(F(1,:)==1);
    s=f_x(F(1,:)==1,:);
 
    
    
   recordfit=zeros(2,9);         
   recordfit(1,1)=min(f_x(F0,1));
   recordfit(2,1)=min(f_x(F0,2));



    for i=1:maxiter
        off=zeros(pop_num,n);
        new_x=zeros(2*pop_num,n);
        for j =1:pop_num  
            
            a1=TournamentSelection((maxiter*4)/5,1,f_x(:,1),f_x(:,2));
            a2=TournamentSelection(2,1,f_x(:,1),f_x(:,2));


            z_p = ((f_x(a1,1)<f_x(a2,1)) + (f_x(a1,2)<f_x(a2,2)));

            pa1=population(a1,:);
            pa2=population(a2,:);
            if i<=0 
                0           
            else
                if z_p==2
                    pa1_idx = find(pa1==1);
                else
                    pa1_idx = find(pa2==1);
                end
                k=randi([1,p],1,1);
                pa1_idx(k) = pa1_idx(k) +randi([-6,6],1,1)*row+randi([-6,6],1,1);
                while any(pa1_idx>n)||any(pa1_idx<=1)
                    pa1_idx = find(pa1==1);
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
        

    
        [F,MF] = NDSort(new_f_x,4);
        c_distance = yuxian_xiansidu(new_x,X,p,F);
        [population,f_idx]=elitism(pop_num,new_x,F,MF,c_distance);
        f_x=new_f_x(f_idx,:);

        
        
          if mod(i,5)==0   
               F0=find(F(1,:)==1);
               recordfit(1,i/5+1)=min(new_f_x(F0,1));
               recordfit(2,i/5+1)=min(new_f_x(F0,2));
          end
%         scatter(s(:,1),s(:,2));  
%         drawnow;       
        fprintf('%d iter is ok\n',i);     
            
    end
    
 time4 = cputime - T;              %runtime
 recordfitl=recordfit;
  

        
 s=Ms;
%         subplot(2,4,1); 
        scatter(s(:,1),s(:,2),'o','DisplayName','GL-EA-GLOBAL');
%         legend('MY')        
        hold on;
        s=new_f_x(F(1,:)==1,:);
%         subplot(2,4,1); 
        scatter(s(:,1),s(:,2),'filled','h','DisplayName','GL-EA-LOCAL');
%         legend('MY') 
        legend('GL-EA-GLOBAL','GL-EA-LOCAL')
xlabel('f_1=1/Volume');
ylabel('f_2=RMSE');


        fprintf('%.6f %.6f\n',s');
        sl=new_f_x(F(1,:)==1,:);
        s1=new_x(F(1,:)==1,:);
        [~,A] = unmixed2(X,X(:,s1(1,:)==1),3);

   
save Local_data recordfitl A sl
   
   
   
   
   