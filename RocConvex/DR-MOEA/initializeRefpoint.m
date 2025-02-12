function refpoint = initializeRefpoint(pointnum)
%   初始参考点
%   理想点（0,1），左边和上边坐标轴均匀分布
    optimalpoint = [0,1];
    K = (pointnum-1)/2;
    leftpoint = zeros(K,2);
    toppoint = ones(K,2);
    
    leftpoint(:,2) =  sort(0:0.1:0.9,'descend');
    toppoint(:,1) = 0.1:0.1:1;
    
    refpoint = [optimalpoint;leftpoint;toppoint];
end

