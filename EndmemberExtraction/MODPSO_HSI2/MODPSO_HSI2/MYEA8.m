
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
    pop_num=20;
    population=zeros(pop_num,n);
    off=zeros(pop_num,n);
    f_x=zeros(pop_num,3);
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
        f_x(i,2)=unmixed(X,X(:,population(i,:)==1),1);
    end 
    f_x
    [F,MF] = NDSort(f_x,5);
    F0=find(F(1,:)==1);
    gbest=population(F0(randperm(numel(F0),1)),:);
    
   recordfit=zeros(2,41);         
   recordfit(1,1)=mean(f_x(:,1));
   recordfit(2,1)=mean(f_x(:,2));


    maxiter=300;
    for i=1:maxiter
        off=zeros(pop_num,n);
        new_x=zeros(2*pop_num,n);
        for j =1:pop_num  
%             p_index = TournamentSelection(30,2,f_x(:,1),f_x(:,2));
%             while p_index(1)==p_index(2)
%                 p_index = TournamentSelection(30,2,f_x(:,1),f_x(:,2));
%             end
%             a1=p_index(1);
%             a2=p_index(2);
            
            a1=TournamentSelection(40,1,f_x(:,1),f_x(:,2));
            a2=TournamentSelection(2,1,f_x(:,1),f_x(:,2));


            z_p = ((f_x(a1,1)<f_x(a2,1)) + (f_x(a1,2)<f_x(a2,2)));

            pa1=population(a1,:);
            pa2=population(a2,:);
            if i<=(maxiter*4)/5 
                if z_p==2
                    if rand()<0.5
                        off(j,:)=fdcby(pa1);
                    else
                        pa1_idx=find(pa1==1);
                        X_best=X(:,pa1_idx);
                        pa2_idx=find(pa2==1);
                        X_pa2 = X(:,pa2_idx);
                        S = SAMpipei(X_best,X_pa2);
                        S = S(:,1:p);
                        [~,S_idx]=sort(S(3,1:p),'descend');
                        oo=1:p;
                        v=setdiff(oo,S(1,:));
                        if (v)
                            S=S(:,S_idx);
                            tt=1;
                            for k1=1:p-1
                                t=S(1,k1);   
                                for k2=k1+1:p
                                    if t==S(1,k2)
                                        v_idx = v(tt);
                                        tt=tt+1;
                                        pa2_idx(S(2,k1))=pa1_idx(v_idx);
                                        break;
                                    end                             
                                end
                            end                  
                        else
                            pa2_idx(S(2,S_idx(1)))=pa1_idx(S(1,S_idx(1)));                        
                        end
                        pa2_idx=unique(pa2_idx);
                        if length(pa2_idx)<p
                            m2=randperm(n,p-length(pa2_idx));
                            pa2_idx=[pa2_idx,m2];
                        end
                        off(j,pa2_idx)=1;
                    end
                else
                    if rand()<0.5
                        off(j,:)=fdcby(pa2);
                    else
                        pa2_idx=find(pa2==1);
                        X_best=X(:,pa2_idx);
                        pa1_idx=find(pa1==1);
                        X_pa1 = X(:,pa1_idx);
                        S = SAMpipei(X_best,X_pa1);
                        [~,S_idx]=sort(S(3,1:p),'descend');
                        oo=0:p;
                        v=setdiff(oo,S(1,:));
                        if (v)
                            S=S(:,S_idx);
                            v_idx = v(random_choose(length(v),1));
                            pa1_idx(S(2,1))=pa2_idx(v_idx);
                            for k1=1:p-1
                                t=S(1,k1);
                                for k2=k1+1:p
                                    if t==S(1,k2)
                                        v_idx = v(random_choose(length(v),1));
                                        pa1_idx(S(2,k1))=pa2_idx(v_idx);
                                        break;
                                    end                             
                                end
                            end                  
                        else
                            pa1_idx(S(2,S_idx(1)))=pa2_idx(S(1,S_idx(1)));                        
                        end
                        pa1_idx=unique(pa1_idx);
                        if length(pa1_idx)<p
                            m1=randperm(n,p-length(pa1_idx));
                            pa1_idx=[pa1_idx,m1];
                        end
                        
                        off(j,pa1_idx)=1;
                    end
                end

            else
                if z_p==2
                    pa1_idx = find(pa1==1);
                else
                    pa1_idx = find(pa2==1);
                end
                pa1_idx = pa1_idx +randi([-6,6],1,p)*row+randi([-6,6],1,p);
                while any(pa1_idx>n)||any(pa1_idx<=1)
                    pa1_idx = find(pa1==1);
                    pa1_idx = pa1_idx +randi([-6,6],1,p)*row+randi([-6,6],1,p);
                end
                pa1_idx=unique(pa1_idx);
                if length(pa1_idx)<p
                    m1=randperm(n,p-length(pa1_idx));
                    pa1_idx=[pa1_idx,m1];
                end                             
                off(j,pa1_idx)=1;
            end 
        end
          
        new_x(1:pop_num,:)=population;
        new_x(pop_num+1:2*pop_num,:)=off;
        [new_x,id_newx] = unique(new_x,'row');
        if length(id_newx)<2*pop_num
            for j = length(id_newx)+1:2*pop_num
                new_x(j,randperm(n,p)) = 1;
                
                
