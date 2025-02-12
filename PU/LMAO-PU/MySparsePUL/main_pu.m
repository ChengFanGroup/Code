clc;
clear all;
addpath(genpath(pwd));

addpath(genpath(pwd));
p=0.3; %构造PU数据集参数
filepath = '.\win5'; %数据集所在的文件夹
AllDataSet = dir(fullfile(filepath, '*.mat'));
for k= 3: 3 %读每个数据集
    ACC10 = [];
    Mean10 = [];
    Std10 = [];
    for ll = 1:2
        dataname =  AllDataSet(k).name; %提取每个数据集的name字段，数据集的名称
        load(strcat(dataname));
        data = instance;
        %对数据进行归一化
        NVar = size(data,2);
        %     inst_norm = mapminmax(data');%对属性进行归一化
        %     data=inst_norm';

        %   k 折交叉验证
        crossover=5;
        Indices = crossvalind('Kfold',size(data,1), crossover);

        tempindex = randperm(size(data,1));
        [UserInput,GAParameters,ProblemParameters]=ParametersSet(NVar); %参数设置
        for i = 1 : crossover

            Train_Dataset=data(Indices~=i,:);
            Train_Label=label(Indices~=i,:);
            Test_Dataset=data(Indices==i,:);
            Test_Label=label(Indices==i,:);


            [dataPositive,labelPositive,dataUN,labelUN]=Data_Transform(Train_Dataset,Train_Label,p);
            dataPositive=dataPositive';
            dataUN=dataUN';
            save Train dataPositive dataUN;
            save Test Test_Dataset Test_Label;
            save TrainTest Train_Dataset Train_Label;
            CostSensitiveKNN(dataUN);

            [F1,NewF1]=NSGA2maskPU(UserInput,ProblemParameters,GAParameters,i, ll);
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
        Mean=mean(CrossAcc);
        %     Mis=std(CrossAcc);

        ACC10 = [ACC10 CrossAcc];

        Mean10 = [Mean10 Mean];
        %     Std10 = [Std10 Mis];

        Com=mean(CrossCom);


        %     pathName='.\new\AFUresult\';
        %     save([pathName,strcat(cutDataname,'ASPU','AFU',num2str(p),'.mat')],'CrossAuc','Crossf1','Crossrecall','Crossprecision','CrossPacc','CrossNacc','CrossUacc');
        %     pathName='C:\Users\19585\Desktop\MySparsePUL\new\model\';

        %     save([pathName,strcat(cutDataname,'ASPU','model','0.2','.mat')],'Crossmodel');
        clear Crossmodel;
    end

    Mean = mean(Mean10);

    Std = std(ACC10);

    cutDataname=dataname(1:end-4);
    pathName='.\result\';
    save([pathName,strcat(cutDataname,'ASPU',num2str(p),num2str(ll),'.mat')],'Mean','ACC10','Std','CrossAcc','CrossCom');

    %      cutDataname=dataname(1:end-4);
    %     pathName='.\result\';
    %     save([pathName,strcat(cutDataname,'ASPU',num2str(p),'.mat')],'ACC','Mis','Com','CrossAcc','CrossCom');

end