
clear
clc

% 相对MYEA5，采用了spearEA的得分初始化，种群数设为40，其余和MYEA8一致
% load Urban_R162.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %307.307


load samson_1.mat
% load end3.mat
load samson_groundth.mat
reference = M;
X = V; %95.95

% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100

% load CupriteS1_R188.mat
% load groundTruth_Cuprite_nEnd12.mat
% reference = M;
% X = Y./1000; %250.190



[L,n] = size(X); 
row =95;
col =95;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
p = 3;   % Number of endmembers   

%dimension reduction   
trans = dim_reduction(p,X,image_3d);  % p=p
X_reduction = trans * X;









pop_num=40;
population=zeros(pop_num,n);

%%%%%%%%%%%%%%%%%%
Mask = eye(n);
f_mask=zeros(n,1);
for i=1:n
    f_mask(i)=unmixed(X,X(:,Mask(i,:)==1),1);
end
[f_mask,M_idx]=sort(f_mask);
for i = 1 : pop_num 
    M_idx(lunpan_s(p,f_mask))
    population(i,M_idx(lunpan_s(p,f_mask))) = 1;
end
sum(population,2)
%********************************************************************************************************************************************************%

    off=zeros(pop_num,n);
    f_x=zeros(pop_num,3);
    %the first objective is f; for the special solution 00...00 (i.e., it does not select any variable) and the solutions with the number of selected variables not smaller than 2*k, set its first objective value as inf.  
    new_x=zeros(2*pop_num,n);
    new_f_x=zeros(2*pop_num,2);
    recordfit1=[];
    recordfit2=[];
    temp2=[];
    temp1=[];
    record_SAM = [];        

%     for i=1:pop_num
%         population(i,randperm(n,p))=1;       
%     end

    for i=1:pop_num
        f_x(i,1)=1/volume(X_reduction(:,population(i,:)==1));       
        f_x(i,2)=unmixed(X,X(:,population(i,:)==1),1);
    end 
    [F,MF] = NDSort(f_x,5);
    F0=find(F(1,:)==1);
    gbest=population(F0(randperm(numel(F0),1)),:);

    T=300;
    for i=1:T
        off=zeros(pop_num,n);
        new_x=zeros(2*pop_num,n);
        for j =1:pop_num 
            p_index = TournamentSelection(20,2,f_x(:,1),f_x(:,2));
            while p_index(1)==p_index(2)
                p_index = TournamentSelection(10,2,f_x(:,1),f_x(:,2));
            end
            a1=p_index(1);
            a2=p_index(2);
            z_p = ((f_x(a1,1)<f_x(a2,1)) + (f_x(a1,2)<f_x(a2,2)));

            pa1=population(a1,:);
            pa2=population(a2,:);
            if i<=250 
                if z_p==2
                    if rand()<0.3
                        off(j,:)=fdcby(pa1);
                    else
                        pa1_idx=find(pa1==1);
                        X_best=X(:,pa1_idx);
                        pa2_idx=find(pa2==1);
                        X_pa2 = X(:,pa2_idx);
                        S = SAMpipei(X_best,X_pa2);
                        [~,S_idx]=sort(S(3,1:p),'descend');
                        oo=0:p;
                        v=setdiff(oo,S(1,:));
                        if (v)
                            S=S(:,S_idx);
                            v_idx = v(random_choose(length(v),1));
                            pa2_idx(S(2,1))=pa1_idx(v_idx);
                            for k1=1:p-1
                                t=S(1,k1);
                                for k2=k1+1:p
                                    if t==S(1,k2)
                                        v_idx = v(random_choose(length(v),1));
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
                    if rand()<0.3
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
                            pa1_idx=[pa2_idx,m1];
                        end
                        off(j,pa1_idx)=1;                    
                    end
                end

            else
                pa1_idx = find(pa1==1);
%                 pa2_idx = find(pa2==1);     
                pa1_idx = pa1_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
%                 pa2_idx = pa2_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
                while any(pa1_idx>n)||any(pa1_idx<=1)
                    pa1_idx = find(pa1==1);
                    pa1_idx = pa1_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
                end
%                 while any(pa2_idx>n)||any(pa2_idx<=1)
%                     pa2_idx = find(pa2==1);
%                     pa2_idx = pa2_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
%                 end
                pa1_idx=unique(pa1_idx);
                if length(pa1_idx)<p
                    m1=randperm(n,p-length(pa1_idx));
                    pa1_idx=[pa1_idx,m1];
                end                
%                 pa2_idx=unique(pa2_idx);
%                 if length(pa2_idx)<p
%                     m2=randperm(n,p-length(pa2_idx));
%                     pa2_idx=[pa2_idx,m2];
%                 end                
                off(j,pa1_idx)=1;
%                 off(j,pa2_idx)=1;
            end 
        end
          
        new_x(1:pop_num,:)=population;
        new_x(pop_num+1:2*pop_num,:)=off;
        [new_x,id_newx] = unique(new_x,'row');
        if length(id_newx)<2*pop_num
            for j = length(id_newx)+1:3*pop_num
                new_x(j,randperm(n,p)) = 1;             
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
        c_distance = CrowdingDistance(new_f_x,F);
        F0=find(F(1,:)==1);
        gbest=new_x(F0(randperm(numel(F0),1)),:); 
        [population,f_idx]=elitism(pop_num,new_x,F,MF,c_distance);
        f_x=new_f_x(f_idx,:);

%         s=new_f_x(F(1,:)==1,:);
%         scatter(s(:,1),s(:,2));
%         drawnow;       
        fprintf('%d iter is ok\n',i);       
    end
        s=new_f_x(F(1,:)==1,:);
        plot(s(:,1),s(:,2),'o');
        hold on;
        saveas(gcf,'pf.jpg')
        fprintf('%.6f %.6f\n',s');
%     generations=1:250;
%     plot(generations,recordfit1,'r.-',generations,recordfit2,'y.-','linewidth',2)
%     saveas(gcf,'shoulian.jpg')
   
    [~,idx_4]=sort(s(:,1));
    s=s(idx_4,:)    

%    閸栧綊鍘ら崗澶庢皑閻晠锟???
   for i = 1:20
       endmember = X(:,population(i,:)==1);
       SAM = SAMpipei(reference,endmember);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end 
   


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

