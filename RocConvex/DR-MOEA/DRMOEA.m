clc;
clear;
%%
dbstop if error;

for s = 1 : 12 %数据集
    
            format short; 
            [datasetsource,whether,name,rep]  =  Inputdata1(s);
            filename = ['jg_time\',name];
            disp([name,'-start']);
            %--------------------------------
            repetition = rep;
            JiLuinterval = 20;
            Generations = 1600;
            K = 5;
            N = 100;%种群大小
            Narchive = N-2;%外部文档2的种群大小
            
            %-----------------------------------------
            CH = cell(repetition*K,2);
            Fauch = zeros(repetition,1);
            Fauch_train = zeros(repetition,1);
            HV_train = zeros(repetition,1);
            HV_test = zeros(repetition,1);
            warning('off');
            CHarea_train = zeros(Generations/JiLuinterval+1,1);
            CHarea_test = zeros(Generations/JiLuinterval+1,1);
            [datanum,poplength]  =  size(datasetsource);%对应于种群的维度，即列数
            minvalue1  =  ones(1,poplength)*(-1);%%边界
            maxvalue1  =  ones(1,poplength);
            Boundary  =  [maxvalue1;minvalue1];
            Time = zeros(repetition,1);
            
for x = 1 : repetition %跑多少遍
    
        tic;
        Indices = whether;
        Indices1 = crossvalind('Kfold', sum(whether==0), K);
        Indices2 = crossvalind('Kfold', sum(whether==1), K); 
        Indices(whether==0) = Indices1;
        Indices(whether==1) = Indices2;
       
       fprintf('第%d遍\n',x); 
       
       %迭代次数
       fanwei = 1;
       archive =[];
       archive0=[];
       archive1=[];
       archive2=[];
       archive3=[];
       archive4=[];
       Populationtrain1=[];
       Populationbaoliu11=[];
       Populationbaoliu12=[];
       cankaotrain=0;
       cankaotest=0;
       hv_train = 0;
       hv_test = 0;
    
     %%%分训练和测试
   for crossnumber  = 1 : K%交叉验证

      Y=0.1;      
      PointsY1=[0;0;0;0;0;0;0;0;0;0;0];
      PointsY2=[1;0.9;0.8;0.7;0.6;0.5;0.4;0.3;0.2;0.1;0];
      PointsX1=[0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1];
      PointsX2=[1;1;1;1;1;1;1;1;1;1;1];
      PointsY=[PointsY1,PointsY2];
      PointsX=[PointsX1,PointsX2];
      Points=[PointsY(1,:);PointsX(1,:);PointsX(2,:);PointsY(2,:);PointsX(3,:);PointsY(3,:);PointsX(4,:);PointsY(4,:);PointsX(5,:);PointsY(5,:);PointsX(6,:);PointsY(6,:);PointsX(7,:);PointsY(7,:);PointsX(8,:);PointsY(8,:);PointsX(9,:);PointsY(9,:);PointsX(10,:);PointsY(10,:);PointsX(11,:);PointsY(11,:);];
        Populationbaoliu=[];
      Populationbaoliu1=[];
      C=[];  
      C1=[];
      convexhullkneetrain = zeros(Generations/JiLuinterval+1,1);
      convexhullkneetest = zeros(Generations/JiLuinterval+1,1);
%划分五折
       datasettrain  =  datasetsource((Indices~=crossnumber),:);%%五折交叉
       whethertrain  =  whether((Indices~=crossnumber));
       datasettest  =  datasetsource((Indices==crossnumber),:);
       whethertest  =  whether((Indices==crossnumber));
       
       %获取部分特征
        TopK = 0.2;
        Index_F = FS_cfs(datasettrain,TopK);
        poplength = length(Index_F);
        datasettrain = datasettrain(:,Index_F);
        datasettest = datasettest(:,Index_F);
        Boundary = Boundary(:,1:poplength);
%初始种群
        
        Population = initialPop(poplength,N);

   %%%%在训练集上     
        [FunctionValue] = Cal_ObjV(Population,datasettrain,whethertrain);
       %训练集上计算凸包面积
        paretotrain = sortrows(FunctionValue);
        [~,paretotubaotrainck] = chraarea(paretotrain);%画出凸包
        convexhullkneetrain(1) = calculatearea(paretotubaotrainck);%计算凸包的面积
        %测试集上计算凸包面积
        FunctionValuetest = Cal_ObjV(Population,datasettest,whethertest);
        pareto=sortrows(FunctionValuetest);
        [index,paretotubaotestck]=chraarea(pareto);%画出凸包
        convexhullkneetest(1) = calculatearea(paretotubaotestck);%计算凸包的面积
       
        for g = 1 : Generations  %%循环迭代  
            Y=Y/g;            
            Offspring = P_generator(Population,Boundary,'Real',N );%%产生子代
            ObjV_sub = Cal_ObjV(Offspring,datasettrain,whethertrain);
            Population1=[Population;Offspring];
            FunctionValue1=[FunctionValue;ObjV_sub]; 
            %环境选择下一代
            [FunctionValue,Population] = clos(Points,FunctionValue1,N,Population1);
            %选小于阈值的点
            M1 = size(Points,1);
            NN1 = size(FunctionValue1,1);
            discankao1=[];
            ind1=[];
            for i=1:M1
                distance1=zeros(1,NN1);
                for j=1:NN1
                    distance1(j)=sqrt((Points(i,1)-FunctionValue1(j,1))^2+(Points(i,2)-FunctionValue1(j,2))^2);
                end
                [paixu1,index1]=sort(distance1);
                if paixu1(1) <=Y
                   M2=M1-2;
                   Ydist=caly(PointsY2);
                   Xdist=calx(PointsX1);
                   [maxdY,indY] =max(Ydist);
                   [maxdX,indX] =max(Xdist);
                    if i~=1
                        if mod(i,2)==0
                            i=i/2; 
                            PointsY2(i)=(PointsY2(indY)+PointsY2(indY+1))/2;
                            PointsY2=sort(PointsY2,1,'descend');
                            PointsY=[PointsY1,PointsY2];
                            Points=[PointsY(1,:);PointsX(1,:);PointsX(2,:);PointsY(2,:);PointsX(3,:);PointsY(3,:);PointsX(4,:);PointsY(4,:);PointsX(5,:);PointsY(5,:);PointsX(6,:);PointsY(6,:);PointsX(7,:);PointsY(7,:);PointsX(8,:);PointsY(8,:);PointsX(9,:);PointsY(9,:);PointsX(10,:);PointsY(10,:);PointsX(11,:);PointsY(11,:);];
                        else
                            i=(i+1)/2;
                            PointsX1(i)=(PointsX1(indX)+PointsX1(indX+1))/2;
                            PointsX1=sort(PointsX1,1,'ascend');
                            PointsX=[PointsX1,PointsX2];    
                            Points=[PointsY(1,:);PointsX(1,:);PointsX(2,:);PointsY(2,:);PointsX(3,:);PointsY(3,:);PointsX(4,:);PointsY(4,:);PointsX(5,:);PointsY(5,:);PointsX(6,:);PointsY(6,:);PointsX(7,:);PointsY(7,:);PointsX(8,:);PointsY(8,:);PointsX(9,:);PointsY(9,:);PointsX(10,:);PointsY(10,:);PointsX(11,:);PointsY(11,:);];
                        end
                    end
                end
            end

            ind1 = [ind1;index1(1)];
            Populationbaoliu11 = Population1(ind1,:);
            Populationbaoliu = [Populationbaoliu;Populationbaoliu11];
            KN = size(Populationbaoliu,1);
            if KN>Narchive
                 knf = Cal_ObjV(Populationbaoliu,datasettrain,whethertrain);%子代
                  [U,R]=splitpopulation(knf);%%分为冗余和非冗余    
                 if size(U,1)<=Narchive%此处应该是98，也就是N-2，是需要保留的个数
                    number=randperm(size(R,1));
                    resultstemp=[U;R(number(1:Narchive-size(U,1)),:)]; 
                 else  
                    resultstemp=Reduce(U,size(knf,1)-Narchive,fanwei);
                 end
                    number=findsequence(resultstemp,knf);
                    Populationbaoliu=Populationbaoliu(number,:);
            end

         %选落在坐标轴上的点
             tpr1=find(FunctionValue1(:,1)==0);
             maxtpr=max(FunctionValue1(tpr1,2));
              if(isempty( maxtpr))
                  maxtpr=0;
              end
                archive1=[0,maxtpr];      
                fpr1=find( FunctionValue1(:,2)==1);    
                minfpr=min(FunctionValue1(fpr1,1));
              if(isempty(minfpr))
                minfpr=1;
              end
                archive2=[minfpr,1];
                archive3=[archive1;archive2];
             for i=1:size(archive3,1)
                for j=1:size(FunctionValue1,1)
                    if archive3(i,:)==FunctionValue1(j,:)
                       C=[C;j];          
                    end
                end
             end
             C=unique(C);
             Populationbaoliu12=Population1(C,:);
             k=size(Populationbaoliu12,1);
             if k>2
                Populationbaoliu12 = Populationbaoliu12(randperm(k, 2),:);
             end
             Populationbaoliu1 = [Populationbaoliu1;Populationbaoliu12];
            %对坐标轴上的点只保留两个
            if (isempty(Populationbaoliu1))
                  Populationbaoliu1=[];         
            else
                zuobiao = Cal_ObjV(Populationbaoliu1,datasettrain,whethertrain);
                ztpr1=find(zuobiao(:,1)==0);
                zmaxtpr=max(zuobiao(ztpr1,2));
                if(isempty( zmaxtpr))
                  zmaxtpr=0;
                end
                archive11=[0,zmaxtpr];      
                zfpr1=find(zuobiao(:,2)==1);    
                zminfpr=min(zuobiao(zfpr1,1));
                if(isempty(zminfpr))
                 zminfpr=1;
                end
                archive22=[zminfpr,1];
                archive33=[archive11;archive22];
                for i=1:size(archive33,1)
                    for j=1:size(zuobiao,1)
                       if archive33(i,:)==zuobiao(j,:)
                       C1=[C1;j];          
                       end
                    end
                end
                C1 = unique(C1);
                Populationbaoliu1=Populationbaoliu1(C1,:);
                k=size(Populationbaoliu1,1);
                %zuonum=100-KN;
                if k>2
                   Populationbaoliu1= Populationbaoliu1(randperm(k,2),:);
                end
            end
            blPopulation=[Populationbaoliu;Populationbaoliu1];                                                                                                                                                                                                                               
        %-------------------------------------------------------------
            if(mod(g,JiLuinterval)==0)
            %在训练集和测试集上计算auc只值
                Populationhb=[blPopulation;Population];
                zFunctionValue = Cal_ObjV(Populationhb,datasettrain,whethertrain);
                Points1=[0 1;0 1;0.1 1;0 0.9;0.2 1;0 0.8;0.3 1;0 0.7;0.4 1;0 0.6;0.5 1;0 0.5;0.6 1;0 0.4;0.7 1;0 0.3;0.8 1;0 0.2;0.9 1;0 0.1;1 1;0 0];
                %合并种群环境选择
                [FunctionValuetrain,Populationhb]=clos(Points1,zFunctionValue,N,Populationhb); 
                [FrontNo,MaxFNo] = NDsort_CH(FunctionValuetrain,size(FunctionValuetrain,1));
                pop_forCH = Populationhb(FrontNo==1,:);
                trainObj_forCH = FunctionValuetrain(FrontNo==1,:);
                %在测试集上计算FunctionValue
                FunctionValuetest = Cal_ObjV(pop_forCH,datasettest,whethertest);
                %训练集上计算凸包面积
                paretotrain = sortrows(trainObj_forCH);
                [~,paretotubaotrainck] = chraarea(paretotrain);%画出凸包
                convexhullkneetrain(g/JiLuinterval+1) = calculatearea(paretotubaotrainck);%计算凸包的面积
                %测试集上计算凸包面积
                pareto=sortrows(FunctionValuetest);
                [index,paretotubaotestck]=chraarea(pareto);%画出凸包
                convexhullkneetest(g/JiLuinterval+1) = calculatearea(paretotubaotestck);%计算凸包的面积
            end
        end%%
            %每折结果
            CH( (x-1)*K + crossnumber , :) = {convexhullkneetest(end) * 100,unique(paretotubaotestck,'rows')};
            cankaotrain = cankaotrain + convexhullkneetrain;
            cankaotest = cankaotest + convexhullkneetest;
            paretotubaotrainck(:,2) = 1 - paretotubaotrainck(:,2);
            paretotubaotestck(:,2) = 1 - paretotubaotestck(:,2);
            hv_train = hv_train + HV_1(paretotubaotrainck); 
            hv_test = hv_test + HV_1(paretotubaotestck);
   end 
            %保存每遍结果
            CHarea_train = CHarea_train + cankaotrain/K;
            CHarea_test = CHarea_test + cankaotest/K;
            Fauch_train(x) = (cankaotrain(end)/K)*100;
            Fauch(x) = (cankaotest(end)/K)*100;
            HV_train(x) = hv_train/K;
            HV_test(x) = hv_test/K;
            time = toc;
            Time(x,1) = time/K;

end%
            %处理最终结果
            CHarea_train = CHarea_train/repetition;
            CHarea_test = CHarea_test/repetition;
            performance_train = [mean(Fauch_train,'all'),std(Fauch_train,0,'all')];   
            performance = [mean(Fauch,'all'),std(Fauch,0,'all')];
            performance_HV_train = [mean(HV_train,'all'),std(HV_train,0,'all')];
            performance_HV_test = [mean(HV_test,'all'),std(HV_test,0,'all')];
            MeanTime = [mean(Time,'all'),std(Time,0,'all')];
%             fprintf('%.3f %.2f\n',performance(1),performance(2));
  %           fprintf('--------------\n');
 %            fprintf('%.3f %.3f\n',performance_HV_test(1),performance_HV_test(2));
%             fprintf('--------------\n');
          fprintf('%.3f %.3f\n',MeanTime(1),MeanTime(2));   
            
             if exist(filename) == 0
                 mkdir(filename);
             end
            %保存结果
            save([filename,'\','CH_allfold_test.mat'],'CH');
            save([filename,'\','CHarea_train.mat'],'CHarea_train');
            save([filename,'\','CHarea_test.mat'],'CHarea_test');
            save([filename,'\','Fauch.mat'],'Fauch');
            save([filename,'\','performance.mat'],'performance');
            save([filename,'\','Fauch_train.mat'],'Fauch_train');
            save([filename,'\','performance_train.mat'],'performance_train');
            save([filename,'\','HV_train.mat'],'HV_train');
            save([filename,'\','performance_HV_train.mat'],'performance_HV_train');
            save([filename,'\','HV_test.mat'],'HV_test');
            save([filename,'\','performance_HV_test.mat'],'performance_HV_test');
            save([filename,'\','MeanTime.mat'],'MeanTime');
            disp([name,'-end']);

end

 