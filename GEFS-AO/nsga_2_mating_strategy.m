function [chromes,chromeend] = nsga_2_mating_strategy(pop,times,g1,g2,g3)
%UNTITLED5 此处提供此函数的摘要
%   此处提供详细说明
    global trData trLabel teData teLabel;
    global  featNum ;
    global Zout Zout2 Zout3 ;
    global assiNumInside; % 查看Archive中保留的第一前沿面解的个数
    
    global archievepop1;

    M = 2;

    [chromosome_f] = initialize_variables_f(pop, M,featNum  );
    
    chromosome_f = non_domination_sort_mod(chromosome_f,M,featNum);

    archievepop1 = chromosome_f(:,1:featNum+2);

    Graphq = {g1,g2,g3};

    ak1 = Zout;
    ak2 =  Zout2;
    ak3 = Zout3 ;
    ak1 = ak1 .*g1;
    ak2 = ak2 .*g2;
    ak3 = ak3 .*g3;

    featidx1 = kshell_2(ak1);  idx1 = zeros(1,featNum);  idx1(:,featidx1 ) = 1; 
    featidx2 = kshell_2(ak2);  idx2 = zeros(1,featNum);  idx2(:,featidx2 ) = 1; 
    featidx3 = kshell_2(ak3);  idx3 = zeros(1,featNum);  idx3(:,featidx3 ) = 1; 
    gpbest1 = idx1;
    gpbest2 = idx2;
    gpbest3 = idx3;
    n1 = evaluate_objective_f(2, idx1);
    n2 = evaluate_objective_f(2, idx2);
    n3 = evaluate_objective_f(2, idx3);
    ger1 = n1(1,1); gfm1 = n1(1,2);  gpbestfitness1 = 0.9*ger1 +0.1*gfm1;
    ger2 = n2(1,1); gfm2 = n2(1,2);  gpbestfitness2 = 0.9*ger2 +0.1*gfm2;
    ger3 = n3(1,1); gfm3 = n3(1,2);  gpbestfitness3 = 0.9*ger3 +0.1*gfm3;

    

    arChive = [];% 暂存每代非支配解
    kGenWeiArchive = []; % k代后的距离评价结果
    kGenAccArchive = []; % K代后的精度
    % distanceSet = [];
    archivePop = 50;
    studyflag = 1;
    for i = 1 : times
        g1 = Graphq{1};
        g2 = Graphq{2};
        g3 = Graphq{3};
        px = 0.9;
        pm = 0.01;
        childgraph = [];

        if mod(i,9) ==1
        [idx,ermaxloc,fmmaxloc,zonghemaxloc,popteacher,gpbest1,gpbest2,gpbest3,gpbestfitness1,gpbestfitness2,gpbestfitness3,ger1,ger2,ger3,gfm1,gfm2,gfm3] = gdirect(g1,g2,g3,i,chromosome_f(:,1:featNum+2),gpbest1,gpbest2,gpbest3,gpbestfitness1,gpbestfitness2,gpbestfitness3,ger1,ger2,ger3,gfm1,gfm2,gfm3);
        
        [graph_pop_f2,~] = size(popteacher);
        tidx = chromosome_f(:,end-1)==1;
        chromegraph = chromosome_f(tidx,:);
        [mo,no] = size(chromegraph );
        %求学习之前平均适应度
        average_column_acc = mean(0.9*chromegraph(:,featNum + 1)+0.1*chromegraph(:,featNum + 2)./featNum);
        childgraph = newgenetic_operator_f(chromegraph, M, featNum,idx, 0.9,pm,chromosome_f(:,1:featNum),g1,g2,g3,studyflag);

        accnew = 0.9*childgraph(:,featNum + 1)+0.1*childgraph(:,featNum + 2)./featNum;
        [sorted_values, indices] = sort(accnew);
        bottom_10_rows = indices(1:mo);
        accnew1 = accnew(bottom_10_rows,:);
        average_column_accnew = mean(accnew1);
        
        if  average_column_accnew < average_column_acc
            studyflag = 1;
        else
            studyflag = 0;
        end 



        [graph_pop_f1,~] = size(childgraph);
        childgraph(graph_pop_f1+1:graph_pop_f1+graph_pop_f2,:) = popteacher;
        else
         childgraph = [];
        end

        pool = round(pop/2);
        tour = 2;

        


        parent_chromosome_f = tournament_selection(chromosome_f, pool, tour); % 锦标赛


        

        [offspring_chromosome_f] = ...
            genetic_operator_f(parent_chromosome_f, M, featNum, px,pm,chromosome_f(:,1:featNum),g1,g2,g3); % 产生子代

        


        [main_pop_f,~] = size(chromosome_f);
        %     [main_pop_s,~] = size(chromosome_s);
        [graph_pop_f,~] = size(childgraph);

        %%
        % 因为不共享，所以每个种群只合并自己的子种群
        [offspring_pop_f,~] = size(offspring_chromosome_f);
        %         [offspring_pop_s,~] = size(offspring_chromosome_s);

        intermediate_chromosome_f(1:main_pop_f,:) = chromosome_f;
        intermediate_chromosome_f(main_pop_f + 1 : main_pop_f + offspring_pop_f,1 : M+featNum) = ...
            offspring_chromosome_f;
         intermediate_chromosome_f(main_pop_f+ offspring_pop_f+ 1 : main_pop_f + offspring_pop_f+graph_pop_f,1 : M+featNum) = ...
            childgraph;
        merge_f = intermediate_chromosome_f;


        intermediate_chromosome_f = ...
            non_domination_sort_mod(intermediate_chromosome_f, M, featNum); % 非支配分层
        %     intermediate_chromosome_s = ...
        %         non_domination_sort_mod(intermediate_chromosome_s, M, V_s);
        
        %节点权值改变策略
        parentPop = chromosome_f;
        tidx = parentPop(:,end-1)==1;
        t = abs(parentPop(tidx,featNum+1));
        if size(t,1)>archivePop % 每代最多保留archivePop个精英解
          [~,tidx] = sort(t,'ascend');
          tidx = tidx(1:archivePop);
          t = t(tidx);        
        end
        tmpArc = parentPop(tidx,1:featNum);
        tempkGenArchive = disEva(logical(tmpArc));
        arChive = [arChive; tmpArc];
        kGenWeiArchive = [kGenWeiArchive,tempkGenArchive]; % k代结果合并，保留
    
