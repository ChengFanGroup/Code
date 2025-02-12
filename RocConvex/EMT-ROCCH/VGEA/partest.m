clc;
clear;
close all;

addpath(genpath(cd));

% dataNames = {'gse72526', 'SRBCT', 'GLIOMA',  'Leukemia1',  'DLBCL', '9Tumor',  'Brain1',...
%     'Carcinom', 'Brain2', 'prostate', 'CLLSUB', 'Leukemia2',  '11Tumor', 'Lung', 'SMKCAN187', 'gse19804'};
dataNames = {'ORL', 'colon', 'SRBCT', 'lymphoma', 'GLIOMA',  'Leukemia1',  'DLBCL', '9Tumor',  'TOX_171',  'Brain1',...
    'leukemia', 'ALLAML', 'Carcinom',  'arcene', 'Brain2', 'prostate', 'CLL_SUB_111', 'Leukemia2',  '11Tumor', 'Lung',...
    'SMK_CAN_187', 'gse19804', 'GLI_85'};
% dataNames = {'drivface', 'RELATHE',  'COIL20', 'Isolet', 'PCMAC', 'BASEHOCK'};
% dataNames = {'colon'};
% dataNames = {'SRBCT'};

k = 30;



parfor dataIdx = 1 : size(dataNames, 2)
    dataName = dataNames(dataIdx);
    
	disp(dataName);
	mkdir(strcat("result/", dataName{1}));

    dataset = load(['../dataset/', dataName{1}]);
    data = dataset.data;
    label = dataset.label;
	data = full(data);
	% normalize
	data = (data - min(data, [], 1)) ./ (max(data, [], 1) - min(data, [], 1));
	data(isnan(data)) = 0;

	[m, featNum] = size(data);

	% crossvalid
	indices = crossvalind('Kfold', m, k);

	accTrAvg = zeros(k, 1);
	accTrBest = zeros(k, 1);
	accTeAvg = zeros(k, 1);
	accTeBest = zeros(k, 1);
	selFeatNumAvg = zeros(k, 1);
	selFeatNumBest = zeros(k, 1);
	avgTime = zeros(k, 1);
	res = [];
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
		[x, accTr, selFeatNum] = VGEA(trainData, trainLabel, dataName{1}, i);
		%         [x, accTr, selFeatNum] = NSGAIIFS(trainData, trainLabel, dataName{1}, i);
		t2 = clock;
		toc;
		avgTime(i) = etime(t2, t1);

		acc = zeros(size(x, 1), 1);
		for j = 1 : size(x, 1)
			acc(j) = testAcc(trainData, trainLabel, testData, testLabel, x(j, :));
		end

		[~, idx] = min(accTr);
		accTrBest(i) = 1 - accTr(idx);
		accTrAvg(i) = 1 - mean(accTr);
		selFeatNumBest(i) = selFeatNum(idx);
		selFeatNumAvg(i) = mean(selFeatNum);
		accTeBest(i) = acc(idx);
		accTeAvg(i) = mean(acc);  

		frontRes = [accTr, 1 - acc, selFeatNum];
		csvwrite(strcat('result/', dataName{1}, '/', dataName{1}, '-', num2str(i), '-front.csv'), frontRes);
		res = [res;
			[i, accTrBest(i), accTeBest(i), selFeatNumBest(i), accTrAvg(i), accTeAvg(i), selFeatNumAvg(i), avgTime(i)]];
	end

	avgAccTr1 = mean(accTrAvg);
	avgAccTe1 = mean(accTeAvg);
	avgSelFeatNum1 = mean(selFeatNumAvg);
	avgAccTr2 = mean(accTrBest);
	avgAccTe2 = mean(accTeBest);
	avgSelFeatNum2 = mean(selFeatNumBest);
	avgTime = mean(avgTime);

	res = [res;
	[233, avgAccTr2, avgAccTe2, avgSelFeatNum2, avgAccTr1, avgAccTe1, avgSelFeatNum1, avgTime]];
	csvwrite(['result/', dataName{1},  '.csv'], res);
end