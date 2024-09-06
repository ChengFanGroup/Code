function [curve_auchTrain,curve_auchTest,hvtrain,hvtest,Time,ReturnTestCH] = FM_EMTA(traindataset,whethertrain,testdataset,whethertest)
%%%%%%%%%%%%%%%%%
    %poplength = size(traindataset,2);
%-----------------------------------------------------------------------------------------
    % ��ʼ����
    [~,featureNum] = size(traindataset);
    popnum = 200;
    MaxIterations = 500;
    interval = 10;
    JiLuInterval = 10;
    maxRate = 0.20;%0.10/0.20/0.30/0.40
    TaskNum = ceil(log10(featureNum));
    TaskFlag = sort(crossvalind('Kfold', popnum, TaskNum));
    %Updateinterval = 200;
    %�������߽�
    P_Maxlength = featureNum;
    minvalue1  =  ones(1,P_Maxlength)*(-1);
    maxvalue1 = ones(1,P_Maxlength);
    Boundary  =  [maxvalue1;minvalue1];
    %----
 %   Arc_Size = 100;
%-----------------------------------------------------------------------------------------
     curve_auchTrain = zeros(1,1);
     curve_auchTest = zeros(1,1);
%-----------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------
%%%%%%%%%%%%%       ����ѵ�����ݹ��츨����������ݼ�      %%%%%%%%%%%%%%%%%%%%%%
    %��ȡK������������Ӽ�
    %[Index_Fs] = FS_DAEA(datasettrain, whethertrain',TaskNum);
    %[Index_Fs] = FS_VGEA(traindataset, whethertrain',TaskNum);
    %[Index_Fs] = FS_customized(traindataset, whethertrain',TaskNum);
    %[Index_Fs] = FS_customized1(traindataset, whethertrain',TaskNum,maxRate);
    %[Index_Fs] = FS_customized2(traindataset, whethertrain',TaskNum,maxRate);
    %[Index_Fs] = FS_customized3(traindataset, whethertrain',TaskNum,maxRate);
    [Index_Fs] = FS_customized4(traindataset, whethertrain',TaskNum,maxRate);
    %��ʼ��������֮�������(Ĭ��Ϊscore = 0.5)
    Scores = 0.5*ones(TaskNum,TaskNum);
    for T = 1 : size(Index_Fs,1)
       Scores(T,T) = 0.01;
    end
    t = tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P = initial_pop(popnum,P_Maxlength,Index_Fs,TaskFlag);
    ObjV = Cal_objV(P,traindataset,whethertrain);
    %��ʼ��¼
    CH_train = GetConvexHull(ObjV);
    curve_auchTrain(1) = Calculatearea(CH_train);

    [~,test_area] = Calculatearea_test(P,testdataset,whethertest);
    curve_auchTest(1) = test_area;

    %�������������Ⱥ��������
    
    FrontNo = zeros(popnum,1);
    CrowdDis = zeros(popnum,1);

    for T = 1 : TaskNum
        Index_T =  TaskFlag == T;
        [~,~,FrontNo_temp,CrowdDis_temp] = EnvironmentalSelection_ROCCH( P( Index_T , : ),ObjV ( Index_T , : ) , sum(Index_T));
        FrontNo ( Index_T , : ) = FrontNo_temp;
        CrowdDis  ( Index_T, : ) = CrowdDis_temp;
    end
    
    %��ʼArchive
%     Archive_pop = [];
%     Archive_objV = [];
%     O = zeros(popnum,featureNum);
%     ObjV_O = zeros(popnum,2);
%-----------------------------------------------
    %---��ʼ��������
   for g = 1 : MaxIterations
        %----------------------------Transfer Evolve--------------------------------------
        if(mod(g,interval) == 0) %&& g ~= Generations
            %����������������   ����֪ʶ  Ǩ�ƵĽ���   ����������������
            %����������ÿ���������� 1���������ƶ�ѡ������������
            %                                     2������Ӧѡ��͸���Ŀ������
            for T = 1 : TaskNum
                related_task_Flag = wheelSelection(Scores(T,:));
                Index_AS = TaskFlag == related_task_Flag;
                Assisted_Pop = P( Index_AS , : );
                Assisted_FN = FrontNo ( Index_AS ,: );
                Assisted_Solutions = Assisted_Pop(Assisted_FN==1,:);
                if ( size(Assisted_Solutions,1) == 0 )
                    Assisted_Solutions = Assisted_Pop;
                end
                
                Index_cur = TaskFlag == T;
                
                cur_pop = P( Index_cur , : );
                cur_obj = ObjV( Index_cur , : );
                
                [cur_pop,cur_obj,cur_FrontNo,cur_CrowdDis,curScore,~,~] = ...
                    SubTaskEvolveTrain(cur_pop,cur_obj,Assisted_Solutions,whethertrain,traindataset,Boundary,Index_Fs(T,:));
                
                P( Index_cur , :) = cur_pop;
                ObjV(Index_cur , : ) = cur_obj;
                FrontNo ( Index_cur , : ) = cur_FrontNo;
                CrowdDis  (Index_cur , : ) = cur_CrowdDis;
                %O ( Index_cur , :) = off_pop;
                %ObjV_O (Index_cur , : ) = off_obj;
                %������������
                Scores(T,related_task_Flag)  = UpdataScore(Scores(T,related_task_Flag),curScore);
                %����Archive
                %[Archive_pop,Archive_objV] = ArchiveUpdate(Archive_pop,Archive_objV,O,ObjV_O,Arc_Size);
            end
        else
             %�������������������Ե�������   ����������������
                %����Ⱥ�ֱ����
            for T = 1 : TaskNum
                Index_F = Index_Fs(T,:)==1;
                Index_cur = TaskFlag == T;
                cur_pop = P(Index_cur , : ); cur_pop = cur_pop(:,Index_F);
                cur_obj = ObjV(Index_cur , : );
                cur_FrontNo = FrontNo(Index_cur , : );
                cur_CrowdDis = CrowdDis(Index_cur , : );
                
                [cur_pop,cur_obj,cur_FrontNo,cur_CrowdDis,~,~] = ...
                    SubEvolveTrain_U(cur_pop , cur_obj , cur_FrontNo , cur_CrowdDis , whethertrain , traindataset(:,Index_F) , Boundary(:,1:sum(Index_F)));
                
                P ( Index_cur, Index_F) = cur_pop;
                ObjV( Index_cur,: ) = cur_obj;
                FrontNo ( Index_cur,: ) = cur_FrontNo;
                CrowdDis  ( Index_cur,: ) = cur_CrowdDis;
                %O ( Index_cur , Index_F) = off_pop;
                %ObjV_O (Index_cur , : ) = off_obj;
                %����Archive
                %[Archive_pop,Archive_objV] = ArchiveUpdate(Archive_pop,Archive_objV,O,ObjV_O,Arc_Size);
            end
        end
%-----------------------------------------------
%         %ÿk����¼���������е�AUCH
        if(mod(g,JiLuInterval)==0)
            %[P_OutPut,ObjV_OutPut,~,~] = EnvironmentalSelection_ROCCH( [P;Archive_pop],[ObjV;Archive_objV],popnum);
            P_OutPut = P;
            ObjV_OutPut = ObjV;
%             figure
%             x1 = ObjV(:,1);
%             y1 = ObjV(:,2);
%             x2 = Archive_objV(:,1);
%             y2 = Archive_objV(:,2);
%             x3 = ObjV_CH(:,1);
%             y3 = ObjV_CH(:,2);
%             plot(x1,y1,'r^');
%             hold on
%             plot(x2,y2,'go');
%           %  plot(x3,y3,'bo');
%             hold off
            CH_train= GetConvexHull(ObjV_OutPut);
            curve_auchTrain(g/JiLuInterval+1) = Calculatearea(CH_train);

            [CH_test,test_area] = Calculatearea_test(P_OutPut,testdataset,whethertest);
            curve_auchTest(g/JiLuInterval+1) = test_area;
        end
    end
%-----------------------------------------------
        Time = toc(t);
        %����������͹��
        ReturnTestCH = CH_test;
        %AUCH
%         CH_train= GetConvexHull(ObjV);
%         curve_auchTrain(2) = Calculatearea(CH_train);
% 
%         [CH_test,test_area] = Calculatearea_test(P,testdataset,whethertest);
%         curve_auchTest(2) = test_area;
        %HV
        CH_train(:,2) = 1 - CH_train(:,2);
        CH_test(:,2) = 1 - CH_test(:,2);
        hvtrain = HV_1(CH_train);
        hvtest = HV_1(CH_test);
        %��¼���������AUCH �� HV
%         CH_solutions_train_ass = GetConvexHull(ObjV_help);
%         Auchtrain_Ass = Calculatearea(CH_solutions_train_ass);
%         
%         CH_solutions_train_ass(:,2) = 1 - CH_solutions_train_ass(:,2);
%         hvtrain_Ass = HV_1(CH_solutions_train_ass);
% 
%         [CH_solutions_test_ass,test_area] = Calculatearea_test(population_help,testdataset(:,Index_F),whethertest);
%         Auchtest_Ass = test_area;
%         
%         CH_solutions_test_ass(:,2) = 1 - CH_solutions_test_ass(:,2);
%         hvtest_Ass = HV_1(CH_solutions_test_ass);
        
end

