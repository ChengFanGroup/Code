classdef Evaluator<handle
    %Evaluator used to evaluate subspaces
    
    properties
        % search space fit
        searchSpaceErr
        seacrhSpaceScale
        % elite fit
        individualErr
        individualScale
        % feature combination
        oldsearchspace = [];
        oldsearchSpaceState = [];
    end
    
    methods

        function obj = Evaluator(searchSpaceErr,seacrhSpaceScale,individualErr,individualScale)
            obj.searchSpaceErr = searchSpaceErr;
            obj.seacrhSpaceScale = seacrhSpaceScale;
            obj.individualErr = individualErr;
            obj.individualScale = individualScale;

            obj.oldsearchspace = [];
            obj.oldsearchSpaceState = [];
        end

        function [popScore,excScore,excNumPro] = scoreSubpace(obj,popInfo,excInfo,excIndex)
            excNumPro = sum(horzcat(excIndex{:})',2) ./ size(excIndex{1},1);
            popScore = ([obj.searchSpaceErr,obj.seacrhSpaceScale] - popInfo) ./ ([obj.searchSpaceErr,obj.seacrhSpaceScale] + 1e-9);
            popScore = [popScore];
            popScore = exp(popScore);

            excScore = ([obj.individualErr,obj.individualScale] - excInfo) ./ ([obj.individualErr,obj.individualScale] + 1e-9);
            excScore = [excScore,excNumPro];
            excScore = exp(excScore);

            popScore = prod([(popScore),popScore(:,1)>=0],2);
            excScore = prod([(excScore),excScore(:,1)>=0],2);
        end
        

        function [popBasedInfo,excBasedInfo,eliteIndex] = getSubspaceState(obj,fitness,searchSpace)
            
            searchSpaceNum = size(searchSpace,1);
            objectNum = size(fitness{1},2);
            popBasedInfo = ones(searchSpaceNum,objectNum);
            excBasedInfo = ones(searchSpaceNum,objectNum); 
            eliteIndex = cell(1,searchSpaceNum);
           
            % acculamate
            for i = 1:searchSpaceNum
                popBasedInfo(i,:) = mean(fitness{i},1);
                eliteIndex{i} = all(fitness{i}<=[obj.individualErr,obj.individualScale],2);
                excBasedInfo(i,:) = mean(fitness{i}(eliteIndex{i},:),1);       
            end
            % record
            obj.oldsearchspace = [obj.oldsearchspace;searchSpace];
            obj.oldsearchSpaceState = [obj.oldsearchSpaceState;popBasedInfo];
        end
       

        function BatchUpdateEvaluator(obj,popBasedInfo,excBasedInfo)
            % update
            [obj.searchSpaceErr,obj.seacrhSpaceScale] = obj.batchUpdateEV(popBasedInfo,[obj.searchSpaceErr,obj.seacrhSpaceScale]);
            [obj.individualErr,obj.individualScale] = obj.batchUpdateEV(excBasedInfo,[obj.individualErr,obj.individualScale]);
        end
        
        function [err,scale] = batchUpdateEV(~,batchInfo,base)
            grad = base - batchInfo;
            res = mean(grad(all(grad>0,2),:),1);
            res(isnan(res)) = 0;
            err = base(1) - res(1);
            scale = base(2) - res(2);
        end
        
        function [err,scale] = batchUpdateDVMax(~,batchInfo,base)
            grad = base - batchInfo;
            res = max(grad(all(grad>0,2),:),1);
            if size(res,1)
                err = base(1);
                scale = base(2);
            else
                err = base(1) - res(1)/2;
                scale = base(2) - res(2)/2;
            end
        end

            
    end
end

