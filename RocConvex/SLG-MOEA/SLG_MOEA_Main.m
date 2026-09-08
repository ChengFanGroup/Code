clear;
clc;
dbstop if error;

% SLG-MOEA 论文核心可运行版：Australian, N=100, 800代, 5折, 30次。
coreDir = fileparts(mfilename('fullpath'));
addpath(coreDir);
[datasetsource,whether,name] = load_australian( ...
    fullfile(coreDir,'dataset','australian.txt'));
Generations = 800;
repetitions = 30;
s = 1;

for datasetRun = 1:1

    [instanceNum,featureNum] = size(datasetsource);

   %--------------------------------------------------------
    output_root = fullfile(coreDir,'results');
    dirpath=fullfile(output_root,name);
     if exist(dirpath) == 0
            mkdir(dirpath);
        end
%-----------------------------------------------------------
    disp([name,'-start']);
  
    K = 5;
    N = 100;
    G = Generations;
    fprintf('Configured population size: %d\n',N);
    fprintf('Configured generations: %d\n',G);
    JiLuinterval = 1;
    poplength = featureNum;
    minvalue = ones(1,featureNum)*(-1);%%边界
    maxvalue = ones(1,featureNum);
    Boundary = [maxvalue;minvalue];
    %----------------------------------------
    CH = cell(repetitions*K,2);
    mtubaotrain = 0;
    mtubaotest = 0;


    Fauch = zeros(repetitions,1);
    Fauch_train = zeros(repetitions,1);
    HV_test = zeros(repetitions,1);
    HV_train = zeros(repetitions,1);
    Time = zeros(repetitions,1);
    chareatrain = zeros(Generations/JiLuinterval+1,1);
    chareatest = zeros(Generations/JiLuinterval+1,1);
    %---------------------------------------------
    for x = 1 : repetitions %遍数循环
        rng(20260708 + s*1000 + x, 'twister');
        tic;
        fprintf('第%d遍\n',x);
        Indices = crossvalind('Kfold', instanceNum, K); 
        rng(202607080 + s*1000 + x, 'twister');
        tubaotrain = 0;
        tubaotest = 0;
        hv_train = 0;
        hv_test = 0;
        %-------------------------------
        daishu= 8;
       %--------------------------------------
        Population2=[];
        paretotubao3=[];
        for crossnumber  =  1:K
           
            convexhulltrain = zeros(Generations/JiLuinterval+1,1);
            convexhulltest = zeros(Generations/JiLuinterval+1,1);
            Pop = [];
            Fvalue = [];
            datasettrain=datasetsource((Indices~=crossnumber),:);
            whethertrain=whether((Indices~=crossnumber));
            datasettest=datasetsource((Indices==crossnumber),:);
            whethertest=whether((Indices==crossnumber));

            if crossnumber==1
                minvalue1  =  repmat(ones(1,poplength),N,1)*(-1);       
                maxvalue1  =  repmat(ones(1,poplength),N,1);             
                population  =  rand(N,poplength).*(maxvalue1-minvalue1)+minvalue1;    
            end
            

            FunctionValue=  Cal_objV(population,datasettrain,whethertrain);%[fpr,tpr]
            Population=population;
        
            paretotrain111 = sortrows(FunctionValue);
            [~,paretotubaotrainck] = chraarea(paretotrain111);
            convexhulltrain(1) = calculatearea(paretotubaotrainck);
            FunctionValuetest = Cal_objV(Population,datasettest,whethertest);
            pareto111=sortrows(FunctionValuetest);
            [~,paretotubaotestck]=chraarea(pareto111);
            convexhulltest(1) = calculatearea(paretotubaotestck);

            for g = 1 : G
                Offspring = P_generator(Population,Boundary,'Real',N );
                FunctionValue_off = Cal_objV(Offspring,datasettrain,whethertrain);
                %合并子代父代-------------
                newpopulation = [Population;Offspring];
                results = [FunctionValue;FunctionValue_off];

                
                    if(mod(g,daishu)==1)%
                        [Value,~]=sortrows(results);
                        [~,paretotubao]=chraarea(Value);

                        [newcankao]=D_tubao(paretotubao);
                        [~,tubao1]=chraarea(newcankao);

                    end
                    %-------------------去除凸包多余点------------------10.28
                    [t1,~]=sortrows(tubao1,'descend');
            
                    if(mod(g,daishu)==0)
                        Pop=[Population2;Pop_r];
                        Fvalue=[paretotubao3;paretotubao1];
                        [~,paretotu]=chraarea(Fvalue);%画出凸包
                        paretotubao3 = testquchu10(paretotu);
                        N1=size(paretotubao3,1);
                        if N1>=N
                            % The retained hull already fills (or exceeds)
                            % the requested population. Do not request zero
                            % or a negative number of points from clos_2.
                            if N1>N
                                paretotubao3=clos_2(paretotubao3,N,[],t1);
                            end
                            number6=findsequence(paretotubao3,Fvalue);
                            Population2=Pop(number6,:);
                            FunctionValuetrain=paretotubao3;
                            Population=Population2;
                        else
                            number6=findsequence(paretotubao3,Fvalue);
                            Population2=Pop(number6,:);
                            FunctionValuetrain1=clos_2(results,N-N1,newpopulation,t1);
                            number1=findsequence(FunctionValuetrain1,results);
                            Population1=newpopulation(number1,:);
                            FunctionValuetrain=[FunctionValuetrain1;paretotubao3];
                            Population=[Population1;Population2];
                        end
                    else 
                        results12 = testquchu10(results);
                        results1=unique(results12,"rows","stable");
                        N2 = size(results1,1);
                        if(N2<N)
                            number3=findsequence(results1,results);
                            Population3=newpopulation(number3,:);
                            if(mod(N2,2)==0)
                                Population4 =Population3;
                                Offspring1 = P_generator(Population4,Boundary,'Real',N);
                                FunctionValue_off1 = Cal_objV(Offspring1,datasettrain,whethertrain);%[fpr,tpr]
                                results2 = [results1;FunctionValue_off1];

                            else
                                Population4=Population3(1:N2-1,:);
                                Offspring1 = P_generator(Population4,Boundary,'Real',N);
                                FunctionValue_off1 = Cal_objV(Offspring1,datasettrain,whethertrain);%[fpr,tpr]
                                results2 = [results1(1:N2-1,:);FunctionValue_off1];
                            end
                            NR = size(results2,1);
                            if(NR >= N)
                                newpop=[Population4;Offspring1];
                                FunctionValuetrain=clos_2(results2,N,newpop,t1);
                                number4=findsequence(FunctionValuetrain,results2);
                                Population=newpop(number4,:);
                            else
                                %-------------------------之前修复策略版本-------------
                                newpop=[Population4;Offspring1];
                                aaaa = setdiff(1:(2*N),number3);
                                aaa1 = randperm(size(aaaa,2));
                                n6 = N-NR;
                                number7 = aaa1(1:n6);
                                number8 = aaaa(number7);
                                results4 = results(number8,:);
                                Population5 = newpopulation(number8,:);
                                Population=[newpop;Population5];
                                FunctionValuetrain=[results2;results4];
                                %------------------------之前修复策略版本-------------
                            end
                        else
                            FunctionValuetrain=clos_2(results1,N,newpopulation,t1);
                            number5=findsequence(FunctionValuetrain,results);
                            Population=newpopulation(number5,:);
                        end
                    end

                    %---------------------------------------------------
                    [Value2,index]=sortrows(FunctionValuetrain);
                    [~,paretotubao1]=chraarea(Value2);
                    [paretotubao1] = testquchu10(paretotubao1);
                    %---------------------------------------------------
                    number2=findsequence(paretotubao1,FunctionValuetrain);
                    Pop_r=Population(number2,:);
                    FunctionValue=FunctionValuetrain;
                paretotrain=[1 1;paretotubao1;0 0];
                if(mod(g,JiLuinterval)==0)
                    [~,paretotubaotrainck]=chraarea(paretotrain);
                    convexhulltrain(g/JiLuinterval+1) = calculatearea(paretotubaotrainck);
                   
                    FunctionValuetest = Cal_objV(Population,datasettest,whethertest);
                    pareto=sortrows(FunctionValuetest);
                    [~,paretotubaotestck]=chraarea(pareto);%画出凸包
                    convexhulltest(g/JiLuinterval+1) = calculatearea(paretotubaotestck);

                end
            end
            %每折结果
            CH((x-1)*K + crossnumber,:) = {convexhulltest(end)*100,unique(paretotubaotestck,'rows')};
            tubaotrain=tubaotrain+convexhulltrain;
            tubaotest=tubaotest+convexhulltest;
            %保存HV
            paretotubaotrainck(:,2) = 1 - paretotubaotrainck(:,2);
            paretotubaotestck(:,2) = 1 - paretotubaotestck(:,2);
            hv_train = hv_train + HV_1(paretotubaotrainck);
            hv_test = hv_test + HV_1(paretotubaotestck);
        end%K循环结束

        chareatrain = chareatrain + tubaotrain/K;
        chareatest = chareatest + tubaotest/K;
        Fauch(x) = (tubaotest(end,:)/K)*100;
        Fauch_train(x) = (tubaotrain(end,:)/K)*100;
        HV_train(x) = hv_train/K;
        HV_test(x) = hv_test/K;
        time = toc;
        Time(x) = time/K;
        mtubaotrain = tubaotrain/K;
        mtubaotest = tubaotest/K;
        fprintf('%f\n', mtubaotest(end,:)*100);
    end
    
    chareatrain = chareatrain/repetitions;
    chareatest = chareatest/repetitions;
    performance = [mean(Fauch,'all'),std(Fauch,0,'all')];
    performance_train = [mean(Fauch_train,'all'),std(Fauch_train,0,'all')];
    Mean_HV_train = [mean(HV_train,'all'),std(HV_train,0,'all')];
    Mean_HV_test = [mean(HV_test,'all'),std(HV_test,0,'all')];
    performance_Time = [mean(Time,'all'),std(Time,0,'all')];

    fprintf('%.3f %.2f\n',performance(1),performance(2));
    fprintf('--------------\n');
    fprintf('%.3f %.3f\n',Mean_HV_test(1),Mean_HV_test(2));
    fprintf('--------------\n');
    fprintf('%.3f %.3f\n',performance_Time(1),performance_Time(2));

    %     if exist(dirpth) == 0
    %         mkdir(dirpth);
    %     end

    save(fullfile(dirpath,'CH.mat'),'CH');
    save(fullfile(dirpath,'Curve_auch_train.mat'),'chareatrain');
    save(fullfile(dirpath,'Curve_auch_test.mat'),'chareatest');
    save(fullfile(dirpath,'Fauch.mat'),'Fauch');
    save(fullfile(dirpath,'performance.mat'),'performance');
    save(fullfile(dirpath,'performance_Time.mat'),'performance_Time');
    save(fullfile(dirpath,'Fauch_train.mat'),'Fauch_train');
    save(fullfile(dirpath,'performance_train.mat'),'performance_train');
    save(fullfile(dirpath,'HV_train.mat'),'HV_train');
    save(fullfile(dirpath,'Mean_HV_train.mat'),'Mean_HV_train');
    save(fullfile(dirpath,'HV_test.mat'),'HV_test');
    save(fullfile(dirpath,'Mean_HV_test.mat'),'Mean_HV_test');
    %save([dirpath,'\','FunctionValuetrain.mat'],'FunctionValuetrain');
    %save([dirpath,'\','FunctionValuetest.mat'],'FunctionValuetest');
    %save([dirpath,'\','paretotubaotestck.mat'],'paretotubaotestck');
    %save([dirpath,'\','paretotubaotrainck.mat'],'paretotubaotrainck');
    save(fullfile(dirpath,'Time.mat'),'Time');

    disp([name,'-end']);


end
