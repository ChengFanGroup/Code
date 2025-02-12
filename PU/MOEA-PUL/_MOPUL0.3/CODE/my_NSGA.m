% MO-PUL use NSGA-II framework
% Created by Shenzhi Yuan
% Copyright (c) 2019-2020 BIMK Group.

clc;
clear all;
%------------------------Parameters Setting--------------------------------

filepath = '.\win4'; %数据集所在的文件夹
AllDataSet = dir(fullfile(filepath, '*.mat'));
for k= 1 : 5%length(AllDataSet) %读每个数据集%10和11两个数据集有问题
    dataname =  AllDataSet(k).name; %提取每个数据集的name字段，数据集的名称
%     DataSet=cell2mat(struct2cell(load(DataSetName))); %读取数据集并转为矩阵形式保存在DataSet中
%     load(strcat(DataSetName));

N = 100;
Generations= 100;
p = 0.1;
StartGene = 50;
%-----------------------DataTransform & 5-Fold-----------------------------
K=5;% the indices number of K-fold
    
load(strcat(dataname));

 NVar = size(instance,2);
 inst_norm = mapminmax(instance');%对属性进行归一化
 instance=inst_norm';
    
datasetsource =  instance';
label =  label';
label(find(label==-1))=0;% make the negative label be 0

Indices        =  crossvalind('Kfold', size(datasetsource,2), K);
datasetsource  =  datasetsource';
tic;

avgacc = zeros(K,1);
U='Uacc';
for crossnumber  =  1:K
    %---------Divide datasets into test sets and training sets--------------
    datasettrain  =  datasetsource(find(Indices~=crossnumber),:);% 5-fold
    datasettrain  =  datasettrain';
    labeltrain  =  label(find(Indices~=crossnumber));
    datasettest  =  datasetsource(find(Indices==crossnumber),:);
    datasettest  =  datasettest';
    labeltest  =  label(find(Indices==crossnumber));
    
    [dataPositive,labelPositive,dataUN,labelUN,A]=Data_Transform(datasettrain,labeltrain,p);
    
    % Population's length, namely, the size of Unlabeled data
    poplength  =  size(dataUN,2);
    
    % Boundary settings
    minvalue1  =  ones(1,poplength)*(-1);
    maxvalue1  =  ones(1,poplength);
    Boundary  =  [maxvalue1;minvalue1];
    minvalue  =  repmat(ones(1,poplength),poplength,1)*(-1);
    maxvalue  =  repmat(ones(1,poplength),poplength,1);
    
    
    %--------------------------Initialization------------------------------
    
    Population = Initialization(dataPositive,dataUN,N);
    %     Population  = randi([0 1],N,poplength); %Random initialization
    
    %--------------------The First time evaluation-------------------------
    [evaluation1,evaluation2] = Evaluation(Population,dataUN,dataPositive);
    [aim1,aim2] = Calc_Fitness(Population,evaluation1,evaluation2);
    FunctionValue = [aim1,aim2];
    FrontNo = F_NDSort(FunctionValue,'half');
    CrowdDistance   = F_distance(FunctionValue,FrontNo);
    
    
    %------------------------------Generate--------------------------------
    
    for Gene = 1: Generations
        Gene
       [VirtualElite,VirtualEliteSet] = GeneratedEliteLabelSet(Population,FunctionValue,Gene,StartGene);%精英标签的建立
        MatingPool  = F_mating(Population,FrontNo,CrowdDistance);
        % Generate offspring
        Offspring = NSGA_Generator(MatingPool,Boundary,'Binary',N);
        
        %----------------Elite strategy to guide the population-----------------
        if(Gene >= StartGene && sum(FrontNo == 1) > 2 && mod (Gene,10) == 0)
            [evaluation1,evaluation2] = Evaluation(Offspring,dataUN,dataPositive);
            [aim1,aim2] = Calc_Fitness(Offspring,evaluation1,evaluation2);
            FunctionValue1 = [aim1,aim2];
            Offspring = GenerateGuider(Offspring,FunctionValue1,VirtualElite);
        
        end
        %-------------------------- evaluation ---------------------------------
        [evaluation1,evaluation2] = Evaluation(Offspring,dataUN,dataPositive);
        [aim1,aim2] = Calc_Fitness(Offspring,evaluation1,evaluation2);
        FunctionValue2 = [aim1,aim2];
        
        Population = [Population;Offspring];
        FunctionValue = [FunctionValue;FunctionValue2];
        
        [FrontNo,MaxFront] = F_NDSort(FunctionValue,'half');
        CrowdDistance  = F_distance(FunctionValue,FrontNo);
        %-------------------------- selection ----------------------------------
        
        %    Add individual which FrontNo < MaxFront into next generation
        %    and calculate the number of them,NoN is this number.
        Next        = zeros(1,N);
        NoN         = numel(FrontNo,FrontNo<MaxFront);
        Next(1:NoN) = find(FrontNo<MaxFront);
        
        %    find individuals which has smallest N - NoN crowd distance in
        %    MaxFront add into next generation.
        Last          = find(FrontNo==MaxFront);
        [~,Rank]      = sort(CrowdDistance(Last),'descend');
        Next(NoN+1:N) = Last(Rank(1:N-NoN));
        
        %
        Population    = Population(Next,:);
        FrontNo    = FrontNo(Next);
        FunctionValue = FunctionValue(Next,:);
        CrowdDistance = CrowdDistance(Next);
        
    end
    NonDominated       =    F_NDSort(FunctionValue,'first')==1;
    FunctionValuetrain =  FunctionValue(NonDominated,:);
    Populationtrain    =    Population(NonDominated,:);
    
    
    % --------------Find the best solution in pareto front----------------
    % because the model is 1,-1 we let negative label transform to -1
    labeltest(labeltest == 0) = -1;
    Pareto_Acc = zeros(1,size(Populationtrain,1));
    %测试集测试阶段
    for i=1:size(Populationtrain,1)
        this_individual = Populationtrain(i,:);
        guessedP = dataUN(:,this_individual(1,:)==1);
        XPos=[dataPositive,guessedP];
        guessedN = dataUN(:,this_individual(1,:)==0);
        X = [XPos,guessedN];
        train_instance = sparse(X);
        Y = [ones(size(XPos,2),1);ones(size(guessedN,2),1)*(-1)];
        train_label = Y;
        dttest = sparse(datasettest);
        model(i) = train(train_label, train_instance');
        [~,acci,~] = predict(labeltest',dttest',model(i));
        Pareto_Acc(i) = acci(1);
        
        [tpr,fpr] = TprAndFpr(model(i),labeltest,dttest); %计算tpr和fpr
        Pareto(i,1)=tpr./100;
        Pareto(i,2)=fpr./100;
        
%         计算U中P和N的精度
%         [pacc,nacc,pnacc] = PandNinU(model(i),labelUN,dataUN);
        [pacc,nacc,pnacc] = PandNinTrain(model(i),labeltrain',datasettrain',A);
        Pareto_u(i,1)=pacc; %U中正类精度
        Pareto_u(i,2)=nacc; %U中负类精度
        Pareto_u(i,3)=pnacc;%U中的总体精度
        
%       计算测试集和U中的auc
        testauc = calc_auc_model(model(i),labeltest',dttest');
%         pnauc=calc_auc_model(model(i),labelUN,dataUN');
        Pareto_auc(i,1)=testauc;%测试集上的AUC
%         Pareto_auc(i,2)=pnauc;
    end
    res(crossnumber).tpr=[];  %记录tpr和fpr
    res(crossnumber).tpr=Pareto;
    
%     uacc(crossnumber).u=[]; %记录U中的精度
%     uacc(crossnumber).u=Pareto_u;
%      Pareto_u=[];
     
     auc(crossnumber).a=[];%记录测试集AUC值
     auc(crossnumber).a=Pareto_auc;%第一列测试集，
     Pareto_auc=[];  
   
    labeltest(labeltest == -1) = 0;
    [avgacc(crossnumber),best_index] = max(Pareto_Acc);
    best_individual  = Populationtrain(best_index,:); 


      %保存五折的训练模型
    mode(crossnumber).mdl=[];
    mode(crossnumber).mdl=model;
    clear model;
    
end
   %  save('F:\_MOPUL\Code\MO-PUL\model\uspsmodel','mode');
    % save(dataname,'uacc'); 
     %save(dataname,'uacc')
    %从五折中选择最优的一折tpr和fpr,保存结果
     for i=1:K
     tpr_cross=res(i).tpr;  
    temp(i)=mean(tpr_cross(:,1));
     clear tpr_cross
     end
     [~,index]=max(temp);
     rest=res(index(1)).tpr;  
   %  save('F:\代码\_MOPUL\Code\MO-PUL\huatu\emo_wdbc', 'rest');
    
    figure(4); clf; axis([0 1 0 1]);
    pause(0.000000001); hold on;
    xlabel('FPR');
    ylabel('TPR');  
     grid on;
    CG=plot(fpr,tpr,'Color','r','Marker','*'); set(CG,'MarkerSize',10); 
    % save tpr tpr_cross(index)
    %  save fpr fpr_cross(index)
    %保存精度的结果

    Acc = avgacc./100;
    Mean = full(mean(Acc));
    Std = std(full(Acc));
    fprintf('Accuracy:\n');
    fprintf('%.3f(%.4f)',full(mean(Acc)),std(full(Acc)));
    
    %runacc(run)=Mean;
    save(strcat(dataname,num2str(p),'MOEA','.mat'),'Acc','Mean','Std');

    %保存最优的AUC的结果
      for i=1:K
       auc_cross=auc(i).a;  
       temp(i)=max(auc_cross(:,1));
       clear auc_cross
    end
    MEANAUC=mean(temp);
    STDAUC=std(temp);
    %save(strcat(dataname,num2str(p),U,'.mat'),'temp','MEANAUC','STDAUC');
    pathName='.\result1\';
   % save([pathName,strcat(cutDataname,'ASPU','0.3','.mat')],'ACC','Mis','Com','CrossAcc','CrossCom');
    save([pathName,strcat(dataname,num2str(p),'.mat')],'Acc','Mean','Std');
    
end
    