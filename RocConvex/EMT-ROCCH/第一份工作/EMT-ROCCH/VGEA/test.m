clc;
clear;
close all;

addpath(genpath(cd));

% dataNames = {'gse72526', 'SRBCT', 'GLIOMA',  'Leukemia1',  'DLBCL', '9Tumor',  'Brain1',...
%     'Carcinom', 'Brain2', 'prostate', 'CLLSUB', 'Leukemia2',  '11Tumor', 'Lung', 'SMKCAN187', 'gse19804'};
% dataNames = {'ORL', 'SRBCT', 'lymphoma', '9Tumor',  'TOX_171', 'ALLAML', 'Carcinom', ...
% 	'arcene', 'Leukemia2', 'Lung', 'gse19804', 'GLI_85'};
% dataNames = {'drivface', 'RELATHE',  'COIL20', 'Isolet', 'PCMAC', 'BASEHOCK'};
% dataNames = {'colon'};
% dataNames = {'SRBCT'};
% dataNames = {'ORL', 'colon', 'SRBCT', 'lymphoma', 'GLIOMA',  'Leukemia1',  'DLBCL', '9Tumor',  'TOX_171',  'Brain1',...
%     'leukemia', 'ALLAML', 'Carcinom',  'arcene', 'Brain2', 'prostate', 'CLL_SUB_111', 'Leukemia2',  '11Tumor', 'Lung',...
%     'SMK_CAN_187', 'gse19804', 'GLI_85',...
% 	'drivface', 'RELATHE',  'COIL20', 'Isolet', 'PCMAC', 'BASEHOCK'};
dataNames = {'lymphoma'};
% dataNames = {'colon','Lung','Leukemia1','DLBCL', 'Brain1', 'Prostate_GE','Leukemia','Leukemia2','Brain2','Leukemia3','11Tumor','Lung_Cancer'};
% dataNames = {'ORL','SRBCT', 'lymphoma', 'GLIOMA',  '9Tumor',  'TOX_171',  ...
%     'Carcinom',  'arcene','prostate', 'CLL_SUB_111',...
%     'SMK_CAN_187', 'dexter', 'GLI_85','GLA_BRA_180'};
k = 30; 

a = 0;
for dataName = dataNames
    a = a + 1;
	disp(dataName);
	folder=['D:/code/Matlab/VGEA/new_result/result2/',dataName{1}]; %%定义变量
if exist(folder) == 0 %%判断文件夹是否存在
    mkdir(folder);
end
fid=fopen(['D:\code\Matlab\VGEA\new_result\result2\',dataName{1},'.csv'],'a');
	load(['D:\code\dataset\', dataName{1}]);
	data = full(data);
	% normalize
	data = (data - min(data, [], 1)) ./ (max(data, [], 1) - min(data, [], 1));
	data(isnan(data)) = 0;

	[m, featNum] = size(data);

	% crossvalid
	indices = crossvalind('Kfold', m, k);

	accTr = zeros(k, 1);
    accTe = zeros(k, 1);
    s = zeros(k, 1);
    
	for i = 1 : k
		disp(['K Fold ', int2str(i)]);
		% crossvalid
		%     testIdx = indices == i;
		% 70% for training, 30% for testing
		testIdx = randperm(m) > 0.7 * m;
		%     testIdx = (indices == 1 | indices == 2 | indices == 3);
		trainIdx = ~testIdx;
		testData = data(testIdx, :);
		testLabel = label(testIdx, :);
		trainData = data(trainIdx, :);
		trainLabel = label(trainIdx, :);

		tic;
		t1 = clock;
		[x, allTr, selFeatNum] = VGEA(trainData, trainLabel, dataName{1}, i);
        obj = [selFeatNum/featNum,allTr];
%         scatter(obj(:,1),obj(:,2),24,'r','filled');
        [PF,~] = nondominated_sort(obj,size(obj,1));
        x = x(PF == 1,:);
        allTr = allTr(PF == 1,:);
        selFeatNum = selFeatNum(PF == 1,:);
%         obj = [selFeatNum/featNum,allTr];
%         scatter(obj(:,1),obj(:,2),24,'r','filled');
		t2 = clock;
		toc;
		avgTime(i) = etime(t2, t1);
%         accTr(i) = min(allTr);
		acc = zeros(size(x, 1), 1);
		for j = 1 : size(x, 1)
			acc(j) = testAcc(trainData, trainLabel, testData, testLabel, x(j, :));
        end
        [accTe(i), testID] = max(acc);
        s(i) = sum(x(testID,:));
        accTr(i) = allTr(testID);

tobj = [selFeatNum/size(data,2),1 - acc];
obj = [selFeatNum/size(data,2),allTr];
saveobj = ['VGEA' '-' dataName{1} '-obj-' char(string(i))]; 
save(['D:/code/Matlab/VGEA/new_result/result2/',dataName{1},'\',saveobj],'obj');
saveobj = ['VGEA' '-' dataName{1} '-obj-test-' char(string(i))]; 
save(['D:/code/Matlab/VGEA/new_result/result2/',dataName{1},'\',saveobj],'tobj');
fprintf(fid,'%d,%f,%f,%f,%f\n',i,1-accTr(i),accTe(i),s(i),avgTime(i));

end
fprintf(fid,'%s,%f,%f,%f,%f\n','mean',1-mean(accTr),mean(accTe),mean(s),mean(avgTime));
fclose(fid);
VG(a, :) = [1 - mean(accTr),mean(accTe), std(accTr),std(accTe),mean(s),mean(avgTime)];
end
