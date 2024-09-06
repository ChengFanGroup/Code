   function [population,ObjV_pop,FrontNo,CrowdDis,off_pop,off_obj] = SubEvolveTrain_U(subpop,ObjV_pop,FrontNo,CrowdDis,whethertrain,traindataset,Boundary)
%%%%%%%%%%%%%%%%%
    
        %——————————1.产生子代————————————————
        popnum = size(subpop,1);
        MatingPool = randperm(popnum);
        
        if ( mod(popnum,2) ~= 0 )
                %FrontNo和CrowdDis 都是1x100
                supplement = MyTournamentSelection(FrontNo,CrowdDis,2,popnum,1);
                MatingPool = [MatingPool supplement];
        end
        % MatingPool = MyTournamentSelection(FrontNo(1,off_Index),CrowdDis(1,off_Index),2,length(off_Index),n);%FrontNo和CrowdDis 都是1x100
        Offspring = P_generator(subpop(MatingPool,:),Boundary,'Real',length(MatingPool));
        %评价子代
        ObjV_offspring = Cal_objV(Offspring,traindataset,whethertrain);
        off_pop = Offspring(1:popnum,:);
        off_obj = ObjV_offspring(1:popnum,:);
        %------------------------2.合并种群环境选择产生子代(无冗余)--------------------------------------
        %合并父子种群       
        newpopulation = [subpop;Offspring];
        functionvalue=[ObjV_pop;ObjV_offspring];
        
%         %找出候选
        [U] = splitpopulation(functionvalue);%无冗余索引
        [U_in,ImpPoint] = splitpopulation2(functionvalue(U,:));
        U_in = U(U_in);
        ImpPoint = U(ImpPoint);
        other = setdiff(1:size(newpopulation,1),[U_in;ImpPoint]);%冗余和边界点
        %------------------------------------------------------
        other_functionvalue = functionvalue(other,:);
        other_newpopulation = newpopulation(other,:);
        ImpPoint_functionvalue = functionvalue(ImpPoint,:);
        ImpPoint_newpopulation = newpopulation(ImpPoint,:);
        functionvalue = functionvalue(U_in,:);
        newpopulation = newpopulation(U_in,:);
        %------------------------------------------------------

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
             population(ChoosenNum+1:popnum,:) = ImpPoint_newpopulation;
             ObjV_pop(ChoosenNum+1:popnum,:) = ImpPoint_functionvalue;
             FrontNo(ChoosenNum+1:popnum) = 1;
             CrowdDis(ChoosenNum+1:popnum) = inf;
             
end

