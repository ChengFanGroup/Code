function [testprecision,testcom,model] = TestMaxAcc(weight,Test_Dataset,Test_Label)
    Dom=size(Test_Dataset,2);
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
    test_result = newpop(i,1:Dom) * Test_Dataset'+classifier(:,end);
    test_result(find(test_result<=0)) = -1;
    test_result(find(test_result>0)) = 1;
    precision(i) = sum(test_result'==Test_Label)/length(Test_Label);
    compression(i)=sum(newpop(i,1:Dom)==0)/Dom;
end
    precision=precision';
    compression=compression';
    index1=find(precision==max(precision));
    testprecision=precision(index1(1),:);
    newcompression=compression(index1,:);
    index2=find(newcompression==max(newcompression));
    testcom=newcompression(index2(1),:);
    
    model=weight(index1(1),:);
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