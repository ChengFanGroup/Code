function [pfs, pf] = VGEA(data, label)
	%% record result
	imd = [];
	imd2 = [];
	%% Init
	featNum = size(data, 2);

	maxIt = 30;
	maxIt2 = 10;
	popNum = 100;
	archiveNum = popNum;

	archive = [];
	archiveObjs = [];

	groupNum = round(10 * log2(featNum));
	firstStageEnd = maxIt2 * floor(log2(featNum / groupNum) + 1);
 
	% group
	[info, r] = SortFeature(data, label);
	idx = kmeans(info, groupNum);
	idx = idx';
	for i = 1 : groupNum
		g{i} = find(idx == i)';
	end
	% Init pop
	pop = rand(popNum, groupNum) > 0.5;
	p = r ./ featNum;

	% map group space to full features space
	x = group2x(g, pop, featNum);
	objs = CalcObjs(data, label, x);
	[archive, archiveObjs] = UpdateArchive(x, objs, archive, archiveObjs, archiveNum);

	imd = [imd; mean(objs, 1)];
	imd2 = [imd2; [repelem(1, size(objs, 1), 1), objs]];

	%% Iteration
	it = 2;
	while it <= maxIt
		for it2 = 1 : maxIt2
			interPop = [pop; x2group(g, archive)];
			MatingPool = randi(size(interPop, 1), 1, popNum);
			pop2 = GeneticOperator(interPop(MatingPool, :), MatingPool > size(pop, 1), GetProb(g, p));

			x = group2x(g, pop2, featNum);
			objs2 = CalcObjs(data, label, x);
			[archive, archiveObjs] = UpdateArchive(x, objs2, archive, archiveObjs, archiveNum);
			[pop, objs] = EnvironmentalSelection([pop; pop2],  [objs; objs2], popNum); 

			%disp(strcat("VGEA on ", dataName, " Fold ", num2str(fold), " Iter ", num2str(it)));
			imd = [imd; mean(objs, 1)];
			imd2 = [imd2; [repelem(it, size(objs, 1), 1), objs]];
		it = it + 1;
		end

		if it > firstStageEnd
			x = group2x(g, pop, featNum);
			[archive, archiveObjs, imd, imd2] = NSGAII(x, objs, popNum, it, maxIt, data, label, imd, imd2,...
			archive, archiveObjs, archiveNum, r);
			it = inf;
		else
			% split
			[pop, objs, g] = MergeAndSplit(pop, objs, g, popNum, data, label);
		end
	end

% 	csvwrite(strcat('result/', dataName, '/', dataName, '-', num2str(fold), '-popavg.csv'), imd);
% 	csvwrite(strcat('result/', dataName, '/', dataName, '-', num2str(fold), '-popall.csv'), imd2);

	pf = archiveObjs;
	pfs = archive;
% 	accTr = pf(:, 1);
% 	selFeatNum = pf(:, 2);
end

function [archive, archiveObjs, imd, imd2] = NSGAII(pop, objs, popNum, it, maxIt, data, label, imd, imd2,...
	archive, archiveObjs, archiveNum, ~)

	while it <= maxIt
		interPop = [pop; archive];
		MatingPool = randi(size(interPop, 1), 1, popNum);
		pop2 = GeneticOperator2(interPop(MatingPool, :), MatingPool > size(pop, 1));

		objs2 = CalcObjs(data, label, pop2);
		[archive, archiveObjs] = UpdateArchive(pop2, objs2, archive, archiveObjs, archiveNum);
		[pop, objs] =  EnvironmentalSelection([pop; pop2],  [objs; objs2], popNum);

		%disp(strcat("VGEA ", " Iter ", num2str(it)));
		imd = [imd; mean(objs, 1)];		
		imd2 = [imd2; [repelem(it, size(objs, 1), 1), objs]];
		it = it + 1;
	end
end