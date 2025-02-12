% sovlove PN 9classifier problems
%通过权重优化方法，找一下PU问题在最优情况下的上线
clear all;
clc;
p=0.3; %构造PU数据集参数
filepath = 'E:\PU学习(已发表)\A multi-objective evolutionary algorithm for robust positive-unlabeled learning\BPUSS-MOEA\lastdata1'; %数据集所在的文件夹
AllDataSet = dir(fullfile(filepath, '*.mat'));

for k= 1 : 10%length(AllDataSet) %读每个数据集
      tic
    for times=1:6
    dataname =  AllDataSet(k).name; %提取每个数据集的name字段，数据集的名称
    load(strcat(dataname)); 
    data = instance;
     NVar = size(data,2);
    crossover=5;
    Indices = crossvalind('Kfold',size(data,1), crossover);
    tempindex = randperm(size(data,1));
    [UserInput,GAParameters,ProblemParameters]=ParametersSet(NVar); %参数设置
    for i = 1 : crossover
         
         Train_Dataset=data(Indices~=i,:);
         Train_Label=label(Indices~=i,:);
         Test_Dataset=data(Indices==i,:);
         Test_Label=label(Indices==i,:);
         
         %噪音处理
         [Train_Dataset,Train_Label] = makeNosie(Train_Dataset,Train_Label);
         [dataPositive,labelPositive,dataUN,labelUN]=Data_Transform(Train_Dataset,Train_Label,p); 
         dataPositive=dataPositive';
         dataUN=dataUN';
         save Train dataPositive dataUN;
         save Test Test_Dataset Test_Label;
         save TrainTest Train_Dataset Train_Label;
          CostSensitiveKNN(dataUN); 

          [F1,NewF1]=NSGA2maskPU(UserInput,ProblemParameters,GAParameters,i);
          weight=[NewF1.Val]';
          [testprecision,testcom,model] = TestMaxAcc(weight,Test_Dataset,Test_Label);  %在测试集上选解
          CrossAcc(i)=testprecision;
          CrossCom(i)=testcom;
          Crossmodel(i,:)=model;
          
           %AUC
          [testauc] = TestMaxAuc(weight,Test_Dataset,Test_Label);   
          CrossAuc(i)=testauc;
          
          %F1
          [F1score,recall,precision]=getF1(weight,Test_Dataset,Test_Label);
          Crossf1(i)=F1score;
          Crossrecall(i)=recall;
          Crossprecision(i)=precision;
       
          %ACCINU
          [pacc,nacc,pnacc] = PandNinTrain(weight,dataUN,labelUN);
          CrossPacc(i)=pacc;
          CrossNacc(i)=nacc;
          CrossUacc(i)=pnacc;

    end
     %运行时间
    time=toc;
    ACC=mean(CrossAcc);
    Mis=std(CrossAcc);
    Com=mean(CrossCom);
    cutDataname=dataname(1:end-4);
    pathName='G:\2、研究生\PU学习\NRPU_MOEA\BPUSS-MOEA\result\';
    save([pathName,strcat(cutDataname,'time0.1',num2str(p),num2str(times),'.mat')],'ACC','Mis','Com','CrossAcc','CrossCom','time');
    pathName='G:\2、研究生\PU学习\NRPU_MOEA\BPUSS-MOEA\AFUresult\';
    save([pathName,strcat(cutDataname,'time0.1','AFU','0.3','.mat')],'CrossAuc','Crossf1','Crossrecall','Crossprecision','CrossPacc','CrossNacc','CrossUacc');
    pathName='G:\2、研究生\PU学习\NRPU_MOEA\BPUSS-MOEA\model\';
    save([pathName,strcat(cutDataname,'time0.1','model','0.3','.mat')],'Crossmodel');
    clear Crossmodel;
    end
end