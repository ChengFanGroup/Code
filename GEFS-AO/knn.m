function [er,fm] = knn(data, label, X)
%% Calculate Objective Values

	X = X > 0;

	m = size(X, 1);
	fit = zeros(m, 2);
	for i = 1 : m
		fit(i, :) = KNN(data, label, X(i, :));
	end
	er =fit(:,1);
    fm =fit(:,2);
end

function fit = KNN(data, label, X)
% LOOCV
% KNN, k = 1
    if sum(X) == 0
        fit = [1, size(data, 2)];
        return;
    end
    res = find(X==1);
    data = data(:,res );
    dist = pdist2(data, data);
    [~, idx] = min(dist + eye(size(data, 1)) * max(max(dist) * 2), [], 2);
    y = label(idx);
    y = y == label;
    acc = sum(y) / numel(y);
    err = 1 - acc;
    fit = [err, length(res)];

end