%                 a1=TournamentSelection(40,1,f_x(:,1),f_x(:,2));
%                 pa1=population(a1,:);
%                 pa1_idx=find(pa1==1);
%                 X_best=X(:,pa1_idx);
%                 pa2=new_x(j,:);
%                 pa2_idx=find(pa2==1);
%                 X_pa2 = X(:,pa2_idx);
%                 S = SAMpipei(X_best,X_pa2);
%                 [~,S_idx]=sort(S(3,1:p),'descend');
%                 oo=0:p;
%                 v=setdiff(oo,S(1,:));
%                 if (v)
%                     S=S(:,S_idx);
%                     v_idx = v(random_choose(length(v),1));
%                     pa2_idx(S(2,1))=pa1_idx(v_idx);
%                     for k1=1:p-1
%                         t=S(1,k1);
%                         for k2=k1+1:p
%                             if t==S(1,k2)
%                                 v_idx = v(random_choose(length(v),1));
%                                 pa2_idx(S(2,k1))=pa1_idx(v_idx);
%                                 break;
%                             end                             
%                         end
%                     end                  
%                 else
%                     pa2_idx(S(2,S_idx(1)))=pa1_idx(S(1,S_idx(1)));                        
%                 end
%                 pa2_idx=unique(pa2_idx);
%                 if length(pa2_idx)<p
%                     m2=randperm(n,p-length(pa2_idx));
%                     pa2_idx=[pa2_idx,m2];
%                 end
%                 new_x(j,:)=zeros(1,n);
%                 new_x(j,pa2_idx)=1;

            end
    end
        
        for j = 1:2*pop_num
            if sum(new_x(j,:))~=p
                new_x(j,:)=zeros(1,n);
                new_x(j,randperm(n,p))=1;
            end
            new_f_x(j,1) = 1/volume(X_reduction(:,new_x(j,:)==1));
            new_f_x(j,2) = unmixed(X,X(:,new_x(j,:)==1),1);
        end 

        
        [F,MF] = NDSort(new_f_x,4);
%         c_distance = CrowdingDistance(new_f_x,F);
        c_distance = yuxian_xiansidu(new_x,X,p,F);
%         F0=find(F(1,:)==1);
%         gbest=new_x(F0(randperm(numel(F0),1)),:); 
        [population,f_idx]=elitism(pop_num,new_x,F,MF,c_distance);
        f_x=new_f_x(f_idx,:);

        
        
          if mod(i,5)==0       
               recordfit(1,i/5+1)=mean(new_f_x(:,1));
               recordfit(2,i/5+1)=mean(new_f_x(:,2));
          end
       
        s=new_f_x(F(1,:)==1,:);
        s
%         scatter(s(:,1),s(:,2));  
%         drawnow;       
        fprintf('%d iter is ok\n',i); 
        
       if i==(((maxiter*4)/5)-1)
            s=new_f_x(F(1,:)==1,:);
            [~,idx_4]=sort(s(:,1));
            s160=s(idx_4,:)    
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
 time4 = cputime - T;              %runtime
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
Mbest_x=best_x;
Ms=s;
Mrecord_SAM =record_SAM; 
save MYEA_data Mbest_x Ms Mrecord_SAM record_SAM160 s160 time4 recordfit4
   
   
   
   
   
% num=1:1:L;
% endmember1=X(:,best_x(1,:)==1);
% SAM1 = SAMpipei(reference,endmember1);
% [~,SAM1_idx]=sort(SAM1(1,1:p));
% SAM1=SAM1(:,SAM1_idx);
% subplot(2,4,2);
% % legend('MY')
% plot(num,endmember1(:,SAM1(2,1)),'r.-','DisplayName','MY')
%  hold on;
% subplot(2,4,3);
% % legend('MY')
% plot(num,endmember1(:,SAM1(2,2)),'r.-','DisplayName','MY')
%  hold on;
% subplot(2,4,4);
% % legend('MY')
% plot(num,endmember1(:,SAM1(2,3)),'r.-','DisplayName','MY')
%  hold on;
% subplot(2,4,5); 
% % legend('MY')
% plot(num,endmember1(:,SAM1(2,4)),'r.-','DisplayName','MY')
%  hold on;  


% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)



 
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
% 



% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-','linewidth',2)

% 
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-',num,endmember1(:,7),'r.-',num,endmember1(:,8),'b.-',num,endmember1(:,9),'k.-',num,endmember1(:,10),'g.-',num,endmember1(:,11),'m.-',num,endmember1(:,12),'y.-','linewidth',2)

