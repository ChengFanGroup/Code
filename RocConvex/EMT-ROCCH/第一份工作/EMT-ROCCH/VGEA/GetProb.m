function x2 = GetProb(g, x)
	popNum = size(x, 1);
	groupNum = numel(g);

	x2 = zeros(popNum, groupNum);
	for i = 1 : popNum
		for j = 1 : groupNum
			x2(i, j) = mean(x(i, g{j}));
		end
	end

end