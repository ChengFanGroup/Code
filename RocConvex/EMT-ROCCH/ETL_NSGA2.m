function [curve_auchTrain,curve_auchTest,Auchtrain_Ass,Auchtest_Ass,hvtrain,hvtest,hvtrain_Ass,hvtest_Ass,ReturnTestCH,poplength_help,time0] = ...
    ETL_NSGA2(maxgen,JiLuInterval,whethertrain,whethertest,traindataset,testdataset)
%%%%%%%%%%%%%%%%%
%------------------------------------------------------------------------------------------- 
    %初始参数
    popnum = 100;
    K = 10;%2M,m=1,3,5,7,9=>  k=2,6,10,14,18
    interval = 20;
    Generations = maxgen;
    featureNum = size(traindataset,2);
    curve_auchTrain = zeros(Generations/JiLuInterval+1,1);
    curve_auchTest = zeros(Generations/JiLuInterval+1,1);
    %构造个体边界
    poplength = featureNum;
    minvalue1  =  ones(1,poplength)*(-1);
    maxvalue1 = ones(1,poplength);
    Boundary  =  [maxvalue1;minvalue1];

%------------------------------------------------------------------------------------------- 
%%%%%%%%%%%%%根据训练数据构造辅助任务的数据集%%%%%%%%%%%%%%%%%%%%%%
    %   FS方法
    %Index_F = FS_reliefF_knee3(datasettrain,whethertrain,100,10,20,ceil(featureNum*0.05));
    TopK = 0.2;%0.2d
    Index_F = FS_cfs_n(traindataset,TopK);
    %Index_F = FS_mutinf(datasettrain,whethertrain',0.05);
    %[Index_F] = FS_DAEA(datasettrain, whethertrain');
    t0 = tic;
    %[Index_F] = FS_VGEA(traindataset, whethertrain');
    poplength_help = length(Index_F);
    Boundary_help = Boundary(:,1:poplength_help);
    %初始辅助任务种群
    population_help = initial_pop(popnum,poplength_help);
    ObjV_help = Cal_objV(population_help,traindataset(:,Index_F),whethertrain);
    %初始原始种群
    population = initial_pop(popnum,poplength);
    ObjV_pop = Cal_objV(population,traindataset,whethertrain);
%------------------------------------------------------------------------------------------- 
    %初始目标值及AUCH
    CH_train = GetConvexHull(ObjV_pop);
    curve_auchTrain(1) = Calculatearea(CH_train);

    [~,test_area] = Calculatearea_test(population,testdataset,whethertest);
    curve_auchTest(1) = test_area;
%------------------------------------------------------------------------------------------- 
    %初代排序
    [~,~,FrontNo_oral,CrowdDis_oral] = EnvironmentalSelection_ROCCH(population,ObjV_pop,popnum);
    [~,~,FrontNo_Ass,CrowdDis_Ass] = EnvironmentalSelection_ROCCH(population_help,ObjV_help,popnum);
        
%------------------------------------------------------------------------------------------- 
    %---开始迭代进化
    for g = 1 : Generations
        %----------------------------Transfer Evolve--------------------------------------
        if(mod(g,interval) == 0)%&& g ~= Generations
            %迁移解Ass->oral && Ass->oral
            %—————————选出———————————
            ndSol_indexH = find(FrontNo_Ass==1);
            if(length(ndSol_indexH)<=K)
                    elite_index1 = ndSol_indexH;
                    while(length(elite_index1) < K)
                        Candi_index = setdiff(1:popnum,ndSol_indexH);
                        elite_index1 = [elite_index1 (Candi_index(randi([1,length(Candi_index)],1,K-length(elite_index1))))];
                        elite_index1 = unique(elite_index1);
                    end
            else
                elite_index1 = ChoosenSolution2(ObjV_help(ndSol_indexH,:),K);
                elite_index1 = ndSol_indexH(elite_index1);
            end
            %选择迁往辅助种群的解
            ndSol_index = find(FrontNo_oral==1);
            if(length(ndSol_index)<=K)
                    elite_index2 = ndSol_index;
                    while(length(elite_index2) < K)
                        Candi_index = setdiff(1:popnum,ndSol_index);
                        elite_index2 = [elite_index2 (Candi_index(randi([1,length(Candi_index)],1,K-length(elite_index2))))];
                        elite_index2 = unique(elite_index2);
                    end
            else
                elite_index2 = ChoosenSolution2(ObjV_pop(ndSol_index,:),K);
                elite_index2 = ndSol_index(elite_index2);
            end
            
            %解编码映射
            solution12 = encode12(population_help(elite_index1,:),Index_F,poplength);
            ObjV_solution12 = ObjV_help(elite_index1,:);
            solution21 = encode21_new(population(elite_index2,:),Index_F,population_help(ndSol_indexH,:),Boundary_help);
            ObjV_solution21 = Cal_objV(solution21,traindataset(:,Index_F),whethertrain);

            %—————————③基于迁移解的进化———————————
            %———————————原任务进化———————————
            [Extend_pop,ObjV_Epop,FrontNo_Epop,~] = EnvironmentalSelection_ROCCH([population;solution12],[ObjV_pop;ObjV_solution12],(K+popnum));
            FrontNo_sol12 = FrontNo_Epop(popnum+1:end);
            guidingSol12_index = find(FrontNo_sol12==1) + popnum;%引导解在联合种群中的索引
%             if (length(guidingSol12_index) >= (1/2)*K)
%                 [population,ObjV_pop,FrontNo_oral,CrowdDis_oral] = ...
%                     Guide_EvolveTrain(Extend_pop,ObjV_Epop,FrontNo_oral,CrowdDis_oral,guidingSol12_index,popnum,whethertrain,traindataset,Boundary);
            if (length(guidingSol12_index) > 1)
                [population,ObjV_pop,FrontNo_oral,CrowdDis_oral] = ...
                    Guide_EvolveTrain2(Extend_pop,ObjV_Epop,FrontNo_oral,CrowdDis_oral,guidingSol12_index,popnum,whethertrain,traindataset,Boundary);
            else
                [population,ObjV_pop,FrontNo_oral,CrowdDis_oral] = EnvironmentalSelection_ROCCH([population;solution12],[ObjV_pop;ObjV_solution12],popnum);
                [population,ObjV_pop,FrontNo_oral,CrowdDis_oral] = EvolveTrain_U(population,ObjV_pop,popnum,FrontNo_oral,CrowdDis_oral,whethertrain,traindataset,Boundary);
            end
            %————————————辅助任务———————————
            [population_help,ObjV_help,FrontNo_Ass,CrowdDis_Ass] = EnvironmentalSelection_ROCCH([population_help;solution21],[ObjV_help;ObjV_solution21],popnum);
            [population_help,ObjV_help,FrontNo_Ass,CrowdDis_Ass] = EvolveTrain_U(population_help,ObjV_help,popnum,FrontNo_Ass,CrowdDis_Ass,whethertrain,traindataset(:,Index_F),Boundary_help);
        else
             %————————各自单独进化   ————————
            [population,ObjV_pop,FrontNo_oral,CrowdDis_oral] = ...
                EvolveTrain_U(population,ObjV_pop,popnum,FrontNo_oral,CrowdDis_oral,whethertrain,traindataset,Boundary);
            [population_help,ObjV_help,FrontNo_Ass,CrowdDis_Ass] = ...
                EvolveTrain_U(population_help,ObjV_help,popnum,FrontNo_Ass,CrowdDis_Ass,whethertrain,traindataset(:,Index_F),Boundary_help);
             
        end
%-----------------------------------------------
        %每k代记录迭代过程中的AUCH
        if(mod(g,JiLuInterval)==0)
            CH_train= GetConvexHull(ObjV_pop);
            curve_auchTrain(g/JiLuInterval+1) = Calculatearea(CH_train);

            [CH_test,test_area] = Calculatearea_test(population,testdataset,whethertest);
            curve_auchTest(g/JiLuInterval+1) = test_area;
%             figure
%             x = 0 : 1;
%             y = x;
%             plot(x,y,'-');
%             hold on
%             x1 = CH_solutions_train(:,1);
%             y1 = CH_solutions_train(:,2);
%             plot(x1,y1,'r*');
%             hold off
        end
    end
    time0 = toc(t0);
%-----------------------------------------------
        %返回最后测试凸包
        ReturnTestCH = CH_test;
        %HV
        CH_train(:,2) = 1 - CH_train(:,2);
        CH_test(:,2) = 1 - CH_test(:,2);
        hvtrain = HV_1(CH_train);
        hvtest = HV_1(CH_test);
        %记录辅助任务的AUCH 和 HV
        CH_solutions_train_ass = GetConvexHull(ObjV_help);
        Auchtrain_Ass = Calculatearea(CH_solutions_train_ass);
        
        CH_solutions_train_ass(:,2) = 1 - CH_solutions_train_ass(:,2);
        hvtrain_Ass = HV_1(CH_solutions_train_ass);

        [CH_solutions_test_ass,test_area] = Calculatearea_test(population_help,testdataset(:,Index_F),whethertest);
        Auchtest_Ass = test_area;
        
        CH_solutions_test_ass(:,2) = 1 - CH_solutions_test_ass(:,2);
        hvtest_Ass = HV_1(CH_solutions_test_ass);
        
end

