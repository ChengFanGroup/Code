% Framework of the proposed MOEA-PUL
clc ;
clear all;

N=100;    %种群规模
pc=0.7;     %交叉概率
pm=0.2;     %变异概率
gen=100;        %迭代次数
poplength=50;   %种群长度
StartGene=50;

%% 导入数据集
filepath = '.\lastdata'; %数据集所在的文件夹
AllDataSet = dir(fullfile(filepath, '*.mat'));
for k=  3:3     %读每个数据集%10和11两个数据集有问题
    dataname =  AllDataSet(k).name; %提取每个数据集的name字段，数据集的名称
    % 数据转换
    K=5;        %指标数
    p=0.3;          %正标签的比例
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
    

%% 初始化Population initialization.

Population = Initialization(dataPositive,dataUN,N);    %初始种群

 [aim1,aim2] = Fitness(Population,dataUN,dataPositive);
 FunctionValue= [aim1,aim2];
FrontNo = ND_sort(FunctionValue,'half');
 Cdistance   = distance(FunctionValue,FrontNo);

%% 遗传算法的竞标算法和迭代部分
for g=1:gen
    

pool=round(N/2);    %交配池大小
toul=2;         %竞赛标选手

pop=selection(Population,FrontNo,Cdistance);           %竞赛标选择合适的父代
pop1=Variation(pop,Boundary,'Binary',N);   %nsga遗传算法迭代部分


if g >= StartGene 
     [aim1,aim2] = Fitness(pop1,dataUN,dataPositive);
    FunctionValue1= [aim1,aim2];
    [VirtualElite,VirtualEliteSet] = GeneratedEliteLabelSet(Population,FunctionValue,g,StartGene);%精英标签的建立
   Population=GenerateGuider(pop1,FunctionValue1,VirtualElite);             %带有精英标签对种群进行指导
    
     
else
  
    % P ← EnvironmentalSelection(P ∪ O,N);
     [Population,FunctionValue]=EnvironmentalSelection(Population,pop1,FunctionValue,dataUN,dataPositive);  
end
end
    NonDominated       =    ND_sort(FunctionValue,'first')==1;
    FunctionValuetrain =  FunctionValue(NonDominated,:);
    Populationtrain    =    Population(NonDominated,:);
    
       labeltest(labeltest == 0) = -1;
    Pareto_Acc = zeros(1,size(Populationtrain,1));
    
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
        
    end
    res(crossnumber).tpr=[];  %记录tpr和fpr
    res(crossnumber).tpr=Pareto;
    labeltest(labeltest == -1) = 0;
    [avgacc(crossnumber),best_index] = max(Pareto_Acc);
    best_individual  = Populationtrain(best_index,:); 
     mode(crossnumber).mdl=[];
    mode(crossnumber).mdl=model;
   
end
     for i=1:K
     tpr_cross=res(i).tpr;  
    temp(i)=mean(tpr_cross(:,1));
     end
     [~,index]=max(temp);
     rest=res(index(1)).tpr;  
     [tpr,index]=max(rest(1));
     fpr=rest(index,2);
     
   hold on
    figure; clf; axis([0 1 0 1]);
    pause(0.000000001);
    title('dataname')
    xlabel('FPR');
    ylabel('TPR');  
    result=plot(fpr,tpr,'Color','r','Marker','*'); set(result,'MarkerSize',10);    
  
    
    Acc = avgacc./100;
    Mean = full(mean(Acc));
    Std = std(full(Acc));
    fprintf('精度Accuracy:\n');
    fprintf('%.3f%%(%.4f%%)',full(mean(Acc)),std(full(Acc)));
end
