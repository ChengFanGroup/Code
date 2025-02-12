function [Index_F] = FS_reliefF_knee2(data,target,iterations,k,N,Smin,Smax)
%閫夊嚭鏉冮噸澶т簬kneepoint鐨勭壒寰?
    W = zeros(1,size(data,2));
    for i = 1:N
        W = W + reliefF(data,target,iterations,k);
    end
    W = W/N;
    [W_sort,id_sort] = sort(W,'descend');

    A = W_sort;
    A(abs(A)<0.001) = 0;
    kneepoint2 = find(A==0,1,'last');%返回最后一个等于0的索引
    
    W_pre = W_sort(1:kneepoint2);
    dist = zeros(1,length(W_pre));
    A =(W_pre(1)-W_pre(end))/(1-size(W_pre,2));
    B = -1;
    C = W_pre(end)-A*size(W_pre,2);
    for i = 2:length(W_pre)-1
        dist(i) = abs(A*i+B*W_pre(i)+C)/sqrt(A^2+B^2);
    end
    [~,kneepoint] = max(dist);
    
%     figure
%     x1 = 1 : length(W_sort);
%     plot(x1,W_sort);
%     hold on 
%     x2 = 1 : length(W_sort(1:kneepoint));
%     plot(x2,W_sort(1:kneepoint),'r-');
%     hold off
    
    if kneepoint<Smin
        kneepoint = Smin;
    end
    if kneepoint > Smax
        kneepoint = Smax;
    end
    Index_F = id_sort(1:kneepoint);
    Index_F = sort(Index_F);
    
end

