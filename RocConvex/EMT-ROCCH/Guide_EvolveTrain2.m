function [population,ObjV_pop,FrontNo,CrowdDis] = Guide_EvolveTrain2(Extend_pop,ObjV_Epop,FrontNo,CrowdDis,guidingSol_index,popnum,whethertrain,traindataset,Boundary)
%%%%%%%%%%%%%%%%%
    
    %——————————1.构建交配池————————————————
        MatingPool1 = MyTournamentSelection(FrontNo,CrowdDis,2,popnum,popnum/2);%二元锦标赛选出一半的个体
        MatingPool2 = MyTournamentSelection(FrontNo,CrowdDis,2,popnum,popnum/2);
        
     %——————————2.产生子代———————————————— 
        %基于迁移解产生1/2子代
        MatingPool11 = setdiff(1:popnum,MatingPool1);
        MatingPool11 = MatingPool11(1:popnum/2);
        Offspring1 = Generator_baseon_T(Extend_pop(MatingPool11,:),Extend_pop(guidingSol_index,:),Boundary,popnum/2);
        %独立产生1/2子代
        Offspring2 = P_generator(Extend_pop(MatingPool2,:),Boundary,'Real',popnum/2);
        %评价子代
        Offspring = [Offspring1;Offspring2];
        ObjV_offspring = Cal_objV(Offspring,traindataset,whethertrain);
%------------------------3.合并种群环境选择产生子代(无冗余)--------------------------------------
        %合并父子种群       
        newpopulation = [Extend_pop;Offspring];
        functionvalue=[ObjV_Epop;ObjV_offspring];
        [population,ObjV_pop,FrontNo,CrowdDis] = ...
        EnvironmentalSelection_ROCCH(newpopulation,functionvalue,popnum);
%         %找出候选
%         [U] = splitpopulation(functionvalue);
%         [U_in,ImpPoint] = splitpopulation2(functionvalue(U,:));
%         U_in = U(U_in);
%         ImpPoint = U(ImpPoint);
%         other = setdiff(1:size(newpopulation,1),[U_in ImpPoint]);
%         %--------------------
%         other_functionvalue = functionvalue(other,:);
%         other_newpopulation = newpopulation(other,:);
%         ImpPoint_functionvalue = functionvalue(ImpPoint,:);
%         ImpPoint_newpopulation = newpopulation(ImpPoint,:);
%         functionvalue = functionvalue(U_in,:);
%         newpopulation = newpopulation(U_in,:);
% 
%         ChoosenNum = popnum-length(ImpPoint);
%         
%         if (length(U_in)>ChoosenNum)
%             
%             [Choosen_pop,Choosen_funcvalue,FrontNo_Choosen,CrowdDis_Choosen] = EnvironmentalSelection(newpopulation,functionvalue,ChoosenNum);
%             population(1:ChoosenNum,:) = Choosen_pop;
%             ObjV_pop(1:ChoosenNum,:) = Choosen_funcvalue;
%             FrontNo(1:ChoosenNum) = FrontNo_Choosen;
%             CrowdDis(1:ChoosenNum) = CrowdDis_Choosen;
% 
%         else
%             population(1:length(U_in),:) = newpopulation;
%             ObjV_pop(1:length(U_in),:) = functionvalue;
%             FrontNo(1:length(U_in)) = 1;
%             CrowdDis(1:length(U_in)) = 0;
%             %随机补充
%             randOtherindex = randi([1,length(other)],1,ChoosenNum-length(U_in));
%             population(length(U_in)+1:ChoosenNum,:) = other_newpopulation(randOtherindex,:);
%             ObjV_pop(length(U_in)+1:ChoosenNum,:) = other_functionvalue(randOtherindex,:);
%             FrontNo(length(U_in)+1:ChoosenNum) = 2;
%             CrowdDis(length(U_in)+1:ChoosenNum) = 0;
%         end
%              population(ChoosenNum+1:popnum,:) = ImpPoint_newpopulation;
%              ObjV_pop(ChoosenNum+1:popnum,:) = ImpPoint_functionvalue;
%              FrontNo(ChoosenNum+1:popnum) = 1;
%              CrowdDis(ChoosenNum+1:popnum) = inf;
%              
%              %打乱种群顺序
%              randsort = randperm(popnum);
%              population = population(randsort,:);
%              ObjV_pop = ObjV_pop(randsort,:);
%              FrontNo = FrontNo(randsort);
%              CrowdDis = CrowdDis(randsort);
end
        
