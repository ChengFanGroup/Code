function [er,fm,fit,featsub ]= fitnessLoov(particle,data,label,threshold,lambda)
%FITNESSFUN 此处显示有关此函数的摘要
global trData trLabel teData teLabel;
global  featNum kNeigh;

    net = zeros(1,size(particle.position,2));
    index = particle.position > threshold;
    net(index) = 1;
    indivNet = decodeNet(net);
    subset = selectsubset(indivNet);
    featsub = zeros(1,featNum);
    featsub(subset) = 1;
    if length(subset) == 0
        featsub = ones(1,featNum);
    end  

    X = featsub;
    data = data(:, (X>0));
    dist = pdist2(data, data);
    [~, idx] = min(dist + eye(size(data, 1)) * max(max(dist) * 2), [], 2);
    y = label(idx);
    y = y == label;
    acc = sum(y) / numel(y);
    err = 1 - acc;
    er= err;
    fm = sum(X);
    fit = lambda*err+(1-lambda)*sum(X)/featNum;
end

