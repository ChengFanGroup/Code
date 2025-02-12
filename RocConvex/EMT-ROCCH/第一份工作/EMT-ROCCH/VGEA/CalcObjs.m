function fit = CalcObjs(data, label, X)
%% Calculate Objective Values

	X = X > 0;

	m = size(X, 1);
	fit = zeros(m, 2);
	for i = 1 : m
		fit(i, :) = KNN(data, label, X(i, :));
	end
end