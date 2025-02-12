function CostSensitiveKNN(dataUN)
% 建立KNN图，计算cost方法

    load('Train');
    PosiNum=size(dataPositive,1);
    NegNum=size(dataUN,1);  %暂时将五标签样本当成负的
    train_data=[dataPositive;dataUN];
    ins_num=PosiNum+NegNum;
    
    la=ones(PosiNum,1);   
    lab=zeros(NegNum,1);
    label=[la;lab];
    k=10; %建立KNN图
    sigma=0.5; %高斯距离参数
    for i=1:ins_num
        for j=1:ins_num
              dis(i,j)= pdist2(train_data(i,:),train_data(j,:),'euclidean');%欧式距离
%              dis(i,j) = exp(-sum((train_data(i,:)-train_data(j,:)).^2)/(2*sigma*sigma));%高斯距离 
        end
    end
    B=zeros(ins_num,ins_num);
    C=zeros(ins_num,ins_num);
    for i=1:ins_num
      [B(i,:),C(i,:)]=sort(dis(i,:),2);
    end
    
    new=C(:,2:k+1);
    
    for i=1:NegNum   %只对无标签样本建立KNN图
         knn(i,:)=label(new(PosiNum+i,:),:);
    end
    
    for i=1:NegNum
        cost(i,:)=(k-sum(knn(i,:)))/k;
    end
%     dis=A(PosiNum+1:end,1:PosiNum);
%     dis1=mean(dis,2);
    save cost cost ;
end