function [Pop, Obj] = DAEA_main(traindata, trainlabel)

global Global
global selected
global selected_half

selected = [];
selected_half = [];

Global = struct();

% read samples from dataset
% filePath = 'D:\kanezxk\MyProgram\EA\0_Public\formatDataSet\';
% fileName = [datasetName '.csv'];
% samples = csvread([filePath,fileName]);
% label = samples(:, end);
% samples = samples(:, 1:end-1);
% % normalization
% mean_of_dimension = repmat(mean(samples), size(samples, 1), 1);
% std_deviation = repmat(std(samples, 1), size(samples, 1), 1);
% samples = (samples - mean_of_dimension) ./ std_deviation;
% datasetName = 'Brain1';
% [samples, label] = data_process(dataset);
samples = [traindata, trainlabel];

% parameters setting
Global.samples = samples;
Global.D = size(samples, 2) - 1;
Global.N = 100;
Global.evals = 0;
Global.maxEvals =  50 * Global.N;
% Global.CalObj = @EvalFunc;

% knn parameters
% knnArgs = struct();
% knnArgs.knearest = 3;
% knnArgs.trainR = 0.7;
% knnArgs.CVs = 10;
% Global.knnArgs = knnArgs;

% run DAEA algorithm
Pop = DAEA();
% folder=['D:\code\Matlab\DAEA\new_result\resulthv\',char(dataset)]; %%定义变量
% if exist(folder) == 0 %%判断文件夹是否存在
%     mkdir(folder);
% end

Obj = Pop(:, Global.D+1:Global.D+2);
Pop = Pop(:, 1:Global.D);



% save the last population
% if ~exist('pop_obj','dir')
%    mkdir('pop_obj')
% end
% save(['./pop_obj/' datasetName '_Pop.mat'], 'Pop')
%save(['./pop_obj/' datasetName '_Obj.mat'], 'Obj')

% save selected ratio
% save('./selected_ratio', 'selected')
% save('./selected_ratio_half', 'selected_half')

% non-dominated solutions only
% [first, ~] = NDSort(Obj, Global.N);
% obj = Obj(first==1, :);

% plot
% figure(1);
% scatter(obj(:, 1), obj(:, 2), 36, [0 1 1], 'filled');
% hold on;


end
