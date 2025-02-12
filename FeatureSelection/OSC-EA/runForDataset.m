function runForDataset(dataName)
    addpath(genpath(pwd));
    % 装载数据
    disp(dataName)
    load(['../dataMat/' dataName]);
    
    % 数据初始化
    tic;
    data = mapminmax(data',0,1)';
    data(isnan(data)) = 0;
    [insNum, ~] = size(data);
    runNum = 30;
    
    % 生成文件夹
    resultdir = ['OSCEA/' dataName '/'];
    if ~exist(resultdir,'dir')
        mkdir(resultdir)
    end
    
    %运行
    for runIndex = 1:runNum
        rng(runIndex)
        disp(['run for:  ' dataName ' , RunIndex == ' int2str(runIndex) ' , time == ' int2str(toc)])
        testIdx = randperm(insNum) > 0.7 * insNum;
        trainIdx = ~testIdx;
        testData = data(testIdx, :);
        testLabel = label(testIdx, :);
        trainData = data(trainIdx, :);
        trainLabel = label(trainIdx, :);
		
        tic;
		t1 = clock;
        [solution, trainFitness, recordProcess] = OSCEA(trainData, trainLabel);
        t2 = clock;
		toc;
        runTime = etime(t2, t1);
        testError = testErr(testData, testLabel, trainData, trainLabel, solution);
        testFitness = [testError, trainFitness(:, 2)];
        [FrontNo, ~] = NDSort(testFitness, size(testFitness, 1));
        ParetoAverError = mean(testFitness(FrontNo == 1, 1));
        ParetoAverAcc = 1 - ParetoAverError;
        ParetoAverSize = floor(mean(testFitness(FrontNo == 1, 2)));
        MCER = min(testFitness(FrontNo == 1, 1));
        save([resultdir num2str(runIndex)],'trainFitness','testError', 'testFitness', 'ParetoAverError', 'ParetoAverAcc', 'ParetoAverSize', 'MCER', 'runTime','recordProcess');

    end
    % exit()

end