%     arChive = []; % 外部文档中最优解清空，准备保留下代最优解
        tempkGenArchive = []; % 清空
        



        
        chromosome_f = replace_chromosome(intermediate_chromosome_f, M, featNum, pop); % 前沿面替换新一代
        %     chromosome_s = replace_chromosome(intermediate_chromosome_s, M, V_s, pop);
        
        archievepop1 = [archievepop1;chromosome_f(:,1:featNum+2)]; 


        if mod(i,9)==1
             
         toChangeWeight(kGenWeiArchive, kGenAccArchive,arChive);% 改变权重的操作 % 
         assiNumInside = [assiNumInside;size(kGenWeiArchive,2)];
         kGenWeiArchive = []; % 前k代保留的第一前沿面个体信息置空
         kGenAccArchive = [];
         arChive = [];



         itidx = find(chromosome_f(:,end-1) ==1) ;
         frontchrome = abs(chromosome_f(itidx,1:end-2));


         fit1 = 0.5.*frontchrome(:,end-1)+0.5.*(frontchrome(:,end)./featNum);
         select1 = find(fit1 == min(fit1));
         idxselect1 = select1(1,:);
         featidx1 = frontchrome(idxselect1,1 :featNum);
         feat1 = find(featidx1~=0);

         fit2 = frontchrome(:,end-1);
         select2 = find(fit2 == min(fit2));
         idxselect2 = select2(1,:);
         featidx2 = frontchrome(idxselect2,1 :featNum);
         feat2 = find(featidx2~=0);

         fit3 = frontchrome(:,end);
         select3 = find(fit3 == min(fit3));
         idxselect3 = select3(1,:);
         featidx3 = frontchrome(idxselect3,1 :featNum);
         feat3 = find(featidx3~=0);
         
         Graphq{ermaxloc} = changegraph(feat2,Graphq{ermaxloc});
         Graphq{fmmaxloc} = changegraph(feat3,Graphq{fmmaxloc});
         Graphq{zonghemaxloc} = changegraph(feat1,Graphq{zonghemaxloc});
        end


    end
    chromes = chromosome_f;
    chromeend = non_domination_sort_mod(archievepop1, M, featNum);
    

end