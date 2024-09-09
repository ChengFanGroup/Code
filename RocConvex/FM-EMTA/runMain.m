
clc;
clear;

%%
dbstop if error;
for s = 10 : 10
    %�����data-ÿ������ռ�ݾ���һ��
    [datasetsource,whether,name,Rep] = Inputdata(s);%datasetnumber����ǰ���Ե����ݼ�
    dirpath=['jg_test\',name];%������ļ���·��
    disp([name,'-start']);
    %-------------------------------------------------
    K = 5;%���۽���
    repetition = Rep;
    %--------��ʼ������洢����--------------------
    CH = cell(repetition*K,2);% save CH
    FAUCH_test = zeros(repetition,K+1);
    FAUCH_train = zeros(repetition,K+1);
    HV_train = zeros(repetition,1);
    HV_test = zeros(repetition,1);
    Curve_Auch_Train = 0;
    Curve_Auch_Test = 0;
    Time = zeros(repetition,K+1);
  
for i = 1 : repetition%����
    
   % fprintf('��%d��\n',i);     
    Curve_auch_train = 0;
    Curve_auch_test = 0;
    AuchTrainAss = 0;
    AuchTestAss = 0;
    hv_train = 0;
    hv_test = 0;
    hv_train_Ass = 0;
    hv_test_Ass = 0;

    %ÿ�齫���ݼ�����ֳ�������֣��ֱ���Ա��1~5
    Indices = whether;
    Indices1 = crossvalind('Kfold', sum(whether==0), K);
    Indices2 = crossvalind('Kfold', sum(whether==1), K); 
    Indices(whether==0) = Indices1;
    Indices(whether==1) = Indices2;
    
     for crossnumber = 1 : K

        %���۹���ѵ������������
        datasettrain = datasetsource(Indices ~= crossnumber,:);
        whethertrain = whether(Indices ~= crossnumber);
        datasettest = datasetsource(Indices == crossnumber,:);
        whethertest = whether(Indices == crossnumber);
        %%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%
        [curve_auch_train,curve_auch_test,hvtrain,hvtest,t,CH_test] = FM_EMTA(datasettrain,whethertrain,datasettest,whethertest);
        
        %------------��¼ÿ�۵Ľ��-------------------
        %----- ------------T_O-------------------
        Curve_auch_train = Curve_auch_train + curve_auch_train;
        Curve_auch_test = Curve_auch_test + curve_auch_test;
        FAUCH_train(i,crossnumber) = curve_auch_train(end)*100;
        FAUCH_test(i,crossnumber) = curve_auch_test(end)*100;
        hv_train = hv_train + hvtrain;
        hv_test = hv_test + hvtest;
        
        CH( (i-1)*K + crossnumber,:) = {curve_auch_test(end)*100,CH_test};
        %----------------����---------------------
        Time(i,crossnumber) = t;
     end
        %------------��¼ÿ��Ľ��-------------------
        %----- ------------T_O-------------------
        Curve_Auch_Train = Curve_Auch_Train + Curve_auch_train/K;
        Curve_Auch_Test = Curve_Auch_Test + Curve_auch_test/K;
        FAUCH_test(i,K+1) = mean(FAUCH_test(i,1:K),'all');
        FAUCH_train(i,K+1) = mean(FAUCH_train(i,1:K),'all');
        HV_train(i) = hv_train/K;
        HV_test(i) = hv_test/K;
        Time(i,K+1) = mean(Time(i,1:K),'all');
end
        %---------------------����ƽ�����-------------------------
        %-------------------------T_O----------------------------------
        AuchMeanCurve_Train = Curve_Auch_Train/repetition;
        AuchMeanCurve_Test = Curve_Auch_Test/repetition;
        performance = [mean(FAUCH_test(:,K+1),'all'),std(FAUCH_test(:,K+1),0,'all')];
        performance_train = [mean(FAUCH_train(:,K+1),'all'),std(FAUCH_train(:,K+1),0,'all')];
        Mean_HV_train = [mean(HV_train,'all'),std(HV_train,0,'all')];
        Mean_HV_test = [mean(HV_test,'all'),std(HV_test,0,'all')];
        %-----------------------------------------------------------------------------------
        MeanTime = [mean(Time(:,K+1),'all'),std(Time(:,K+1),0,'all')];
        %--------------------------��ӡ-------------------------------------------------
         fprintf('%.3f %.3f\n',performance(1),performance(2));
          fprintf('--------------\n');
          fprintf('%.3f %.3f\n',Mean_HV_test(1),Mean_HV_test(2));

        
        
        if exist(dirpath) == 0
            mkdir(dirpath);
        end
        %-----------������-----------------
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
        save([dirpath,'\','Time.mat'],'Time');
        save([dirpath,'\','MeanTime.mat'],'MeanTime');
        %-----------------------------------------------------------------------------------
        disp([name,'-end']);
end
