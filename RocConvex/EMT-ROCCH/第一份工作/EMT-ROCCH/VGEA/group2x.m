function x = group2x(g, pop, featNum)
	%% map group to full feature space
	x = zeros(size(pop, 1), featNum);
	for i = 1 : size(pop, 1)
		for j = 1 : size(g, 2)
			x(i, g{j}) = pop(i, j);
		end
	end
end