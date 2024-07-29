function [solution,fit,recordProcess,evaluateReocrd] = AEA_HDFS(trainData,trainLabel)
%AEA_HDFS dversarial Evolutionary Algorithm for High-Dimensional Feature Selection
    [~, featureNum] = size(trainData);

    %% Hyperparameter settings
    maxEvaluate = 10000;
    evalPopNum = 100;
    threshold = 0.6;
    samplingSubSpaceNum = 1;
    finalPopNum = samplingSubSpaceNum*evalPopNum;

    archiveNum = 20;
    generatorInitThreshold = 0.5;
    evaluatorEvolutionaryEpoch = 4;
    adversialRound = 15;
    
    %% Record Infomation
    Record.recordProcess = {};
    Record.evaluateReocrd = [];

    global evaluateTime;
    evaluateTime = 0;
    
    %% Initialization

    % Initialize Archive
    archive.pop = [];
    archive.fit = [];
    archive.num = archiveNum;

    Subspaces.spaceSize = featureNum;
    Subspaces.popSize = evalPopNum;
    Subspaces.initTheta = threshold;


    % Initialize Generator
    generator = Generator(featureNum,generatorInitThreshold);

    % Initialize Evaluator
    meanFit = mean(LOOCV_KNN(trainData,trainLabel,rand(evalPopNum,featureNum)>threshold),1);
    evaluator = Evaluator(meanFit(1),meanFit(2),meanFit(1),meanFit(2));
    
    % Binding evaluator to generator 
    generator.evaluator = evaluator;
        
    %% Start Generator VS Evaluator, and evolutionary search
    for r = 1:adversialRound

        % Initialize searchSpace and evaluate them
        Subspaces.spaces = generator.getNewSearchSpace(samplingSubSpaceNum);
        Subspaces.subspaceSize = sum(Subspaces.spaces,2);
        
        Subspaces.pop = InitPop(Subspaces.spaces,Subspaces.subspaceSize,Subspaces.popSize,Subspaces.spaceSize,Subspaces.initTheta);
        for i = 1:samplingSubSpaceNum
            Subspaces.fit{i} = LOOCV_KNN(trainData,trainLabel,Subspaces.pop{i});
        end
        % Record data
        Record = RecordOnce(Record,vertcat(Subspaces.pop{:}),vertcat(Subspaces.fit{:}));
            
        %% Evolutionary search subspaces 
        for epoch = 1:evaluatorEvolutionaryEpoch
            % Get new population
            newPop = GetNewPop(Subspaces.pop,Subspaces.fit,Subspaces.spaces);

            % Evaluate newpop
            newFitness = cell(1,samplingSubSpaceNum);
            for i = 1:samplingSubSpaceNum
                newFitness{i} = LOOCV_KNN(trainData,trainLabel,newPop{i});
            end
            % Environment selection
            [Subspaces.pop,Subspaces.fit] = FilterNextPop(Subspaces.pop,newPop,Subspaces.fit,newFitness,1);
            
            % Record data
            Record = RecordOnce(Record,vertcat(Subspaces.pop{:}),vertcat(Subspaces.fit{:}));
        end

        %% Update Discriminator and Generator
        % archive and retain unique individuals
        archivePop = vertcat(archive.pop,Subspaces.pop{:});
        archiveFit = vertcat(archive.fit,Subspaces.fit{:});                  
        
        % archive top archive.num individuals, Error first
        [~,index] = sortrows(archiveFit);
        archive.pop = archivePop(index(1:archive.num),:);
        archive.fit = archiveFit(index(1:archive.num),:);

        % get searching subspace situation
        [Subspaces.popInfo,Subspaces.excInfo,Subspaces.excIndex] = evaluator.getSubspaceState(Subspaces.fit,Subspaces.spaces);
        
        % update Genenrator
        generator.BatchUpdate(Subspaces.spaces,Subspaces.pop,archive,Subspaces.popInfo,Subspaces.excInfo,Subspaces.excIndex);

        % update Evaluator
        evaluator.BatchUpdateEvaluator(Subspaces.popInfo,Subspaces.excInfo);
    end

%% Form the final subspace
    voteNum = 10;
    genSearchSpace = generator.getNewSearchSpace(voteNum);
    [~,index] = sortrows(evaluator.oldsearchSpaceState);
    finSearchSpace = (sum(genSearchSpace(1:voteNum,:),1)>=(voteNum/2)) | (sum(evaluator.oldsearchspace(index(1:voteNum),:),1)>=(voteNum/2));

    % if searchSpace too small, do simple fix
    if sum(finSearchSpace) < 30
        [~,index] = sort(generator.probabilityVector,'descend');
        finSearchSpace(index(1:30)) = 1;
    end

    disp(['Final Search, Final Subspace size: ' num2str(sum(finSearchSpace))])
    pop = {};
    pop{1} = zeros(finalPopNum,featureNum);
    pop{1}(:,finSearchSpace) = rand(finalPopNum,sum(finSearchSpace,2)) > threshold;
    fitness = {LOOCV_KNN(trainData,trainLabel,pop{1})};
    
    % Record data
    Record = RecordOnce(Record,vertcat(pop{1}),vertcat(fitness{1}));

    %% phase 2 Evolutionary search subspaces 
    while(evaluateTime<maxEvaluate)
        % Get new population
        newPop = GetNewPop(pop,fitness,finSearchSpace);
        % Evaluate them 
        newFitness = {LOOCV_KNN(trainData,trainLabel,newPop{1})};

        % Environment selection
        [pop,fitness] = FilterNextPop(pop,newPop,fitness,newFitness,1);
        % Record data
        Record = RecordOnce(Record,vertcat(pop{1}),vertcat(fitness{1}));
    end
    
    %% return potential solutions
    pop = pop{1};
    fitness = fitness{1};
    
    % potential solutions
    index = NDSort(fitness,1) ==1 | fitness(:,1)'==min(fitness(:,1));
    solution = pop(index,:);
    fit = fitness(index,:);

    [~,idx] = unique(solution,'rows');
    solution = solution(idx,:);
    fit = fit(idx,:);
    recordProcess = Record.recordProcess;
    evaluateReocrd = Record.evaluateReocrd;   
end

function Record = RecordOnce(Record,pop,fitness)
%% Record pareto solutions according to fitness
    global evaluateTime;
    idx = NDSort(fitness,1)==1; 
    pop = pop(idx,:);
    fitness = fitness(idx,:);
    [~,idx] = unique(pop,'rows');
    Record.recordProcess{end+1} = fitness(idx,:);
    Record.evaluateReocrd(end+1,1) = evaluateTime;
end



