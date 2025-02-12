function pop2 = GeneticOperator2(parent, isArchive)
	%% crossover and mutation
	[m, n] = size(parent);
	p1 = parent(1 : m / 2, :);
	p2 = parent(m / 2 + 1 : m, :);

	pop2 = GA1(p1, p2);
end