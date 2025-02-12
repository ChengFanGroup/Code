clear
clc
TIME1=clock;
%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时候使用
% reference = M; %reference of endmembers   端元的参考
% 
record_SAM20=[];


% load Urban_R1621.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %2-dimensional input image  输入的2维图像 ?为什么除以1000


load samson_1.mat
load end3.mat
reference = M;
reference(:,3)=reference(:,3).*0.1;
X = V;
% 
%  load CupriteS1_R188.mat
%  load CupriteS1_groundtreth.mat
%  reference = M;
%  X = Y./1000; %250.190

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

%********************************************************************************************************************************************************%
%parameter initialization
pop_num = 30;%number of particles
maxiter = 10;%maximum number of iterations
prob=0.2;%the probability of generating random velocity 
record_SAM = [];
GBA = [];  %GBA:Global Best Archive
f_GBA = [];
v_record = zeros(pop_num,maxiter);

%*******************************************************************************************************************************************************%
%dimension reduction
trans = dim_reduction(P,X,image_3d);
X_reduction = trans * X;

    T = cputime; %璁板綍CPU鏃堕棿
    iter = 0;
    iter_finish = 0; %鍒ゆ柇杩唬鏄惁瀹屾瘯鐨勬爣蹇?  
    
    %2.闅忔満鐢熸垚姣忎釜绮掑瓙鐨勫垵濮嬩綅缃?
    x = zeros(pop_num,N); %姣忎釜绮掑瓙鐨勫綋鍓嶄綅缃?
    for j=1:pop_num
        x(j,random_choose(N,P)) = 1;
    end
    pbest = x;
    f_x = zeros(pop_num,2); 
%     
%     load xxxx.mat
%     x=x;
%     pbest=x;
    
    for j = 1:pop_num           %calculate objective function value 璁＄畻褰撳墠浣嶇疆鍜屼釜浣撴渶濂戒綅缃殑閫傚簲鍊?
        f_x(j,1) = 1/volume(X_reduction(:,x(j,:)==1));
        f_x(j,2) = unmixed(X,X(:,x(j,:)==1),1);
    end
    f_pbest = f_x;
    [GBA,f_GBA] = non_dom(GBA,f_GBA,pbest,f_pbest);  
%     scatter(f_GBA(:,1),f_GBA(:,2));
   recordfit=zeros(2,41);         
   recordfit(1,1)=mean(f_x(:,1));
   recordfit(2,1)=mean(f_x(:,2));
    
    while iter < maxiter && iter_finish == 0
        iter = iter+1;
        
       gbest = FindGlobalBest(GBA,f_GBA,x,f_x);
        %5.update velocity and position
        
        for j=1:pop_num
            %5.1 update velocity
            if rand()<prob% generate random velocity
                zero_idx = find(x(j,:)==0);
                one_idx = find(x(j,:)==1);
                v_positive_idx = zero_idx(random_choose(length(zero_idx),1));%randomly generate positive velocity
                v_negative_idx = one_idx(random_choose(length(one_idx),1));%randomly generate negative velocity
            else
                vp = pbest(j,:) - x(j,:);%calculate the velocity pointed to the individual best
                vg = gbest(j,:) - x(j,:);%calculate the velocity pointed to the global best
                vs= vp+vg;
                positive_idx = find(vs>0);
                negative_idx = find(vs<0);
                if ~isempty(positive_idx)
                    v_positive_idx = positive_idx(random_choose(length(positive_idx),1));%choose one positive velocity randomly
                    v_negative_idx = negative_idx(random_choose(length(negative_idx),1));%choose one negative velocity randomly
                else %already at the best position, then randomly generate velocity
                    zero_idx = find(x(j,:)==0);
                    one_idx = find(x(j,:)==1);
                    v_positive_idx = zero_idx(random_choose(length(zero_idx),1));
                    v_negative_idx = one_idx(random_choose(length(one_idx),1));
                end
            end
            %5.2 update position 
            x(j,v_positive_idx)=1;
            x(j,v_negative_idx)=0;
