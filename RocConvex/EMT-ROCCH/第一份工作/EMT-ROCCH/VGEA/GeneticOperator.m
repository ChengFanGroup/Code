function pop2 = GeneticOperator(parent, isArchive, p)
	%% crossover and mutation
	[m, n] = size(parent);
	p1 = parent(1 : m / 2, :);
	p2 = parent(m / 2 + 1 : m, :);


	ia1 = isArchive(1 : m / 2);
	ia2 = isArchive(m / 2 + 1 : m);
	t = ia1 | ia2;
	pop2 = [
		GA1(p1(~t, :), p2(~t, :));
		GA2(p1(t, :), p2(t, :), ia1(t), ia2(t), p)
	];
end