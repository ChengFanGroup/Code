function [Index_F] = FS_reliefF_knee(data,target,iterations,k,N,Smin,Smax)
%选出权重大于kneepoint的特�?
    W = zeros(1,size(data,2));
    for i = 1:N
        W = W + reliefF(data,target,iterations,k);
    end
    W = W/N;
    [Wd,index_sort] = sort(W,'descend');
%     figure
%     x = 1 : length(Wd);
%     plot(x,Wd);
    
    %直线
    dist = zeros(1,size(Wd,2));
    A =(Wd(1)-Wd(end))/(1-size(Wd,2));
    B = -1;
    C = Wd(end)-A*size(Wd,2);
    for i = 2:size(W,2)-1
        dist(i) = abs(A*i+B*Wd(i)+C)/sqrt(A^2+B^2);
    end
    [~,kneepoint] = max(dist);
    if kneepoint<Smin
        kneepoint = Smin;
    end
    if kneepoint > Smax
        kneepoint = Smax;
    end
    Index_F = index_sort(1:kneepoint);
    Index_F = sort(Index_F);
end

