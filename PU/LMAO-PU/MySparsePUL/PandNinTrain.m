function [pacc,nacc,pnacc] = PandNinTrain(weight,dataUN,labelUN)


Dom=size(dataUN,2);
labelUN(find(labelUN==0))=-1;
indexp=find(labelUN==1);
indexn=find(labelUN==-1);
datasetp=dataUN(indexp,:);
datasetn=dataUN(indexn,:);
labelp=labelUN(indexp,:);
labeln=labelUN(indexn,:);


load('classifier');
    Fnum=size(weight,1);
    for j=1:Fnum
     for i=1:Dom
         if weight(j,i)>0.5
             new(j,i)=1;
         else
             new(j,i)=0;
         end
     end
    end
     newpop=new.*classifier(:,1:Dom);
% Reference=[1,1];  
for i=1:Fnum
    yp = newpop(i,1:Dom) * datasetp'+classifier(:,end);
    yn = newpop(i,1:Dom) * datasetn'+classifier(:,end);

    
    yp(find(yp<=0)) = -1;
    yp(find(yp>0)) = 1;
    
    yn(find(yn<=0)) = -1;
    yn(find(yn>0)) = 1;
    pinU(i) = sum(yp'==labelp)/length(labelp);
    ninU(i) = sum(yn'==labeln)/length(labeln);
    
    uAcc(i) = (sum(yp'==labelp)+sum(yn'==labeln))/(length(labelp)+length(labeln));
    
end 
    index=find(uAcc==max(uAcc));
    pnacc=uAcc(index(1));
    pacc=pinU(index(1));
    nacc=ninU(index(1));
    
end