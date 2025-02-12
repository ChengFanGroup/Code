function pop2 = GA2(p1, p2, ia1, ia2, p)
	proC = 0.9;
	proM = 1;

	[m, n] = size(p1);

	%% crossover
	np1 = p1 & p2;
	np2 = xor(p1, p2);
	np3 = zeros(m, n);
	% t = rand(m / 2, n) > rand();
	t = randi(n, m, n) > randi(n, m, 1);
	np3(t) = np2(t);
	np4 = xor(np2, np3);

	np3 = np1 | np3;
	np4 = np1 | np4;
	k = rand(m,1) > proC;
	np3(k, :) = p1(k, :);
	np4(k, :) = p2(k, :);
	pop2 = [np3; np4];

	%% mutation
	tt = zeros(size(p1));
	tt(ia1, :) = tt(ia1, :) | p1(ia1, :);
	tt(ia2, :) = tt(ia2, :) | p2(ia2, :);
	tt = [and(tt, xor(np1, np3)); and(tt,xor(np1, np4))];
	tt = 1 / n + tt .* p;
	% 	tt = 1 / n;
	t = rand(size(pop2)) < tt;
	pop2 = xor(pop2, t);

end