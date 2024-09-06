function [sub_pop,sub_obj,FrontNo,CrowdDis,curScore,Offspring,ObjV_offspring] = SubTaskEvolveTrain(sub_pop,sub_obj,Assisted_Solutions,whethertrain,traindataset,Boundary,Index_F)
%%%%%%%%%%%%%%%%%
    
    %��������������������1.��������ء�������������������������������
        MatingPool1 = sub_pop;
        ObjV_MatingPool1 = sub_obj;
        MatingPool2 = Assisted_Solutions;
        
     %��������������������2.�����Ӵ��������������������������������� 
        %����Ǩ�ƽ�����Ӵ�
        subpopnum = size(sub_pop,1);
        Offspring = KnowTransferCrossover(MatingPool1,MatingPool2,Boundary,subpopnum,Index_F);
        Offspring(:,Index_F==0) = 0;
        ObjV_offspring = Cal_objV(Offspring,traindataset,whethertrain);
%------------------------3.�ϲ���Ⱥ����ѡ������Ӵ�--------------------------------------
        %�ϲ�������Ⱥ       
        newpopulation = [MatingPool1;Offspring];
        functionvalue=[ObjV_MatingPool1;ObjV_offspring];
        [sub_pop ,sub_obj, FrontNo , CrowdDis, Next] = EnvironmentalSelection_ROCCH(newpopulation,functionvalue,subpopnum);
        curScore = sum( Next(subpopnum+1 : 2 * subpopnum) ) / subpopnum;
end


