function findFeatSub(weight)
      load('Train');
      load('classifier');
      load('cost'); 
      
      NewDataPos=[dataPositive];
      NewDataNeg=dataUN;
      [PNum,Dom]=size(NewDataPos);
      UNum=size(NewDataNeg,1);
    
      k=5;
      IndicesP = crossvalind('Kfold',PNum, k);
      IndicesN = crossvalind('Kfold',UNum, k);
    
      FronNum=size(weight,1);
      for i=1:FronNum
          new(i,weight(i,:)>0.5)=1;
          new(i,weight(i,:)<=0.5)=0;
      end
      newpop=new.*classifier(:,1:Dom);
      
      for j=1:FronNum    
         for i=1:k
         CrossPData=NewDataPos(IndicesP~=i,:);
         CrossNData=NewDataNeg(IndicesN~=i,:);
         %ValiData=Train_Dataset(Indices==k,:);
         %ValiLabel=Train_Label(Indices==k,:);

%          PosData=CrossData(CrossLabel==1,:);
%          NegData=CrossData(CrossLabel==-1,:);
         yp=newpop(j,1:Dom)*CrossPData'+classifier(:,end);
         yn=newpop(j,1:Dom)*CrossNData'+classifier(:,end);
         
         crosscost=cost(IndicesN~=i,:);
         lossUnlabel=yn>0;                 
         loss(i)=(sum(yp<=0)+sum(crosscost'.*lossUnlabel))/(length(yp)+length(yn));          
         compre(i)= sum(newpop(j,1:Dom)~=0)/Dom;

         end
         
          loss=mean(loss);
          compre=mean(compre);
          vaule(j)=1-loss;
          Yasuo(j)=1-compre;
      end
      %选择精度最高的解
      maxind=find(vaule==max(vaule));
      newYasuo=Yasuo(:,maxind);
      indexY=find(newYasuo==max(newYasuo));
      FeatSub1=weight(maxind(indexY(1)),:)';
      
      %选择精度与压缩率的权衡解
      Reference=[1,1];
      newvalue=[vaule',Yasuo'];
      for i=1:FronNum
          dist(i,:)= pdist2(newvalue(i,:),Reference,'euclidean');
      end
      index1=find(dist==min(dist));
      FeatSub2=weight(index1(1),:)';
        
      %选择压缩率最高的解
      maxindY=find(Yasuo==max(Yasuo));
      Tempvaule=vaule(:,maxindY);
      indexX=find(Tempvaule==max(Tempvaule));
      FeatSub3=weight(maxindY(indexX(1)),:)';
      
      save FeatSub FeatSub1 FeatSub2 FeatSub3;
end