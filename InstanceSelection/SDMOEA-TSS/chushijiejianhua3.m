function [pop,aim,model_model,pop_Nonindex]=chushijiejianhua3(aim2,model1,population1,N)
        pop=cell(1,3);
        aim=cell(1,3);
        model_model=cell(1,3);
        pop_Nonindex=cell(1,3);
        for i=1:3
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%筛选为1的解
        index1=find(aim2(:,3)==i);
%          if size(index1,1)<=round(N/3)
             pop1=population1(index1,:);
             mubiaozhi1=aim2(index1,1:2);
             modeldiyi=model1(index1,1);
             NonDominated     =   P_sort (mubiaozhi1,'first')==1;                   %%%寻找非支配解
            [~,index2]=find(NonDominated(1,:)==1);
%          else
%          %%%产生索引%%  
%          mubiaozhi1=aim2(index1,1:2);
%          pop1=population1(index1,:);
%          modeldiyi=model1(index1,1);
%         [FrontValue1,MaxFront1] = F_NDSort(mubiaozhi1,'bin3'); 
%         CrowdDistance1         = F_distance(mubiaozhi1,FrontValue1);
%         Next        = zeros(1,33);
%         NoN         = numel(FrontValue1,FrontValue1<MaxFront1);
%         Next(1:NoN) = find(FrontValue1<MaxFront1);
%         Last         = find(FrontValue1==MaxFront1);
%         [~,Rank]      = sort(CrowdDistance1(Last),'descend');
%         Next(NoN+1:33) = Last(Rank(1:33-NoN));
%         %%%%%%%%%%
%         pop1= pop1(Next,:);
%         mubiaozhi1=mubiaozhi1(Next,:);
%         modeldiyi=modeldiyi(Next,:);
%         FrontValue1=FrontValue1(Next);
%         CrowdDistance1=CrowdDistance1(Next);
%         NonDominated     =   P_sort (mubiaozhi1,'first')==1;                   %%%寻找非支配解
%         [~,index2]=find(NonDominated(1,:)==1);
%          end
         pop{1,i}=pop1;
         aim{1,i}=mubiaozhi1;
         model_model{1,i}=modeldiyi;
         pop_Nonindex{1,i}=index2;
        end      
end
        
         
         