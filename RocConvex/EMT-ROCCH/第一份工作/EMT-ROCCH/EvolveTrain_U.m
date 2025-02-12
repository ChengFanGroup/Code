function [population,ObjV_pop,FrontNo,CrowdDis] = EvolveTrain_U(population,ObjV_pop,popnum,FrontNo,CrowdDis,whethertrain,traindataset,Boundary)
        
        %----------------------1.竞标赛选择构建交配池----------------------------------
        %MatingPool = MyTournamentSelection(FrontNo,CrowdDis,2,popnum,popnum);
        MatingPool = randperm(popnum);
        %------------------------2.交叉变异产生子代-------------------------------------- 
        Offspring = P_generator(population(MatingPool,:),Boundary,'Real',popnum);
        ObjV_offspring = Cal_objV(Offspring,traindataset,whethertrain);
        %------------------------3.合并种群环境选择产生子代(无冗余)--------------------------------------
        %合并父子种群       
        newpopulation = [population;Offspring];
        functionvalue=[ObjV_pop;ObjV_offspring];
        %找出候选
        [U] = splitpopulation(functionvalue);
        [U_in,ImpPoint] = splitpopulation2(functionvalue(U,:));
        U_in = U(U_in);%内部点索引
        ImpPoint = U(ImpPoint);%最好边点索引
        other = setdiff(1:size(newpopulation,1),[U_in ImpPoint]);
        %--------------------
        other_functionvalue = functionvalue(other,:);
        other_newpopulation = newpopulation(other,:);
        ImpPoint_functionvalue = functionvalue(ImpPoint,:);
        ImpPoint_newpopulation = newpopulation(ImpPoint,:);
        functionvalue = functionvalue(U_in,:);
        newpopulation = newpopulation(U_in,:);

        ChoosenNum = popnum-length(ImpPoint);
        
        if (length(U_in)>ChoosenNum)
            [Choosen_pop,Choosen_funcvalue,FrontNo_Choosen,CrowdDis_Choosen] = EnvironmentalSelection_ROCCH(newpopulation,functionvalue,ChoosenNum);
            population(1:ChoosenNum,:) = Choosen_pop;
            ObjV_pop(1:ChoosenNum,:) = Choosen_funcvalue;
            FrontNo(1:ChoosenNum) = FrontNo_Choosen;
            CrowdDis(1:ChoosenNum) = CrowdDis_Choosen;
        else
            population(1:length(U_in),:) = newpopulation;
            ObjV_pop(1:length(U_in),:) = functionvalue;
            FrontNo(1:length(U_in)) = 1;
            CrowdDis(1:length(U_in)) = 0;
            %随机补充
            randOtherindex = randi([1,length(other)],1,ChoosenNum-length(U_in));
            population(length(U_in)+1:ChoosenNum,:) = other_newpopulation(randOtherindex,:);
            ObjV_pop(length(U_in)+1:ChoosenNum,:) = other_functionvalue(randOtherindex,:);
            FrontNo(length(U_in)+1:ChoosenNum) = 2;
            CrowdDis(length(U_in)+1:ChoosenNum) = 0;
        end
             population(ChoosenNum+1:end,:) = ImpPoint_newpopulation;
             ObjV_pop(ChoosenNum+1:end,:) = ImpPoint_functionvalue;
             FrontNo(ChoosenNum+1:end) = 1;
             CrowdDis(ChoosenNum+1:end) = inf;
             
             %打乱种群顺序
             randsort = randperm(popnum);
             population = population(randsort,:);
             ObjV_pop = ObjV_pop(randsort,:);
             FrontNo = FrontNo(randsort);
             CrowdDis = CrowdDis(randsort);
             
end

