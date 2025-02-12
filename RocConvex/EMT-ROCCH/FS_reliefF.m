function [Index_F] = FS_reliefF(data,target,iterations,k,N,Theta)
% 基于ReliefF+阈值选择特征
    W = zeros(1,size(data,2));
    for i = 1:N
        W = W + reliefF(data,target,iterations,k);
    end
    W = W/N;
    [~,index_sort] = sort(W,'descend');
    
    Num = ceil( Theta * length(index_sort) );
    Index_F = index_sort(1:Num);
    Index_F = sort(Index_F);
end

