function [archive, archiveObjs] = UpdateArchive(pop, fit, archive, archiveObjs, archiveNum)

	[FrontNo, ~] = NDSort(fit,size(fit, 1));
	idx = min(fit(:, 1)) == fit(:, 1);
	idx = idx | FrontNo' == 1;
	archive = [archive; pop(idx, :)];
	archiveObjs = [archiveObjs; fit(idx, :)];
	
	[FrontNo, ~] = NDSort(archiveObjs,size(archiveObjs, 1));
	Front1 =  FrontNo' == 1;
	idx = min(archiveObjs(:, 1)) == archiveObjs(:, 1);
	idx = idx & ~Front1;
	
	Front1 = find(Front1);
	idx = find(idx);
	
	if numel(Front1) + numel(idx) > archiveNum
		idx = idx(randperm(numel(idx), archiveNum - numel(Front1)));
	end
	
	idx = union(Front1, idx);
	archive = archive(idx, :);
	archiveObjs = archiveObjs(idx, :);
	

	[archive, archiveObjs] = duplicate(archive, archiveObjs);
end