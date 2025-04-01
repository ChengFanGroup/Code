function [traindata, trainlabel, testdata, testlabel] = data_process(dataset)
%% normlization
% dataset = 
load (['D:/dataset/FS_DATASET/FS_DATASET_MAT/',dataset,'.mat']);

maxV = max(data);
minV = min(data);
range = maxV-minV;
len = size(data,1);
newdataMat = (data-repmat(minV,[len,1]))./(repmat(range,[len,1]));

%% randomly divide dataset to 30% testdata and 70% traindata 
index = crossvalind('Kfold', label, 10);
temp_te = find(index == 1 | index == 2 | index == 3);
testdata = newdataMat(temp_te, :);
testlabel = label(temp_te, :);
temp_tr = find(index ~= 1 & index ~= 2 & index ~= 3);
traindata = newdataMat(temp_tr, :);
trainlabel = label(temp_tr, :);

%% ten-fold crossvalid one-fold for test
% index = crossvalind('Kfold', label, 10);
% temp_te = find(index == 1);
% testdata = newdataMat(temp_te, :);
% testlabel = label(temp_te, :);
% temp_tr = find(index ~= 1);
% traindata = newdataMat(temp_tr, :);
% trainlabel = label(temp_tr, :);
end