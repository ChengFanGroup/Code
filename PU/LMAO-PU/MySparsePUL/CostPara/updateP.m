function  updateP


  load('FeatSub');  %FeatSub1 精度最高的解 FeatSub2 压缩率与精度的权衡解 FeatSub3 压缩率最高的解
  new2(:,FeatSub1>0.5)=1;
  new2(:,FeatSub1<=0.5)=0;
  load('Train'); 
  dataUN=new2.*dataUN;
  dataPositive=new2.*dataPositive; 
% 
%   % 使用欧氏距离作为相似度时更新cost的策略
%       for i=1:size(dataUN,1)
%         for j=1:size(dataPositive,1)
%             dis(i,j)= pdist2(dataUN(i,:),dataPositive(j,:),'euclidean');%example2是unlabelled
%         end
%       end
%     dis1=mean(dis,2);
% %     dis_norm=mapminmax(dis1',0,1)';
%     cost=mapminmax(dis1',0,1)';
% %     posibilty=1./dis_norm;

%使用KNN的方法作为相似度时更新cost的策略
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


    save cost cost;
  
  