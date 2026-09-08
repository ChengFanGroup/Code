function indices = crossvalind(method, n, k)
%CROSSVALIND Lightweight K-fold replacement used by this project.
%   indices = crossvalind('Kfold', n, k) returns fold numbers 1..k.

if ~strcmpi(method, 'Kfold')
    error('crossvalind:UnsupportedMethod', 'Only Kfold is supported.');
end

order = randperm(n);
indices = zeros(n, 1);
folds = mod(0:n-1, k) + 1;
indices(order) = folds;
end
