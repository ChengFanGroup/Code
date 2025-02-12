function Offspring = GA1(Parent1, Parent2)
	proC = 0.9;
	proM = 1;

	[N,D]   = size(Parent1);

	%% Genetic operators for binary encoding
	% One point crossover
	k = repmat(1:D,N,1) > repmat(randi(D,N,1),1,D);
	k(repmat(rand(N,1)>proC,1,D)) = false;
	Offspring1    = Parent1;
	Offspring2    = Parent2;
	Offspring1(k) = Parent2(k);
	Offspring2(k) = Parent1(k);
	Offspring     = [Offspring1;Offspring2];
	% Bitwise mutation
	Site = rand(2*N,D) < proM/D;
	Offspring(Site) = ~Offspring(Site);

end