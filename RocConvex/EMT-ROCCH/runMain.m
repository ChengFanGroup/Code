%--------- 2022.05.31 last update by im_shu----
clc;
clear;

%%
dbstop if error;

for s = 4   : 4
    %导入的data-每个样本占据矩阵一行
[datasetsource,whether,name] = Inputdata_1(s);%datasetnumber代表当前测试的数据集

dirpath = fullfile('hukai', 'main', name);
if exist(dirpath, 'dir') == 0
    mkdir(dirpath);
end
% delt = 0.5; %设置干净样本选取比例
% % 加载标签数据
% labels = whether;
%加噪声
% 确定要添加的噪声数量
% num_labels = numel(labels);
% num_noise = round(0.5 * num_labels);
% 
% % 生成噪声索引
% noise_indices = randperm(num_labels, num_noise);
% 
% % 去除重复的噪声索引
% noise_indices = unique(noise_indices);
% 
% % 创建噪声向量并添加噪声
% noise_vector = randn(numel(noise_indices), 1);
% noisy_labels = labels;
% noisy_labels(noise_indices) = noisy_labels(noise_indices) + noise_vector';
% 
% % 截断噪声到指定范围
% noisy_labels = round(max(min(noisy_labels, 1), 0));
% 
% % 显示噪声前后的结果
% labelset = noisy_labels;%取整四舍五入
% %--------------------以下采用层次聚类算法对样本进行聚类--------------------
% D = pdist(datasetsource);             % 计算距离矩阵
% Z = linkage(D, 'ward');   % 使用Ward方法进行层次聚类
% idx = cluster(Z, 'MaxClust', 2);  % 根据K个簇划分数据点 
% %计算标签正负比例
% 
% %------------------此时数据样本已被聚类为两个类---------------------------
% %将其重新划分为簇1 和簇2
% idx1 = idx == 1;
% num1 = sum(idx1);%计算簇1的样本数
% index1 = find(idx1 == 1);%寻找簇1的样本及标签索引
% datasetsource1 = datasetsource(index1,:);
% [~,~,~,D1] = kmeans(datasetsource1,1,"Distance","sqeuclidean") ;
% [D11,idx11] = sort(D1);%筛选出离簇1中心最近的样本，此样本训练分类器更容易分类
% needNum1 = round(num1*delt);
% trNoiselessData1 = datasetsource1(idx11(1:needNum1),:);
% trNoiselessLabel1 = labelset(:,idx11(1:needNum1));%可能带有噪声的标签
% num11 = sum(trNoiselessLabel1);%计算簇1的样本数
% trlabel1 = trNoiselessLabel1';
% if(num11 > (needNum1 - num11))%找到索引为大多数的样本及标签
%     index11 = find(trlabel1 == 1);
% else
%     index11 = find(trlabel1== 0);%0多
% end
% trNoiselessData11 = trNoiselessData1(index11,:);
% trNoiselessLabel11 = trNoiselessLabel1(:,index11);
% 
% idx2 = idx == 2;
% index2 = find(idx2 == 1);%寻找簇2的样本及标签索引
% num2 = sum(idx2);%计算簇2的样本数
% datasetsource2 = datasetsource(index2,:);
% [~,~,~,D2] = kmeans(datasetsource2,1,"Distance","sqeuclidean") ;
% [D22,idx22] = sort(D2);%筛选出离簇2中心最近的样本，此样本训练分类器更容易分类
% needNum2 = round(num2*delt);
% trNoiselessData2 = datasetsource(idx22(1:needNum1),:);
% trNoiselessLabel2 = labelset(:,idx22(1:needNum1));%可能带有噪声的标签
% num22 = sum(trNoiselessLabel2);%计算簇1的样本数
% trlabel2 = trNoiselessLabel2';
% if(num22 > (needNum2 - num22))%找到索引为大多数的样本及标签
%     index22 = find(trlabel2 == 0);
% else
%     index22 = find(trlabel2== 1);
% end
% trNoiselessData22 = trNoiselessData2(index22,:);
% trNoiselessLabel22 = trNoiselessLabel2(:,index22);
% %合并簇1和簇2即为原始'干净'样本
% trainData = [trNoiselessData11;trNoiselessData22];
% trainlabel = [trNoiselessLabel11,trNoiselessLabel22];
 %load('matlab.mat');

