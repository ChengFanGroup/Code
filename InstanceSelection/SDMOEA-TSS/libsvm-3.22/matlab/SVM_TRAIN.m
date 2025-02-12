tic;
clear;clc;
% load 'train_feature.mat';
% load 'train_predict.mat';
% load 'test_feature.mat';
% load 'test_predict.mat';
load 'V3Libras.mat';
train_feature = V3Libras(1:200,1:90);
train_predict = V3Libras(1:200,91);
test_feature = sparse(V3Libras(201:end,1:90));
test_predict = V3Libras(201:end,91);
% train_feature = sparse(feature(1:int32(length(feature)*0.7),:));
% train_predict = label(:,1:int32(length(label)*0.7));
% test_feature =sparse(feature(int32(length(feature)*0.7:length(feature)),:));
% test_predict =  label(1,int32(length(label)*0.7:length(label)));
model = svmtrain(train_predict, train_feature);
 [predict_label, accuracy, dec_values] = predict(test_predict, test_feature, model);
 
% plot(x,y,'o');
% hold on;
% plot(x,py,'r*');
% legend('原始数据','回归数据');
% grid on;
 
 toc;