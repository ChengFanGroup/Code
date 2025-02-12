
clear
clc



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
% X = Y./1000; %99.100

% load CupriteS1_R188.mat
% load groundTruth_Cuprite_nEnd12.mat
% reference = M;
% X = Y./1000; %250.190





[L,n] = size(X); %N为像元数，L为波段数
row =95;
col =95;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
p = 3;   % Number of endmembers   端元数量

%dimension reduction   降维
trans = dim_reduction(p,X,image_3d);  % p=p
X_reduction = trans * X;



%********************************************************************************************************************************************************%
    pop_num=20;
    population=zeros(pop_num,n);
    off1=zeros(pop_num,n);
    off2=zeros(pop_num,n);
    fitness=zeros(pop_num,3);
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
        fitness(i,1)=unmixed(X,X(:,population(i,:)==1),1);
        fitness(i,2)=1/volume(X_reduction(:,population(i,:)==1));
    end 
    [F,MF] = NDSort(fitness,5);
    F0=find(F(1,:)==1);
    gbest=population(F0(randperm(numel(F0),1)),:);  

    T=300;
    for i=1:T
        off1=zeros(pop_num,n);
        off2=zeros(pop_num,n);
        new_x=zeros(3*pop_num,n);
        for j =1:pop_num
            a1=randperm(pop_num,1);
            a2=randperm(pop_num,1);
            while a1==a2
                a2=randperm(pop_num,1);
            end
            pa1=population(a1,:);
            pa2=population(a2,:);
            if i<=250
                rand1=rand();
                if rand1<0.2
                    off1(j,:)=fdcby(pa1,r,row,col);
                    off2(j,:)=fdcby(pa2,r,row,col);
%                 elseif rand1<0.6 
%                     pa1_idx=find(pa1==1);
%                     pa2_idx=find(pa2==1);
%                     v=pa1-pa2;
%                     positive_idx = find(v>0);
%                     negative_idx = find(v<0);
%                     if (positive_idx)
%                         v_positive_idx = positive_idx(random_choose(length(positive_idx),1));                 
%                         v_negative_idx = negative_idx(random_choose(length(negative_idx),1));
%                         off1(j,:)=pa1;
%                         off2(j,:)=pa2;                       
%                         off1(j,v_positive_idx)=1;
%                         off1(j,v_negative_idx)=0;
%                         off2(j,v_positive_idx)=0;
%                         off2(j,v_negative_idx)=1;                       
%                     else                        
%                         off1(j,:)=fdcby(pa1,r,row,col);
%                         off2(j,:)=fdcby(pa2,r,row,col);                      
%                     end
                else 
                    pa1_idx=find(pa1==1);
                    pa2_idx=find(pa2==1);
                    [off1_idx,off2_idx]=SBX(pa1_idx,pa2_idx,n);
                    off1(j,off1_idx)=1;
                    off2(j,off2_idx)=1;
                 
                end
            else
                %扰动
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
                off1(j,pa1_idx)=1;
                off2(j,pa2_idx)=1;
            end 
        end

        %%%%%上为产解部分
          
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
                new_x(j,q) = 1;        
            end
        end
        for j = 1:3*pop_num           %calculate objective function value 计算目标函数�?
            new_f_x(j,1) = unmixed(X,X(:,new_x(j,:)==1),1);
            new_f_x(j,2) = 1/volume(X_reduction(:,new_x(j,:)==1));
        end 

        
        %��֧������
%         [F,new_f_x]=non_domination_sort(3*pop_num,new_f_x,2);
%         gbest=new_x(F(1).ss(randperm(numel(F(1).ss),1)),:);
%         c_distance=crowding_distance_sort(F,new_f_x);
        [F,MF] = NDSort(new_f_x,4);
        c_distance = CrowdingDistance(new_f_x,F);
%         F0=find(F(1,:)==1);
%         gbest=new_x(F0(randperm(numel(F0),1)),:); 
        population=elitism(pop_num,new_x,F,MF,c_distance);

%         s=new_f_x(F(1,:)==1,:);
%         scatter(s(:,2),s(:,1));
%         drawnow;       
        fprintf('��%d�����\n',i);       

%         [~,idx11]=sort(temp1fit(:,1));
%         [~,idx12]=sort(temp1fit(:,2));         
% 
%         best1fit=temp1fit(idx11(1),1);
%         best2fit=temp1fit(idx12(1),2); 
%        fit(1,1)=best1fit;
%        fit(1,2)=best2fit;
% 
%        recordfit1=[recordfit1;fit(1,1)];
%        recordfit2=[recordfit2;fit(1,2)];
    end
        s=new_f_x(F(1,:)==1,:);
        plot(s(:,2),s(:,1),'o');
        hold on;    
%     generations=1:250;
%     plot(generations,recordfit1,'r.-',generations,recordfit2,'y.-','linewidth',2)
%     saveas(gcf,'shoulian.jpg')
    
    fitness2=zeros(pop_num,3);
    for i=1:pop_num
        fitness2(i,1)=unmixed(X,X(:,population(i,:)==1),1);
        fitness2(i,3)= sum(population(i,:));
        if fitness2(i,3)==p
            fitness2(i,2)=1/volume(X_reduction(:,population(i,:)==1));
        end     
    end
    fitness2
    [~,idx_4]=sort(fitness2(:,1));
    fitness2=fitness2(idx_4,:)

    

%    匹配光谱矩阵
   for i = 1:10
       endmember = X(:,population(i,:)==1);
       SAM = SAMpipei(reference,endmember);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end   
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-','linewidth',2)


% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)



 
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
% 



% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-',num,endmember1(:,7),'m.-',num,endmember1(:,8),'m.-',num,endmember1(:,9),'m.-',num,endmember1(:,10),num,endmember1(:,11),'m.-',num,endmember1(:,12),'m.-','linewidth',2)


