
clear
clc



% 初始化，比较每个x中1与其他1的余弦相似度，大于0.5不接受
%初始化策略，最优解指导更新，余弦相似度算子。
load Urban_R162.mat
load end6_groundTruth.mat
reference = M;
X = Y./1000;  %307.307


% load samson_1.mat
% % load end3.mat
% load samson_groundth.mat
% reference = M;
% X = V; %95.950

% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %100.100

% load CupriteS1_R188.mat
% load groundTruth_Cuprite_nEnd12.mat
% reference = M;
% X = Y./1000; %250.190



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



%********************************************************************************************************************************************************%
    pop_num=20;
    population=zeros(pop_num,n);
    off1=zeros(pop_num,n);
    off2=zeros(pop_num,n);
    f_x=zeros(pop_num,3);
    %the first objective is f; for the special solution 00...00 (i.e., it does not select any variable) and the solutions with the number of selected variables not smaller than 2*k, set its first objective value as inf.  
    new_x=zeros(3*pop_num,n);
    new_f_x=zeros(3*pop_num,2);
    recordfit1=[];
    recordfit2=[];
    temp2=[];
    temp1=[];
    record_SAM = [];        

hang=fix(row/p)/2;
lie=fix(col/p)/2;
r=hang^2+lie^2;
    for i=1:pop_num
        q=zeros(1,p);
        z=zeros(p,2);
        for j=1:p
            q(j)=random_choose(n,1);
            z(j,1)=ceil(q(j)/row);
            z(j,2)=mod(q(j),col);           
        end
        while ((z(2,1)-z(1,1))^2+(z(2,2)-z(1,2))^2)<r
            q(2)=random_choose(n,1);
            z(2,1)=ceil(q(2)/row);
            z(3,2)=mod(q(3),col);  
        end
        while ((z(3,1)-z(2,1))^2+(z(3,2)-z(2,2))^2)<r||((z(3,1)-z(1,1))^2+(z(3,2)-z(1,2))^2)<r
            q(3)=random_choose(n,1);
            z(3,1)=ceil(q(3)/row);
            z(3,2)=mod(q(3),col);  
        end
        if p==4
            while ((z(4,1)-z(3,1))^2+(z(4,2)-z(3,2))^2)<r||((z(4,1)-z(2,1))^2+(z(4,2)-z(2,2))^2)<r||((z(4,1)-z(1,1))^2+(z(4,2)-z(1,2))^2)<r
                q(4)=random_choose(n,1);
                z(4,1)=ceil(q(4)/row);
                z(4,2)=mod(q(4),col);  
            end
        end
        if p==6
            while ((z(4,1)-z(3,1))^2+(z(4,2)-z(3,2))^2)<r||((z(4,1)-z(2,1))^2+(z(4,2)-z(2,2))^2)<r||((z(4,1)-z(1,1))^2+(z(4,2)-z(1,2))^2)<r
                q(4)=random_choose(n,1);
                z(4,1)=ceil(q(4)/row);
                z(4,2)=mod(q(4),col);  
            end
            while ((z(5,1)-z(4,1))^2+(z(5,2)-z(4,2))^2)<r||((z(5,1)-z(3,1))^2+(z(5,2)-z(3,2))^2)<r||((z(5,1)-z(2,1))^2+(z(5,2)-z(2,2))^2)<r||((z(5,1)-z(1,1))^2+(z(5,2)-z(1,2))^2)<r
                q(5)=random_choose(n,1);
                z(5,1)=ceil(q(5)/row);
                z(5,2)=mod(q(5),col);  
            end
            while ((z(6,1)-z(5,1))^2+(z(6,2)-z(5,2))^2)<r||((z(6,1)-z(4,1))^2+(z(6,2)-z(4,2))^2)<r||((z(6,1)-z(3,1))^2+(z(6,2)-z(3,2))^2)<r||((z(6,1)-z(2,1))^2+(z(6,2)-z(2,2))^2)<r||((z(6,1)-z(1,1))^2+(z(6,2)-z(1,2))^2)<r
                q(6)=random_choose(n,1);
                z(6,1)=ceil(q(6)/row);
                z(6,2)=mod(q(6),col);  
            end            
        end
        population(i,q) = 1;        
    end

    for i=1:pop_num
        f_x(i,1)=1/volume(X_reduction(:,population(i,:)==1));       
        f_x(i,2)=unmixed(X,X(:,population(i,:)==1),1);
    end 
    [F,MF] = NDSort(f_x,5);
    F0=find(F(1,:)==1);
    gbest=population(F0(randperm(numel(F0),1)),:);

    T=300;
    for i=1:T
        off1=zeros(pop_num,n);
        off2=zeros(pop_num,n);
        new_x=zeros(3*pop_num,n);
        for j =1:pop_num  
%             p_index = TournamentSelection(5,2,f_x(:,1),f_x(:,2));        
%             a1=p_index(1);
%             a2=p_index(2);
%             a1=randperm(pop_num,1);
            a2=randperm(pop_num,1);
