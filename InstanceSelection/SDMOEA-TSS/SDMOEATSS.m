%%本代码MPIS的代码，但最终的测试结果只在总的帕累托面上展示
% clear
% addpath(genpath('E:\Program Files\MATLAB\R2014a\bin\SDMOEA-TSS\libsvm-3.22\matlab'));
Generations=100;%%种群迭代次数
N     =  100;
s1=0.1;%%变异概率生成初始种群
s2=0.3;
s3=0.5;
p1=0.1;

d=input("数据集：");
R=input("执行次数：");
% MY=zeros(6,24);
% chongfu1=zeros(R,24);
% chongfu2=zeros(R,24);
% chongfu3=zeros(R,24);
% chongfu4=zeros(R,24);
% chongfu5=zeros(R,24);
% chongfu6=zeros(1,24);
result1 = zeros(R, 5);
result2 = zeros(R, 6);


    for cc=1:R
        fprintf("第%d次:", cc);
        k=5;
%         data1=datasetImport1(d);
        data1 = datasetImport1(d);
        [y1,PS] = mapminmax(data1(:,1:(end-1))');
        data=[y1',data1(:,end)];
        [m, n]=size(data);
        indices = crossvalind('Kfold',m,k);
        PBE=zeros(k,3);
        TR = zeros(99*k,2);
        TE = zeros(1,99*k);
        PF = zeros(1,99*k);
        GM = zeros(1,99*k);
        TIME = zeros(1,k);
        MAX_TE=zeros(1,k);
        MAX_TR = zeros(k,2);
        MAX_GM = zeros(k,1);
        MAX_HV = zeros(k,1);
        avg_TE=zeros(1,k);
        avg_TR = zeros(k,2);
        avg_GM = zeros(k,1);
        test_HV = zeros(k,1);
        Test_Red = zeros(1, k);
        avg_hard = zeros(1, k);
        ACI = zeros(1,k);
        
        for l=1:k
            fprintf("%d ", l);
            
            tic;
            TT=zeros(1,21);
            test=(indices==l);
            train1=~test; %取test的补集作为训练集，即剩下的9个fold
            data_train1=data(train1,:); %以上得到的数都为逻辑值，用与样本集的选取
            data_test=data(test,:);%同理选取测试集的样本和标签
            %     data_train1 = dataset_tr;
            %     data_test = dataset_te;
            [v] = size(data_train1,1)-1;
            %    population1=randsrc(N,v,[0,1]);
            class = unique(data_train1(:,end));
            class_num = length(unique(data_train1(:,end)));
            pop1=zeros(33,v);
            pop2=zeros(33,v);
            pop3=zeros(34,v);
            P1=mutation(pop1,s1);
            P2=mutation(pop2,s2);
            P3=mutation(pop3,s3);
            population1=[P1;P2;P3];
            minvalue1  =  zeros(1,v);     %%边界
            maxvalue1  =  ones(1,v);
            Boundary  =  [maxvalue1;minvalue1];   %%上下边界
            aim2=zeros(N,2);%外部种群%%%%%%%%%%%%%%%%%%%
            for j=1:N
                %GET AIM1
                Cpop = population1(j,:);
                if sum(Cpop)==0
                    Cpop=mutation(Cpop,p1);
                end
                Cpop = logical(Cpop);
                CdataSet = data_train1(Cpop,:);%选出当前种群中选取的实例，即Cpop==1
                Clabel = CdataSet(:,n);
                CdataSet = sparse(CdataSet(:,1:n-1));
                model1(j,1)= svmtrain(Clabel,CdataSet,'-q');
                [~, acc, ~]  = svmpredict(data_train1(:,n),sparse(data_train1(:,1:n-1)), model1(j,1),'-q');
                aim2(j,1)=1-acc(1,1)/100;
                aim2(j,2)=1-sum(Cpop==0)/v;
            end
            a1= sum(aim2(1:33,:),1)./33;
            a2=sum(aim2(34:66,:),1)./33;
            a3=sum(aim2(67:100,:),1)./34;
            quan1=1-(a1+a2)./2;
            quan2=1-(a2+a3)./2;
            quan3=atan(quan1(2)/quan1(1))*180/pi;
            quan4=atan(quan2(2)/quan2(1))*180/pi;
            for j=1:N
                jiaodu=(1-aim2(j,2))/(1-aim2(j,1));
                if atan(jiaodu)*180/pi>atan(quan1(2)/quan1(1))*180/pi
                    aim2(j,3)=1;
                elseif atan(jiaodu)*180/pi>atan(quan2(2)/quan2(1))*180/pi&&atan(jiaodu)*180/pi<=atan(quan1(2)/quan1(1))*180/pi
                    aim2(j,3)=2;
                else
                    aim2(j,3)=3;
                end
            end
            TT(1,1)=NHV(aim2(:,1:2),[1,1]);
            %%%%%初始解筛选的过程
            [pop,aim,model_model,pop_Nonindex]=chushijiejianhua3(aim2,model1,population1,N);
            Coding='Binary';
            aimshoulian1=zeros(N,2);
            aimshoulian2=zeros(N,2);
            aimshoulian3=zeros(N,2);
            shoulian = zeros(100, 100, 2);
            for i1  =  1:Generations  %%循环迭代
%                 if mod(i1,20)==0
%                     fprintf("%d ",i1);
%                 end
                Q=cell(1,3);
                for i2=1:3
                    FrontValue                   = F_NDSort(aim{1,i2},'half');
                    CrowdDistance                = F_distance(aim{1,i2},FrontValue);
                    MatingPool  = F_mating(pop{1,i2},FrontValue,CrowdDistance);%%产生交配池
                    Q{1,i2} = P_generatorbianyiquanxin3(MatingPool,Boundary,Coding,N/4,i2,pop,pop_Nonindex);%%产生的子代
                end
                %%%%%%%%%%%%%%%种群合成
                Q=[Q{1,1};Q{1,2};Q{1,3}];%%3个产生的子代矩阵合并，依次占33行
                QFun2=zeros(N,3);% QFun2:精度、压缩率、对应子种群
                index = zeros(1,N-1);
                for i=1:N-1
                    Cpop1=Q(i,:);
                    if sum(Cpop1)==0
                    end
                    while(1)
                        if sum(Cpop1)==0
                            Cpop1=mutation(Cpop1,p1);
                        end
                        if sum(Cpop1)~=0
                            break
                        end
                    end
                    Q(i,:)=Cpop1;
                    Cpop1=logical(Cpop1);
                    Cdataset1=data_train1(Cpop1,:);
                    Clabel1=Cdataset1(:,n);
                    Cdataset1 = sparse(Cdataset1(:,1:n-1));
                    model(i,1) = svmtrain(Clabel1,Cdataset1,'-q');
                    [~,acc1 , ~]  = svmpredict(data_train1(:,n),sparse(data_train1(:,1:n-1)) , model(i,1),'-q');
                    if model(i,1).nr_class < class_num
                        index(i) = 1;
                    end
                    QFun2(i,1)=1-acc1(1,1)/100;
                    QFun2(i,2)=1-sum(Cpop1==0)/v;
                    jiaodu=(1-QFun2(i,2))/(1-QFun2(i,1));
                    if atan(jiaodu)*180/pi>quan3-0.6
                        QFun2(i,3)=1;
                    elseif atan(jiaodu)*180/pi>quan4+0.3&&atan(jiaodu)*180/pi<=quan3-0.6
                        QFun2(i,3)=2;
                    else
                        QFun2(i,3)=3;
                    end
                end
                index = logical(index);
                clf;
                %%%选出每个区域对应的非支配解和model和种群
                [aim,model_model,pop,pop_Nonindex]=BL3(aim,QFun2,Q,model,model_model,pop,N,pop_Nonindex);
                aimtu=aim;
                aimtu=[aimtu{1,1};aimtu{1,2};aimtu{1,3}];
                
%               (1-aimtu(~index,1),1-aimtu(~index,2),'o');
%                 hold on;
%                 plot(1-aimtu(index,1),1-aimtu(index,2),'*');
%                 axis([0 1 0 1]);
%                 drawnow
                % %        plot(x,y1,x,y2,x,y3,1-aimtu(:,1),1-aimtu(:,2),'or')
                shoulian(i1, 1:99, :) = 1 - aimtu;
            end
            Population=[pop{1,1};pop{1,2};pop{1,3}];
            aim1=aim{1,1};
            model1=model_model{1,1};
            modelY=model_model{1,3};
            aim3=aim{1,3};
            aim=[aim{1,1};aim{1,2};aim{1,3}];
            NonDominated     =   P_sort (aim,'first')==1;                   %%%寻找非支配解
            aimNon = aim(NonDominated,:);
            Last = 1-aim;
            Test = zeros(1,99);
            models = [model_model{1,1};model_model{1,2};model_model{1,3}];
            GM_values = zeros(1,99);
            hard = zeros(1, 99);
            for i = 1:99
                [predict_label,acc , ~]  = svmpredict(data_test(:,n),sparse(data_test(:,1:n-1)) , models(i),'-q');
                Test(i) = acc(1)/100;
                [GM_values(i), class_acc] = calGM(class,data_test(:,n),predict_label);
                hard(i) = sum(class_acc > 0) / length(class_acc);
            end
            time = toc;

            %model4=[model_model{1,1};model_model{1,2};model_model{1,3}];
            %%1区域选和最小的解
            %        if d==1
            %            save('E:\Program Files\MATLAB\R2014a\bin\IS 2019\gaiwei1.mat','aimNon');
            %        end
            %        if d==2
            %            save('E:\Program Files\MATLAB\R2014a\bin\IS 2019\gaiwei2.mat','aimNon');
            %        end
            as1=    sum(aim1,2);
            index1=find(as1(:,1)==min(as1));
            aa=index1(1,1);
            %%3区域选和最小的解
            as3=    sum(aim3,2);
            index3=find(as3(:,1)==min(as3));
            bb=index3(1,1);

            [~,acc4 , ~]  = svmpredict(data_test(:,n),sparse(data_test(:,1:n-1)) , model1(aa(1,1),1),'-q');%测试集区域A
            [~,acc5 , ~]  = svmpredict(data_test(:,n),sparse(data_test(:,1:n-1)) , modelY(bb(1,1),1),'-q');%测试集区域B
            PBE(l,1)=NHV(aim,[1,1]);
            PBE(l,2)=acc4(1,1)/100;
            PBE(l,3)=1-aim1(aa(1,1),2);
            PBE(l,4)=acc5(1,1)/100;
            PBE(l,5)=1-aim3(bb(1,1),2);
            TR(1+99*(l-1):99+99*(l-1),:) = Last;
            TE(1+99*(l-1):99+99*(l-1)) = Test;
            PF(1+99*(l-1):99+99*(l-1)) = NonDominated;
            TIME(l) = time;
            [max_test,max_test_index] = max(Last(:,1));
            MAX_TR(l,:) = Last(max_test_index,:);
            MAX_TE(l) = Test(max_test_index);
            GM(1+99*(l-1):99+99*(l-1)) = GM_values;
            MAX_GM(l) = GM_values(max_test_index);
            MAX_HV(l) = PBE(l,1);

            index = NonDominated == 1;
            PF_size = sum(index);
            avg_TE(l)=sum(Test(index))/PF_size;
            avg_TR(l,:) = sum(Last(index,:))/PF_size;
            avg_GM(l) = sum(GM_values(index))/PF_size;
%             temp = GM_values > 0;
            Test1 = 1-Test';
            test_HV(l) = NHV([Test1(index),aim(index,2)], [1,1]);
            Test_Red(l) = max(Test(index)' .* Last(index, 2));
            avg_hard(l) = sum(hard(index))/PF_size;
%             mkdir(['..\PF\SDMOEA-TSS\' num2str(d)]);
            GM_values = GM_values;
            ACI(l) = avg_TE(l) * Test_Red(l);
%             save(['..\PF\SDMOEA-TSS\' num2str(d) '\' num2str(l) '.mat'], "Test", "Last", "GM_values");
% mkdir(['..\shoulian\SDMOEA-TSS\' num2str(d)]);
%    save(['..\shoulian\SDMOEA-TSS\' num2str(d) '\' num2str(l) '.mat'], "shoulian");
        end
%         A = TR(PF==1,:);
%         B = TE(PF==1);
%         A = unique(A,"rows");
%         [A,index] = unique(A,"rows");
%         B = B(index);
%         f = size(B,2);
%         fprintf("平均时间：%f\n",sum(TIME)/k);
%         disp("选择前沿面");
%         disp("训练集：")
%         disp(sum(A)/f);
%         fprintf("测试集：%f\n",sum(B)/f);
%         disp("==================================");
%         disp("选择精度最高值");
%         disp("训练集：")
%         disp(sum(MAX_TR)/l);
%         fprintf("测试集：%f\n",sum(MAX_TE)/l);
%         fprintf("GM avg:%f\n",sum(GM(index))/f);
%         temp = 0;
%         for i = 1:k
%             temp = temp + max(TE((i-1)*99+1:i*99)'.*TR((i-1)*99+1:i*99,2));
%         end
%         fprintf("TeAcc*Red MAX: %f\n",temp/k);
%         A = TR(PF == 1, :);
%         B = TE(PF == 1);
%         [A, index] = unique(A, "rows");
%         B = B(index);
%         f = size(B, 2);
%         fprintf("平均时间：%f\n", sum(TIME)/k);
%         disp("选择前沿面");
%         disp("训练集：")
%         disp(sum(A)/f);
%         fprintf("测试集：%f\n", sum(B)/f);%
%% 结果存储
        result1(cc,1) = sum(MAX_GM)/k;
        result1(cc,2) = sum(MAX_TE)/k;
        result1(cc,3) = sum(MAX_TR(:,2))/k;
        result1(cc,4) = sum(MAX_HV)/k;
        result1(cc,5) = sum(Test_Red)/k;
        result1(cc,5) = sum(ACI)/k;
        
        result2(cc,1) = sum(avg_GM)/k;
        result2(cc,2) = sum(avg_TE)/k;
        result2(cc,3) = sum(avg_TR(:,2))/k;
        result2(cc,4) = sum(test_HV)/k;
        result2(cc,5) = sum(TIME)/k;
        result2(cc, 6) = sum(avg_hard)/k;

            standard_error(cc,1) = std(avg_TE);
            standard_error(cc,3) = std(Test_Red);
            standard_error(cc,2) = std(test_HV);

        fprintf("\n");
        datasetName = ['Dataset' num2str(d)]; 
        saveFileName = [ 'SDMOEATSS_' datasetName '.mat'];
        save(saveFileName);
    end