%             particle_position_history{j} = [particle_position_history{j};x(j,:)];         
            
        end
        

        for j=1:pop_num
            f_x(j,1) = 1/volume(X_reduction(:,x(j,:)==1));
            f_x(j,2) = unmixed(X,X(:,x(j,:)==1),3);                                                                                                                                                                                                                                                                                                                                                                                                      
            v_record(j,iter) = f_x(j,1);
            rmse_record(j,iter) = f_x(j,2);
            
            n = ((f_x(j,1)<f_pbest(j,1)) + (f_x(j,2)<f_pbest(j,2)));
            if n==2
                pbest(j,:) = x(j,:);
                f_pbest(j,:) = f_x(j,:);
            end
            if n==1
                if rand() > 0.5
                    pbest(j,:) = x(j,:);
                    f_pbest(j,:) = f_x(j,:);
                end
            end
                              
        end
        [GBA,f_GBA] = non_dom(GBA,f_GBA,pbest,f_pbest);  
%         scatter(f_GBA(:,1),f_GBA(:,2));
%         drawnow;
        if mod(iter,5)==0        
             recordfit(1,iter/5+1)=mean(f_GBA(:,1));
             recordfit(2,iter/5+1)=mean(f_GBA(:,2));
        end
        
%         if max(f_pbest)-min(f_pbest)==0
%             iter_finish = 1;
%         end

        %yan zheng zi dai daunyan chongfu
       if iter==20
           for j = 1:30
               endmember = X(:,x(j,:)==1);
               SAM20 = SAMpipei(reference,endmember);
               [~,SAM20_idx]=sort(SAM20(1,1:P));
               SAM20=SAM20(:,SAM20_idx);
               record_SAM20 = [record_SAM20;SAM20(1:3,:)];
           end
           fprintf('%d th is ok \n',iter);
       end
                
        fprintf('%d th is ok \n',iter);

    end
    
%     subplot(2,4,1);
    scatter(f_GBA(:,1),f_GBA(:,2),'+','DisplayName','MODPSO'); % 绘图
    
   
xlabel('f1=1/V');
ylabel('f2=RMSE');
 legend('MODPSO')
    hold on;

    f_GBA
        TIME2=clock;

   time1=etime(TIME2,TIME1)
%     time1 = cputime - T;              %runtime
    recordfit1=recordfit;
    [n,~] = size(GBA); 
    
    for i = 1:n
        endmember = X(:,GBA(i,:)==1);
        SAM = SAMpipei(reference,endmember);
        [~,SAM_idx]=sort(SAM(1,1:P));
        SAM=SAM(:,SAM_idx);
        record_SAM = [record_SAM;SAM(1:3,:)];
    end


result = [];
[r, c] = size(GBA);
% result = zeros(r, c);
for i = 1:r
    row = GBA(i, :);  % 获取当前行
    indices = find(row == 1);     % 找到值为1的元素的列标
    result = [result; indices];  % 添加列标作为新矩阵的一行
end
% f=zeros(20,1);
% for i =1:20
% f(i)= unmixed(X,X(:, result(i,:)),3);
% end
    save MODPSO_data  result GBA f_GBA record_SAM time1 recordfit1 endmember
  
% num=1:1:L;
 %endmember1=X(:,GBA(1,:)==1);
% SAM1 = SAMpipei(reference,endmember1);
% [~,SAM1_idx]=sort(SAM1(1,1:P));
% SAM1=SAM1(:,SAM1_idx);
% subplot(2,4,2);
% plot(num,endmember1(:,SAM1(2,1)),'g.-','DisplayName','MODPSO')
% legend('MODPSO')
 % hold on;
 %subplot(2,4,3);
 %plot(num,endmember1(:,SAM1(2,2)),'g.-','DisplayName','MODPSO')
 %legend('MODPSO')
%  hold on;
% subplot(2,4,4);
% plot(num,endmember1(:,SAM1(2,3)),'g.-','DisplayName','MODPSO')
% legend('MODPSO')
%  hold on;
% subplot(2,4,5); 
% plot(num,endmember1(:,SAM1(2,4)),'g.-','DisplayName','MODPSO')
% legend('MODPSO')
%  hold on;
% subplot(2,4,6);
% plot(num,endmember1(:,SAM1(1,5)))

% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'m.-','linewidth',2)

% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-','linewidth',2)

% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-','linewidth',2)
 
 %num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
 %plot(num,endmember1(:,1),'r.-',num,endmember1(:,2),'b.-',num,endmember1(:,3),'k.-',num,endmember1(:,4),'g.-',num,endmember1(:,5),'m.-',num,endmember1(:,6),'y.-',num,endmember1(:,7),'m.-',num,endmember1(:,8),'m.-',num,endmember1(:,9),'m.-',num,endmember1(:,10),num,endmember1(:,11),'m.-',num,endmember1(:,12),'m.-','linewidth',2)
 








