function err = KNNLOOCV(data, label, X)
% LOOCV
% KNN, k = 1
    X = logical(X);
    if sum(X) == 0
        err = 1;
        return;
    end
    data = data(:, X);
    dist = pdist2(data, data);
    [~, idx] = min(dist + eye(size(data, 1)) * max(max(dist) * 2), [], 2);
    y = label(idx);
    y = y == label;
    acc = sum(y) / numel(y);
    err = 1 - acc;
end
