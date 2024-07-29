classdef Generator<handle
    %GENERATOR used to generate subspaces

    properties
        featureNum
        probabilityVector
        generateKernel = 1
        declineFactor = 1
        minGenSearchSpaceSize = 10
        evaluator
        oldProbabilityVector = []
    end
    
    methods
        function obj = Generator(featureNum,initThreshold)
            %GENERATOR 构造此类的实例
            % featureNum:       the feature size of the feature selection problem
            % InitThreshold:    the initial probability value of each feature being selected
            obj.featureNum = featureNum;
            obj.probabilityVector = ones(obj.generateKernel,featureNum)*initThreshold;
        end
        
        function newSearchSpace = getNewSearchSpace(obj,getNum)
            %getNewSearchSpace 根据生成器生成新搜索空间
            %   此处显示详细说明
            newSearchSpace = rand(getNum,obj.featureNum)< obj.probabilityVector;

            flag = sum(newSearchSpace,2) < obj.minGenSearchSpaceSize;
            if any(flag)
                [~,index] = sort(obj.probabilityVector,'descend');
                newSearchSpace(flag,index(1:obj.minGenSearchSpaceSize)) = 1;
            end
            disp('-------------Generating a batch of subspaces! Their feature size are followed!-------------------------')
            disp(sum(newSearchSpace,2)')

        end

        function BatchUpdate(obj,searchSpace,pop,archive,popInfo,excInfo,excIndex)

            searchSpaceNum = numel(pop);
            %% Get searchspace Situation
            [subspaceScore,excScore,excNumPro] = obj.evaluator.scoreSubpace(popInfo,excInfo,excIndex);
            subspaceUpdateInfo = searchSpace.*subspaceScore;
            
            excUpdateInfo = zeros(searchSpaceNum,obj.featureNum);
            for i = find(excNumPro>0)'
                 excUpdateInfo(i,:) = (mean(pop{i}(excIndex{i},:),1))*excScore(i);
            end   

            %% update
            obj.probabilityVector = obj.probabilityVector + mapminmax(sum(subspaceUpdateInfo,1),0,1);
            obj.probabilityVector = obj.probabilityVector + mapminmax(sum(excUpdateInfo,1),0,1);         
            obj.probabilityVector = obj.probabilityVector + mapminmax(sum(archive.pop,1),0,1);

            obj.probabilityVector = mapminmax(obj.probabilityVector,0,1);      
        end

    end
end 

