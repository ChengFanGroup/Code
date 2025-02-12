function [Index_F]= FS_VGEA(datasettrain, whethertrain)
%FS_DAEA 此处显示有关此函数的摘要
%   此处显示详细说明
%     N = 100;
%     maxIteration = 100;
%     maxEvaluation = N * maxIteration;
%     varargin = {'-algorithm', @DAEA, '-problem', @FS, '-N', N, '-evaluation', maxEvaluation, '-run', 1};
%     Global = GLOBAL(varargin{:});
% 
%     Global.problem.SetTrainDataAndValidData(datasettrain, whethertrain, datasettest, whethertest);
%     Global.problem.SetDataName(name);
%     Global.Start();
%     Feasible = find(all(Global.result{end}.cons<=0,2));
%     NonDominated = NDSort(Global.result{end}(Feasible).objs,1) == 1;
%     NDPopulation  = Global.result{end}(Feasible(NonDominated));
%     
%     NDnum = size(NDPopulation,2);
%     NDobj = zeros(1,NDnum);
%     for i = 1 : NDnum
%         NDobj(i) = NDPopulation(1,i).obj(:,1);
%     end
%     [~,index] = sort(NDobj);
    [NDpop, NDobj] = VGEA(datasettrain, whethertrain);
    [~,index] = min(NDobj(:,1));
    solution= NDpop(index,:);
    Index_F = find(solution==1);
end

