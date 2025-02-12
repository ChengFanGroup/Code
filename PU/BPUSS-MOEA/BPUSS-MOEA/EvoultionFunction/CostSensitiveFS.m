function f = CostSensitiveFS(pop)
    load('Train');
    pop=pop';
%     load('cost'); %识别RP  
    load('classifier');
    load('cost');
    
    
    NewDataPos=[dataPositive];
    NewDataNeg=dataUN;
    [PNum,Dom]=size(NewDataPos);
    UNum=size(NewDataNeg,1);
   
    k=5;
    IndicesP = crossvalind('Kfold',PNum, k);
    IndicesN = crossvalind('Kfold',UNum, k);
    
    new(:,pop>0.5)=1;  %对特征种群进行改造
    new(:,pop<=0.5)=0;
    
    newpop=new.*classifier(:,1:Dom); 
    
    for i=1:k
         CrossPData=NewDataPos(IndicesP~=i,:);
         CrossNData=NewDataNeg(IndicesN~=i,:);
         %ValiData=Train_Dataset(Indices==k,:);
         %ValiLabel=Train_Label(Indices==k,:);

%          PosData=CrossData(CrossLabel==1,:);
%          NegData=CrossData(CrossLabel==-1,:);
         yp=newpop(:,1:Dom)*CrossPData'+classifier(:,end);
         yn=newpop(:,1:Dom)*CrossNData'+classifier(:,end);
         
        crosscost=cost(IndicesN~=i,:);
        
         in=crosscost>0.5;                     %第二个目标U的cost
         negy=yn(in);
         costn=crosscost(in);
         posy=yn(~in);
         costp=crosscost(~in);
         lossUnlabeln=negy>0;                  
         lossUnlabelp=posy<=0;
         costloss=sum(costn'.*lossUnlabeln)+sum(costp'.*lossUnlabelp);
         
        loss(i)=(sum(yp<=0)+costloss)/(length(yp)+length(yn));
      
         compre(i)= sum(newpop(:,1:Dom)~=0)/Dom;
         clear negy posy in costn costp lossUnlabeln lossUnlabelp 
    end

    
     
     f1=mean(loss);
     f2=mean(compre);
%      if (f1==1&&f2==0)||(f1==0&&f2==1)
%          f1==1;
%          f2==1;
%      end
     if f2==0
         f2=inf;
     end
     f=[f1;f2];
     
end