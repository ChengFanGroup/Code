
clear
clc
load Urban_R162.mat
load end5_groundTruth.mat
reference = M;
X = (Y./1000)';  %307.307
% load samson_1.mat
% % load end3.mat
% load samson_groundth.mat
% reference = M;
% X = V'; %95.95
options = [2;100;1e-5;1]; 
[center,U,obj_fcn] = FCMCluster(X,6,options); 
% plot(X(:,1),X(:,2),'o'); 
% hold on; 
index1=find(U(1,:)==max(U));%找出划分为第一类的数据索引 
index2=find(U(2,:)==max(U));%找出划分为第二类的数据索引 
index3=find(U(3,:)==max(U));%找出划分为第三类的数据索引 
index4=find(U(4,:)==max(U));%找出划分为第四类的数据索引 
index5=find(U(5,:)==max(U));%找出划分为第五类的数据索引
index6=find(U(6,:)==max(U));%找出划分为第五类的数据索引
index=[];
index(1).ss=index1;
index(2).ss=index2;
index(3).ss=index3;
index(4).ss=index4;
index(5).ss=index5;
index(6).ss=index6;
X=X';

% load Urban_R162.mat
% load end5_groundTruth.mat
% reference = M;
% X = Y./1000;  %307.307


% load jasperRidge2_R198.mat
% load end4.mat
% reference = M;
% X = Y./1000; %99.100

% load CupriteS1_R188.mat
% load groundTruth_Cuprite_nEnd12.mat
% reference = M;
% X = Y./1000; %250.190





[L,n] = size(X); %N涓哄儚鍏冩暟锛孡涓烘尝娈垫暟
row =307;
col =307;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
p = 6;   % Number of endmembers   绔厓鏁伴噺

%dimension reduction   闄嶇淮
trans = dim_reduction(p,X,image_3d);  % p=p
X_reduction = trans * X;

%********************************************************************************************************************************************************%
    pop_num=20;
    x=zeros(pop_num,n);
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
%     for i=1:pop_num
%         %鍒濆鍖栧潎鍖?鍒嗗竷
%         q=[];        
%         for j=1:p
%             q(j)=random_choose(floor(n/p),1)+floor(n/p)*(j-1);
%         end
%         population(i,q) = 1;
%     end

    for i=1:pop_num
        for j=1:p
            x(i,j)=randperm(numel(index(j).ss),1);
        end
    end
    for i=1:pop_num
        tx=zeros(1,p);
        for j=1:p
            tx(j)=index(j).ss(x(i,j));
        end
        f_x(i,1)=unmixed(X,X(:,tx),1);
        f_x(i,2)=1/volume(X_reduction(:,tx));
    end 
    [F,MF] = NDSort(f_x,5);
    F0=find(F(1,:)==1);
    gbest=x(F0(randperm(numel(F0),1)),:);  

    T=300;
    for i=1:250
        off1=zeros(pop_num,n);
        off2=zeros(pop_num,n);
        new_x=zeros(3*pop_num,n);
        for j =1:pop_num
            a1=randperm(pop_num,1);
            a2=randperm(pop_num,1);
            while a1==a2
                a2=randperm(pop_num,1);
            end
            pa1=x(a1,:);
            pa2=x(a2,:);
            
            off1(j,:)=pa1+round(rand()*(gbest-pa1));
            off2(j,:)=pa2+round(rand()*(gbest-pa2));       
            for k=1:p
                if off1(j,k)<=0 ||off1(j,k)>=numel(index(k).ss)
                    off1(j,k)=round(rand()*numel(index(k).ss));
                end                 
                if off2(j,k)<=0 ||off2(j,k)>=numel(index(k).ss)
                    off2(j,k)=round(rand()*numel(index(k).ss));
                end                   
            end               
        end
        
        %%%%%涓婁负浜цВ閮ㄥ垎
          
        new_x(1:pop_num,:)=x;
        new_x(pop_num+1:2*pop_num,:)=off1;
        new_x(2*pop_num+1:3*pop_num,:)=off2;
        [new_x,id_newx] = unique(new_x,'row');
        if length(id_newx)<3*pop_num
            for j = length(id_newx)+1:3*pop_num
                for k=1:p
                    new_x(j,k)=randperm(numel(index(k).ss),1);
                end
            end
        end
        for j = 1:3*pop_num           %calculate objective function value 璁＄畻鐩爣鍑芥暟鍊?
            tx=zeros(1,p);
            for k=1:p
                tx(k)=index(k).ss(new_x(j,k));
            end
            new_f_x(j,1)=unmixed(X,X(:,tx),1);
            new_f_x(j,2)=1/volume(X_reduction(:,tx));
        end 

        
        %闈炴敮閰嶆帓搴忥紝鎷ユ尋搴﹁绠?,閫夊嚭鏂扮殑绉嶇兢
%         [F,new_f_x]=non_domination_sort(3*pop_num,new_f_x,2);
%         gbest=new_x(F(1).ss(randperm(numel(F(1).ss),1)),:);
%         c_distance=crowding_distance_sort(F,new_f_x);
        [F,MF] = NDSort(new_f_x,4);
        c_distance = CrowdingDistance(new_f_x,F);
        F0=find(F(1,:)==1);
        gbest=new_x(F0(randperm(numel(F0),1)),:); 
        x=elitism(pop_num,new_x,F,MF,c_distance);

        s=new_f_x(F(1,:)==1,:);
        scatter(s(:,2),s(:,1));
        drawnow;       
        fprintf('绗?%d浠ｅ凡瀹屾垚\n',i);       

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
  
%     generations=1:250;
%     plot(generations,recordfit1,'r.-',generations,recordfit2,'y.-','linewidth',2)
%     saveas(gcf,'shoulian.jpg')
    
    fitness2=zeros(pop_num,2);
    for i=1:pop_num
        tx=zeros(1,p);
        for j=1:p
            tx(j)=index(j).ss(x(i,j));
        end
        fitness2(i,1)=unmixed(X,X(:,tx),1);
        fitness2(i,2)=1/volume(X_reduction(:,tx));   
    end
    
    fitness2
    [~,idx_4]=sort(fitness2(:,1));
    fitness2=fitness2(idx_4,:)
%     scatter(temp1fit(1:15,2),temp1fit(1:15,1));
%     drawnow;
    

%    鍖归厤鍏夎氨鐭╅樀
   for i = 1:10
       tx=zeros(1,p);
       for j=1:p
           tx(j)=index(j).ss(x(i,j));
       end       
       endmember = X(:,tx);
       SAM = SAMpipei(reference,endmember);
       record_SAM = [record_SAM;SAM(1:3,:)];
   end   
num=1:1:L;
endmember1=X(:,tx);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)
% hold on;


% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)



 
% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
% 



% num=1:1:L;
% endmember1=X(:,population(1,:)==1);
plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-','linewidth',2)