%whether = noisy_labels;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555555
    maxgen = 100;
    JLInterval = 20;
    dirpath=['NewD\rand\',name];
    disp([name,'-start']);
    %----------------------------------------------------------
    K = 5;%五折交叉
    repetition = 5  ;
    %--------初始化结果存储矩阵--------------------
    CH = cell(repetition*K,2);% save CH
    FAUCH_test = zeros(repetition,K+1);
    FAUCH_train = zeros(repetition,K+1);
    HV_train = zeros(repetition,1);
    HV_test = zeros(repetition,1);
    HV_train_Ass = zeros(repetition,1);
    HV_test_Ass = zeros(repetition,1);
    FAUCH_train_Ass = zeros(repetition,1);
    FAUCH_test_Ass = zeros(repetition,1);
    Curve_Auch_Train = 0;
    Curve_Auch_Test = 0;
    AssTaskSize = zeros(repetition,K+1);
    Time0 = zeros(repetition,K+1);
    Time1 = zeros(repetition,K+1);
    
for i = 1 : repetition%遍数
    
    fprintf('第%d遍\n',i);     
    Curve_auch_train = 0;
    Curve_auch_test = 0;
    AuchTrainAss = 0;
    AuchTestAss = 0;
    hv_train = 0;
    hv_test = 0;
    hv_train_Ass = 0;
    hv_test_Ass = 0;

    %每遍将数据集随机分成五个部分，分别给以标号1~5
    Indices = whether;
    Indices1 = crossvalind('Kfold', sum(whether==0), K);
    Indices2 = crossvalind('Kfold', sum(whether==1), K); 
    Indices(whether==0) = Indices1;
    Indices(whether==1) = Indices2;
    
     for crossnumber = 1 : K
        %fprintf('----第%d折\n',crossnumber);  
        %按折构造训练、测试数据
        datasettrain = datasetsource(Indices ~= crossnumber,:);
        whethertrain = whether(Indices ~= crossnumber);
        datasettest = datasetsource(Indices == crossnumber,:);
        whethertest = whether(Indices == crossnumber);

        %%%%%%%%%%%%%%%%%%%%%%----方法----%%%%%%%%%%%%%%%%%%
        [curve_auch_train,curve_auch_test,auchtrain_Ass,auchtest_Ass,hvtrain,hvtest,hvtrain_Ass,hvtest_Ass,CH_test,asstaskSize,time0] = ...
            ETL_NSGA2(maxgen,JLInterval,whethertrain,whethertest,datasettrain,datasettest);

        %------------记录每折的结果-------------------
        %----- ------------T_O-------------------
        CH( (i-1)*K + crossnumber,:) = {curve_auch_test(end)*100,CH_test};
        Curve_auch_train = Curve_auch_train + curve_auch_train;
        Curve_auch_test = Curve_auch_test + curve_auch_test;
        FAUCH_train(i,crossnumber) = curve_auch_train(end)*100;
        FAUCH_test(i,crossnumber) = curve_auch_test(end)*100;
        hv_train = hv_train + hvtrain;
        hv_test = hv_test + hvtest;
        %----- ------------T_A-------------------
        AuchTrainAss = AuchTrainAss + auchtrain_Ass;
        AuchTestAss = AuchTestAss + auchtest_Ass;
        hv_train_Ass = hv_train_Ass + hvtrain_Ass;
        hv_test_Ass = hv_test_Ass + hvtest_Ass;
        %--------------------------------------------
        AssTaskSize(i,crossnumber) = asstaskSize;
        Time0(i,crossnumber) = time0;
     end
        %------------记录每遍的结果-------------------
        %----- ------------T_O-------------------
        Curve_Auch_Train = Curve_Auch_Train + Curve_auch_train/K;
        Curve_Auch_Test = Curve_Auch_Test + Curve_auch_test/K;
        FAUCH_test(i,K+1) = mean(FAUCH_test(i,1:K),'all');
        FAUCH_train(i,K+1) = mean(FAUCH_train(i,1:K),'all');
        HV_train(i) = hv_train/K;
        HV_test(i) = hv_test/K;
        %----- ------------T_A-------------------
        FAUCH_train_Ass(i) = (AuchTrainAss/K)*100;
        FAUCH_test_Ass(i) = (AuchTestAss/K)*100;
        HV_train_Ass(i) = hv_train_Ass/K;
        HV_test_Ass(i) = hv_test_Ass/K;
        %---------------------------------------------
        AssTaskSize(i,K+1) =  mean(AssTaskSize(i,1:K),'all');
        Time0(i,K+1) = mean(Time0(i,1:K),'all');
        
end
        %---------------------计算平均结果-------------------------
        %-------------------------T_O----------------------------------
        AuchMeanCurve_Train = Curve_Auch_Train/repetition;
        AuchMeanCurve_Test = Curve_Auch_Test/repetition;
        performance = [mean(FAUCH_test(:,K+1),'all'),std(FAUCH_test(:,K+1),0,'all')];
        performance_train = [mean(FAUCH_train(:,K+1),'all'),std(FAUCH_train(:,K+1),0,'all')];
        Mean_HV_train = [mean(HV_train,'all'),std(HV_train,0,'all')];
        Mean_HV_test = [mean(HV_test,'all'),std(HV_test,0,'all')];
        %-------------------------T_A----------------------------------
        performance_train_Ass = [mean(FAUCH_train_Ass,'all'),std(FAUCH_train_Ass,0,'all')];
        performance_test_Ass = [mean(FAUCH_test_Ass,'all'),std(FAUCH_test_Ass,0,'all')];
        Mean_HV_trainAss = [mean(HV_train_Ass,'all'),std(HV_train_Ass,0,'all')];
        Mean_HV_testAss = [mean(HV_test_Ass,'all'),std(HV_test_Ass,0,'all')];
        %-----------------------------------------------------------------------------------
        MeanAssTaskSize = [mean(AssTaskSize(:,K+1),'all'),std(AssTaskSize(:,K+1),0,'all')];
        MeanTime0 = [mean(Time0(:,K+1),'all'),std(Time0(:,K+1),0,'all')];
        %-----------------------------------------------------------------------------------
        fprintf('%.3f %.3f\n',performance(1),performance(2));
        fprintf('--------------\n');
        fprintf('%.3f %.3f\n',Mean_HV_test(1),Mean_HV_test(2));
        fprintf('--------------\n');
        fprintf('%.3f %.3f\n',MeanTime0(1),MeanTime0(2));
        
         if exist(dirpath) == 0
            mkdir(dirpath);
         end
        %-----------保存结果-----------------
        save([dirpath,'\','CH_allfold_test.mat'],'CH');
        save([dirpath,'\','AuchMeanCurve_Train.mat'],'AuchMeanCurve_Train');
        save([dirpath,'\','AuchMeanCurve_Test.mat'],'AuchMeanCurve_Test');
        save([dirpath,'\','FAUCH_test.mat'],'FAUCH_test');
        save([dirpath,'\','performance.mat'],'performance');
        save([dirpath,'\','FAUCH_train.mat'],'FAUCH_train');
        save([dirpath,'\','performance_train.mat'],'performance_train');
        save([dirpath,'\','HV_train.mat'],'HV_train');
        save([dirpath,'\','Mean_HV_train.mat'],'Mean_HV_train');
        save([dirpath,'\','HV_test.mat'],'HV_test');
        save([dirpath,'\','Mean_HV_test.mat'],'Mean_HV_test');
        %-----------------------------------------------------------------------------------
        save([dirpath,'\','FAUCH_train_Ass.mat'],'FAUCH_train_Ass');
        save([dirpath,'\','performance_train_Ass.mat'],'performance_train_Ass');
        save([dirpath,'\','FAUCH_test_Ass.mat'],'FAUCH_test_Ass');
        save([dirpath,'\','performance_test_Ass.mat'],'performance_test_Ass');
        save([dirpath,'\','HV_train_Ass.mat'],'HV_train_Ass');
        save([dirpath,'\','Mean_HV_trainAss.mat'],'Mean_HV_trainAss');
        save([dirpath,'\','HV_test_Ass.mat'],'HV_test_Ass');
        save([dirpath,'\','Mean_HV_testAss.mat'],'Mean_HV_testAss');
        %-----------------------------------------------------------------------------------
        save([dirpath,'\','AssTaskSize.mat'],'AssTaskSize');
        save([dirpath,'\','MeanAssTaskSize.mat'],'MeanAssTaskSize');
        save([dirpath,'\','Time0.mat'],'Time0');
        save([dirpath,'\','MeanTime0.mat'],'MeanTime0');
        %-----------------------------------------------------------------------------------
        disp([name,'-end']);
end
