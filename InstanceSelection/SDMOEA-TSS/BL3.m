function[aim,model_model,pop,pop_Nonindex]=BL3(aim,QFun2,Q,model,model_model,pop,N,pop_Nonindex)
%%model_model是先前的，model是新产生的
QFun=QFun2(:,1:2);
for i=1:3
    %%%%%第一个区域
    qu_index1=find(QFun2(:,3)==i);
    qu_aim=QFun(qu_index1,:);
    qu_model=model(qu_index1,1);
    qu_pop=Q(qu_index1,:);
    mixaim1=[aim{1,i};qu_aim];
    mixpop1=[pop{1,i};qu_pop];
    mixmode11=[model_model{1,i};qu_model];
    if  size(mixaim1,1)<=33
        aim{1,i}=mixaim1;
        pop{1,i}=mixpop1;
        model_model{1,i}=mixmode11;
        NonDominated     =   P_sort (mixaim1,'first')==1;                   %%%寻找非支配解
        [~,index2]=find(NonDominated(1,:)==1);
        pop_Nonindex{1,i}=index2;
    else
        [FrontValue1,MaxFront1] = F_NDSort(mixaim1,'bin3');
        CrowdDistance1         = F_distance(mixaim1,FrontValue1);
        %%%产生索引%%
        Next        = zeros(1,33);
        NoN         = numel(FrontValue1,FrontValue1<MaxFront1);
        Next(1:NoN) = find(FrontValue1<MaxFront1);
        Last         = find(FrontValue1==MaxFront1);
        [~,Rank]      = sort(CrowdDistance1(Last),'descend');
        Next(NoN+1:33) = Last(Rank(1:33-NoN));
        %%%%%%%%%%选第一区域的解
        pop{1,i}= mixpop1(Next,:);
        aim{1,i}=mixaim1(Next,:);
        model_model{1,i}=mixmode11(Next,:);
        FrontValue1=FrontValue1(Next);
        CrowdDistance1=CrowdDistance1(Next);
        NonDominated     =   P_sort (aim{1,i},'first')==1;                   %%%寻找非支配解
        [~,index2]=find(NonDominated(1,:)==1);
        pop_Nonindex{1,i}=index2;
    end
end
end








