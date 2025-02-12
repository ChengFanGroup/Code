function [Train_precision,Train_compression] = TrainMaxAcc(weight,dataPositive,dataUN)
% input : weight dataPositive dataUN
% output: Acc Com

    Dom=size(dataPositive,2);
    load('classifier');
    load('cost');
    
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
    yp = newpop(i,1:Dom) * dataPositive'+classifier(:,end);
    yn = newpop(i,1:Dom) * dataUN'+classifier(:,end);
    
    lossUnlabel=yn<=0;          
    loss(i)=(sum(yp>0)+sum(cost'.*lossUnlabel))/(length(yp)+length(yn));
    compre(i)= sum(newpop(i,1:Dom)~=0)/Dom;  

end

    precision=loss';
    compression=compre';
    index1=find(precision==max(precision));
    testprecision=precision(index1(1),:);
    newcompression=compression(index1,:);
    
    LastPop=newpop(index1(1),:);
    load('Test');
    test_result = LastPop(:,1:Dom) * Test_Dataset'+classifier(:,end);
    test_result(find(test_result<=0)) = -1;
    test_result(find(test_result>0)) = 1;
    Train_precision = sum(test_result'==Test_Label)/length(Test_Label);
    Train_compression=sum(newpop(i,1:Dom)==0)/Dom;
    

%     value=[precision,compression];
%     acc = mapminmax(value(:,1)',0,1)';
%     com = mapminmax(value(:,2)',0,1)';
%     newvalue=[acc,com];
%     for i=1:Fnum
%         dist(i,:)= pdist2(newvalue(i,:),Reference,'euclidean');  
%     end
%     index3=find(dist==min(dist)); %找到离参考点最近的点，精度和压缩率的权衡解
%     newprecision=precision(index3,:); 
%     index4=find(newprecision==max(newprecision)); 
%     testprecision=newprecision(index4(1));
%     compression=compression(index4);
%     index2=find(compression==max(compression));
%     testcom=compression(index2(1));
end