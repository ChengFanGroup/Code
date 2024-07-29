clear
clc
tic
%% 超参数
runNum = 30;

dataNames = {'TOX_171'};

for dataIndex = 1:numel(dataNames)
    %% 数据集加载,预处理
    dataName = dataNames{dataIndex};
    load(['./' dataName]);                                                                                                                                                                                                                                                                                                                                                                                                                                                                  

    data = mapminmax(data',0,1)';
    data(isnan(data)) = 0;
    [insNum, featureNum] = size(data);

      for runIndex = 1:runNum
        testIdx = randperm(insNum) > 0.7 * insNum;
        trainIdx = ~testIdx;
        testData = data(testIdx, :);
        testLabel = label(testIdx, :);
        trainData = data(trainIdx, :);
        trainLabel = label(trainIdx, :);
		
        tic;
	t1 = clock;
        [solution,trainFitness] = AEA_HDFS(trainData,trainLabel);
        errTr = trainFitness(:,1);
        selFeatNum = trainFitness(:,2);  
        t2 = clock;
	toc;
        time = etime(t2, t1);

	accTr = 1 - errTr;

	save(strcat('result-', dataName{1}, '-', num2str(i)), 'x', 'errTr', 'selFeatNum', 'accTr', 'time');
      end

end
