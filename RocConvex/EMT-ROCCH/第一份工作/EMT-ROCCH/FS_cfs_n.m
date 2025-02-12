function Index_F = FS_cfs_n(X,rate)

index = size(X,2);
Index_F = randperm (index,ceil(rate *index));
Index_F = sort(Index_F);
end
