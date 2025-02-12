function  findclassifierPU(weight)
load('Train');

load('cost'); %代价敏感参数
%     RP=dataUN(index==1,:);
%     RN=dataUN(index==0,:);


NewDataPos=dataPositive;
NewDataNeg=dataUN;
[PNum,Dom]=size(NewDataPos);
UNum=size(NewDataNeg,1);
k=5;
IndicesP = crossvalind('Kfold',PNum, k);
IndicesN = crossvalind('Kfold',UNum, k);

for j=1:size(weight,1)
    for i=1:k
        CrossPData=NewDataPos(IndicesP~=i,:);
        CrossNData=NewDataNeg(IndicesN~=i,:);
        %ValiData=Train_Dataset(Indices==k,:);
        %ValiLabel=Train_Label(Indices==k,:);
        
        %          PosData=CrossData(CrossLabel==1,:);
        %          NegData=CrossData(CrossLabel==-1,:);
        yp=weight(j,1:Dom)*CrossPData'+weight(j,end);
        yn=weight(j,1:Dom)*CrossNData'+weight(j,end);

        crosscost=cost(IndicesN~=i,:);
        lossUnlabel=yn>0;
        
        loss(i)=(sum(yp<=0)+sum(crosscost'.*lossUnlabel))/(length(yp)+length(yn));
    end
    loss=mean(loss);
    vaule(j)=loss;
end
maxind=find(vaule==min(vaule));
classifier=weight(maxind(1),:);
save classifier classifier;
end
