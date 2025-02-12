%%SVM单一分类器%%论文对比算法，单纯的SVM
clc;
clear all;
addpath(genpath('D:\第一份工作代码部分\liblinear-1.95\matlab'));
DULInumber=10;    %独立实验次数
% load('E:\第一份工作\实验结果2.0\新数据集/breast.mat');
% %%  breast  dna  german  letter  mnist  pendigits  satimage  segment  shuttle  svmguide3  usps
% datasetsource = Xtr ;%instance Xtr
% whether = Ytr;%label Ytr
% X1=datasetsource;
% Y1=whether;

 [datasetsource,whether]=inputdataset(15);
whethersize=size(whether,2);
for i=1:whethersize
    if whether(1,i)==0
       whether(1,i)=-1;
    end
end
X1=datasetsource';
Y1=whether';

A=[Y1,X1];
[m, n]=size(A); %data为样本集合。每一行为一个观察样本 
indices = crossvalind('Kfold',m,5); %产生10个fold，即indices里有等比例的1-10 
DL=zeros(DULInumber,1);
for duli=1:DULInumber
    sumpauc=0;
    pauc=zeros(5,1);
    indices = crossvalind('Kfold',m,5); %产生10个fold，即indices里有等比例的1-10 
    for k=1:5
        test=(indices==k); %逻辑判断，每次循环选取一个fold作为测试集
        train1=~test; %取test的补集作为训练集，即剩下的9个fold
        X=X1(train1,:); %以上得到的数都为逻辑值，用与样本集的选取
        Y=Y1(train1,:); %label为样本类别标签，同样选取相应的训练集
        Xte=X1(test,:); %同理选取测试集的样本和标签
        Yte=Y1(test,:);
train_feature = sparse(X);
train_predict = Y;
test_feature =sparse(Xte);
test_predict = Yte;
long=2^(5);
long1=0.01;
model = train(train_predict, train_feature,['-c ' num2str(long)],['-eps ' num2str(long1)]);
 [predict_label, accuracy, dec_values] = predict(test_predict, test_feature, model);
  a = 0.1;
  b = 0.2;
    pauc(k)=my_paucpredict(Xte,Yte,a,b,model.w);
        sumpauc = sum(pauc);
        %     accuracy         =       length(find(predict_label == test_label))/length(test_label)*100;
    end
   DL(duli,1)= sumpauc/5;
end
fprintf('最后的结果为%f\n',sum(DL)/DULInumber);
fprintf('标准差为%f\n',std(DL));

 
