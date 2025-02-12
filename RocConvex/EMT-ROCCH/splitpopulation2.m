function [U_in,ImpPoint]=splitpopulation2(U_point)

    N = size(U_point,1);
    index = zeros(1,N);
    X = -1;Y = -1;
    optX = 0;optY = 1;
    for i = 1 : N
        if (U_point(i,1) == 0)
            index(i) = 1;
            if(U_point(i,2)>optX)
                X = i;
                optX = U_point(i,2);
            end
        elseif U_point(i,2) == 1
            index(i) = 2;
            if(U_point(i,1)<optY)
                Y = i;
                optY = U_point(i,1);
            end
        end
    end
    U_in = find(index==0);
    ImpPoint = [];
    if X~=-1
        ImpPoint = [ImpPoint X];
    end
    if Y~=-1
        ImpPoint = [ImpPoint Y];
    end
    
end