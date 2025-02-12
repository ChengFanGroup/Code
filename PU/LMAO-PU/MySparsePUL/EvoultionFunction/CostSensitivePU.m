function f = CostSensitivePU(pop)
    load('Train');
    pop=pop';  % 列是参数
    load('cost'); %代价敏感参数
%     RP=dataUN(index==1,:);
%     RN=dataUN(index==0,:);
    
    NewDataPos=[dataPositive];
    NewDataNeg=dataUN;
    [PNum,Dom]=size(NewDataPos);
    UNum=size(NewDataNeg,1);
    k=5;
    IndicesP = crossvalind('Kfold',PNum, k);
    IndicesN = crossvalind('Kfold',UNum, k);
    for i=1:k
         CrossPData=NewDataPos(IndicesP~=i,:);
         CrossNData=NewDataNeg(IndicesN~=i,:);
         %ValiData=Train_Dataset(Indices==k,:);
         %ValiLabel=Train_Label(Indices==k,:);

%          PosData=CrossData(CrossLabel==1,:);
%          NegData=CrossData(CrossLabel==-1,:);
         yp=pop(:,1:Dom)*CrossPData'+pop(:,end);
         yn=pop(:,1:Dom)*CrossNData'+pop(:,end);
         tpr(i)=sum(yp<=0)/length(yp);   %第一个目标TPR         
         crosscost=cost(IndicesN~=i,:);
           
         in=crosscost>=0.5;                     %第二个目标U的cost
         negy=yn(in);
         costn=crosscost(in);
         posy=yn(~in);
         costp=crosscost(~in);
         lossUnlabeln=negy>0;                  
         lossUnlabelp=posy<=0;
         
         loss=sum(costn'.*lossUnlabeln)+sum((1-costp)'.*lossUnlabelp);
         fpr(i)=loss/length(yn);
%          fpr(i)=sum(yn>0)/length(yn);
         clear CrossPData CrossNData yp yn negy posy in costn costp lossUnlabeln lossUnlabelp loss crosscost

    end

     f1=mean(tpr);
     f2=mean(fpr);
%      if (f1==1&&f2==0)||(f1==0&&f2==1)
%          f1==1;
%          f2==1;
%      end
%      if f2==0
%          f2=inf;
%      end
     f=[f1;f2];
     
end