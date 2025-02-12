clear;
clc;

filepath = '.\dataset'; %数据集所在的文件夹
%此处目录要修改
AllDataSet = dir(fullfile(filepath, '*.mat'));
for k= 1 : 10%length(AllDataSet) %读每个数据集%10和11两个数据集有问题
    DataSetName =  AllDataSet(k).name; %提取每个数据集的name字段，数据集的名称
%     DataSet=cell2mat(struct2cell(load(DataSetName))); %读取数据集并转为矩阵形式保存在DataSet中
    load(strcat(DataSetName));
   
    
    


for i=1:5
    %寻找U中最好的精度
      u=uacc(i).u(:,1:3);
      paccpf=u(:,1);
      naccpf=u(:,2);
      acc=u(:,3).*100;
      index=find(acc==max(acc));
%       index1=find(naccpf(index)==max(naccpf(index)));
%       index2=find(paccpf(index(index1))==max(paccpf(index(index1))));
%       index3=index(index1(index2));

      
       nacc(i)=mean(naccpf(index));
       pacc(i)=mean(paccpf(index));
       cacc(i)=acc(index(1));
    %计算测试集的AUC
%     test=auc(i).a(:,1);
%     uauc=auc(i).a(:,2);
%     index1=find(test==max(test));
%     index2=find(uauc==max(uauc));
%     testauc(i)=test(index1(1));
%     Uaucc(i)=uauc(index2(1));
end
%做秩和检验的数据
% cacc=cacc.*0.01;
% temp=roundn(cacc,-3);
% Uacc1(k,:)=temp;
%五折平均，论文中的数据
%   apacc=[mean(pacc),std(pacc)];
%   bnacc=[mean(nacc),std(nacc)];
  avg=mean(cacc);
  std=std(cacc);
  save('F:\代码\_MOPUL\Code\MO-PUL\datasetname', 'cacc','avg','std');

  b=[apacc',bnacc',cacc'];
  a=roundn(b,-3);
  %xlswrite('UUU',a);
%  输出AUC
%   aauc=[mean(testauc),std(testauc)];
%   bauc=[mean(Uaucc),std(Uaucc)];
%   b=[aauc',bauc'];
%   a=roundn(b,-3);
%   xlswrite('AUC',a);


end