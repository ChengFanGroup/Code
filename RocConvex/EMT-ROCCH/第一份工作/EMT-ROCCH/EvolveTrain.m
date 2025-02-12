function [population,ObjV_pop,FrontNo,CrowdDis] = EvolveTrain(population,ObjV_pop,popnum,FrontNo,CrowdDis,whethertrain,traindataset,Boundary)
        
        %----------------------1.竞标赛选择构建交配池----------------------------------
        %MatingPool = MyTournamentSelection(FrontNo,CrowdDis,2,popnum,popnum);
        MatingPool = randperm(popnum);
        %------------------------2.交叉变异产生子代-------------------------------------- 
        Offspring = P_generator(population(MatingPool,:),Boundary,'Real',popnum);
        ObjV_offspring = Cal_objV(Offspring,traindataset,whethertrain);
        %------------------------3.合并种群环境选择产生子代--------------------------------------
        %合并父子种群       
        newpopulation = [population;Offspring];
        functionvalue=[ObjV_pop;ObjV_offspring];
        %环境选择
        [population,ObjV_pop,FrontNo,CrowdDis] = ...
                EnvironmentalSelection_ROCCH(newpopulation,functionvalue,popnum);

end