%             while a1==a2
%                 a2=randperm(pop_num,1);
%             end
            pa1=gbest;
            pa2=population(a2,:);
            if i<=200||i>250
                off1(j,:)=fdcby(pa1);
                if rand()<0.3
                    off2(j,:)=fdcby(pa2);
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
                    off2(j,pa2_idx)=1;
                end
            else
                %閹垫澘锟???
                pa1_idx = find(pa1==1);
                pa2_idx = find(pa2==1);     
                pa1_idx = pa1_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
                pa2_idx = pa2_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
                while any(pa1_idx>n)||any(pa1_idx<=1)
                    pa1_idx = find(pa1==1);
                    pa1_idx = pa1_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
                end
                while any(pa2_idx>n)||any(pa2_idx<=1)
                    pa2_idx = find(pa2==1);
                    pa2_idx = pa2_idx +randi([-3,3],1,p)*row+randi([-3,3],1,p);
                end
                pa1_idx=unique(pa1_idx);
                if length(pa1_idx)<p
                    m1=randperm(n,p-length(pa1_idx));
                    pa1_idx=[pa1_idx,m1];
                end                
                pa2_idx=unique(pa2_idx);
                if length(pa2_idx)<p
                    m2=randperm(n,p-length(pa2_idx));
                    pa2_idx=[pa2_idx,m2];
                end                
                off1(j,pa1_idx)=1;
                off2(j,pa2_idx)=1;
            end 
        end
          
        new_x(1:pop_num,:)=population;
        new_x(pop_num+1:2*pop_num,:)=off1;
        new_x(2*pop_num+1:3*pop_num,:)=off2;
        [new_x,id_newx] = unique(new_x,'row');
        if length(id_newx)<3*pop_num
            for j = length(id_newx)+1:3*pop_num
                q=zeros(1,p);
                z=zeros(p,2);
                for k=1:p
                    q(k)=random_choose(n,1);
                    z(k,1)=ceil(q(k)/row);
                    z(k,2)=mod(q(k),col);           
                end
                while ((z(2,1)-z(1,1))^2+(z(2,2)-z(1,2))^2)<r||q(2)==q(1)
                    q(2)=random_choose(n,1);
                    z(2,1)=ceil(q(2)/row);
                    z(3,2)=mod(q(3),col);  
                end
                while ((z(3,1)-z(2,1))^2+(z(3,2)-z(2,2))^2)<r||((z(3,1)-z(1,1))^2+(z(3,2)-z(1,2))^2)<r||q(3)==q(1)||q(3)==q(2)
                    q(3)=random_choose(n,1);
                    z(3,1)=ceil(q(3)/row);
                    z(3,2)=mod(q(3),col);  
                end
                if p==4
                    while q(4)==q(1)||q(4)==q(2)||q(4)==q(3)||((z(4,1)-z(3,1))^2+(z(4,2)-z(3,2))^2)<r||((z(4,1)-z(2,1))^2+(z(4,2)-z(2,2))^2)<r||((z(4,1)-z(1,1))^2+(z(4,2)-z(1,2))^2)<r
                        q(4)=random_choose(n,1);
                        z(4,1)=ceil(q(4)/row);
                        z(4,2)=mod(q(4),col);  
                    end
                end
                if p==6
                    while q(4)==q(1)||q(4)==q(2)||q(4)==q(3)||((z(4,1)-z(3,1))^2+(z(4,2)-z(3,2))^2)<r||((z(4,1)-z(2,1))^2+(z(4,2)-z(2,2))^2)<r||((z(4,1)-z(1,1))^2+(z(4,2)-z(1,2))^2)<r
                        q(4)=random_choose(n,1);
                        z(4,1)=ceil(q(4)/row);
                        z(4,2)=mod(q(4),col);  
                    end
                    while q(5)==q(1)||q(5)==q(2)||q(5)==q(3)||q(5)==q(4)||((z(5,1)-z(4,1))^2+(z(5,2)-z(4,2))^2)<r||((z(5,1)-z(3,1))^2+(z(5,2)-z(3,2))^2)<r||((z(5,1)-z(2,1))^2+(z(5,2)-z(2,2))^2)<r||((z(5,1)-z(1,1))^2+(z(5,2)-z(1,2))^2)<r
                        q(5)=random_choose(n,1);
                        z(5,1)=ceil(q(5)/row);
                        z(5,2)=mod(q(5),col);  
                    end
                    while q(6)==q(1)||q(6)==q(2)||q(6)==q(3)||q(6)==q(4)||q(6)==q(5)||((z(6,1)-z(5,1))^2+(z(6,2)-z(5,2))^2)<r||((z(6,1)-z(4,1))^2+(z(6,2)-z(4,2))^2)<r||((z(6,1)-z(3,1))^2+(z(6,2)-z(3,2))^2)<r||((z(6,1)-z(2,1))^2+(z(6,2)-z(2,2))^2)<r||((z(6,1)-z(1,1))^2+(z(6,2)-z(1,2))^2)<r
                        q(6)=random_choose(n,1);
                        z(6,1)=ceil(q(6)/row);
                        z(6,2)=mod(q(6),col);  
                    end            
                end
                new_x(j,q) = 1;             
            end
        end
        for j = 1:3*pop_num
            if sum(new_x(j,:))~=p
                new_x(j,:)=zeros(1,n);
                new_x(j,randperm(n,p))=1;
            end
            new_f_x(j,1) = 1/volume(X_reduction(:,new_x(j,:)==1));
            new_f_x(j,2) = unmixed(X,X(:,new_x(j,:)==1),1);
        end 

        
        [F,MF] = NDSort(new_f_x,4); 
        c_distance = yuxian_xiansidu(new_x,X,p,F);
        F0=find(F(1,:)==1);
        gbest=new_x(F0(randperm(numel(F0),1)),:); 
        [population,f_idx]=elitism(pop_num,new_x,F,MF,c_distance);
%         f_x=new_f_x(f_idx,:);

%         s=new_f_x(F(1,:)==1,:);
%         scatter(s(:,1),s(:,2));
%         drawnow;       
        fprintf('%d iter is ok\n',i);       
    end
        s=new_f_x(F(1,:)==1,:);
        plot(s(:,1),s(:,2),'o');
        hold on;
%         saveas(gcf,'pf.jpg')
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


