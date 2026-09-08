function [dataset,labelset,name] = load_australian(filePath)
%LOAD_AUSTRALIAN 读取 Australian 二分类数据集。
% 文件每行包含 14 个特征和最后 1 个 0/1 标签。

if exist(filePath,'file') ~= 2
    error('SLGMOEA:MissingDataset','找不到数据集：%s',filePath);
end

raw = readmatrix(filePath,'FileType','text');
if size(raw,2) ~= 15 || any(~isfinite(raw),'all')
    error('SLGMOEA:InvalidDataset', ...
        'Australian 数据应包含14个特征列和1个标签列。');
end

dataset = raw(:,1:14)';
labelset = raw(:,15)';
if ~all(ismember(unique(labelset),[0 1]))
    error('SLGMOEA:InvalidLabels','标签必须是0或1。');
end
name = 'australian';
end