%     %-------非支配排序        
%             fnum=0;%当前分配的前沿面编号
%             cz=false(1,size(functionvalue,1));%记录个体是否已被分配编号
%             frontvalue=zeros(size(cz));%每个个体的前沿面编号
%             [functionvalue_sorted,newsite] = sortrows(functionvalue);%对种群按第一维目标值大小进行排序,左下到右上
%             while ~all(cz)%cz全1 all(a)返回1%开始迭代判断每个个体的前沿面,采用改进的deductive sort   all(),如果全部都不是0，就返回1，否则，返回0（如果有一个是0，则进行循环）
%                 fnum=fnum+1;
%                 d=cz;
%                 for i=1:size(functionvalue,1)
%                     if ~d(i)
%                         for j=i+1:size(functionvalue,1)
%                             if ~d(j)
%                                 k=1;                            
%                                 for m=2:size(functionvalue,2)
%                                     if functionvalue_sorted(i,m)<functionvalue_sorted(j,m)%这里为了classification改动了
%                                         k=0;
%                                         break
%                                     end
%                                 end
%                                 if k
%                                     d(j)=true;   %说明i是可以支配j的，这里记录j已经被分配，所以j肯定不是这一层的。
%                                 end
%                             end
%                         end
%                         frontvalue(newsite(i))=fnum;
%                         cz(i)=true;  %只有无法被其他的点支配的点才能属于这一层
%                     end
%                 end
%             end
% 
%     %-------计算拥挤距离/选出下一代个体        
%             fnum=0; %当前前沿面
%             while numel(frontvalue,frontvalue<=fnum+1) <= ChoosenNum    %判断前多少个面的个体能完全放入下一代种群
%                 fnum=fnum+1;
%             end        
%             newnum=numel(frontvalue,frontvalue<=fnum);                              %前fnum个面的个体数
%             ObjV_pop(1:newnum,:)=functionvalue(frontvalue<=fnum,:); 
%             population(1:newnum,:) = newpopulation(frontvalue<=fnum,:);               %将前fnum个面的个体复制入下一代                       
%             popu=find(frontvalue==fnum+1);                                          %popu记录第fnum+1个面上的个体编号
%             distancevalue=zeros(size(popu));                                        %popu各个体的拥挤距离
%             fmax=max(functionvalue(popu,:),[],1);                                   %popu每维上的最大值
%             fmin=min(functionvalue(popu,:),[],1);                                   %popu每维上的最小值
%             for i=1:size(functionvalue,2)                                           %分目标计算每个目标上popu各个体的拥挤距离
%                 [~,newsite]=sortrows(functionvalue(popu,i));
%                 distancevalue(newsite(1))=inf;
%                 distancevalue(newsite(end))=inf;
%                 for j=2:length(popu)-1
%                     distancevalue(newsite(j))=distancevalue(newsite(j))+(functionvalue(popu(newsite(j+1)),i)-functionvalue(popu(newsite(j-1)),i))/(fmax(i)-fmin(i));
%                 end
%             end
%             popu=-sortrows(-[distancevalue;popu]')';                                %按拥挤距离降序排序第fnum+1个面上的个体
%             population(newnum+1:ChoosenNum,:) = newpopulation(popu(2,1:ChoosenNum-newnum),:);	%将第fnum+1个面上拥挤距离较大的前popnum-newnum个个体复制入下一代          
%             ObjV_pop(newnum+1:ChoosenNum,:) = functionvalue(popu(2,1:ChoosenNum-newnum),:);
%         else
%             randOtherindex = randi([1,length(other)],1,ChoosenNum-length(U_in));
%             population(1:length(U_in),:) = newpopulation;
%             ObjV_pop(1:length(U_in),:) = functionvalue;
%             population(length(U_in)+1:ChoosenNum,:) = other_newpopulation(randOtherindex,:);
%             ObjV_pop(length(U_in)+1:ChoosenNum,:) = other_functionvalue(randOtherindex,:);
%         end
%              population(ChoosenNum+1:popnum,:) = ImpPoint_newpopulation;
%              ObjV_pop(ChoosenNum+1:popnum,:) = ImpPoint_functionvalue; 
% end

