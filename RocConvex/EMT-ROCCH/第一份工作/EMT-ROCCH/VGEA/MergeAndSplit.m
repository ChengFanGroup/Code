function [pop, fit, g] = MergeAndSplit(pop, fit, g, popNum, data, label)
	featNum = size(data, 2);
	x = group2x(g, pop, featNum);

	[m, n] = size(pop);
	num = 1;
	t3 = 1 : n;
	if t3
		for i = t3
			n1 = numel(g{i});
			if n1 < 2
				g2{num} = g{i};
				num = num + 1;
			else
				n2 = floor(n1 / 2);
				gt = g{i};
				g2{num} = gt(1 : n2);
				g2{num + 1} = gt(n2 + 1 : n1);
				num = num + 2;
			end
		end
	end
	g = g2;
	pop = x2group(g, x);
end