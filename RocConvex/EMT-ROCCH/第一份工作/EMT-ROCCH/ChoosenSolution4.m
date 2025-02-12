function [traIndex] = ChoosenSolution4(point,traSlonum)
%       随机选解
%    分两块区域 略微均匀
    traIndex = [];
    N = size(point,1);
    PointGroup = zeros(N,1);
    tarNum = traSlonum/2;
    
    for n = 1 : N
        if (point(n,1) + point(n,2) > 1)
            PointGroup(n) = 2;
        else
            PointGroup(n) = 1;
        end
    end
    
    for k = 1 : 2
        Candi_index = find(PointGroup==k);
        if(length(Candi_index)>tarNum)
            Arc = [];
            while(length(Arc) < tarNum)
                Arc = [Arc (Candi_index(randi([1,length(Candi_index)],1,tarNum-length(Arc))))'];
                Arc = unique(Arc);
            end
            traIndex = [traIndex Arc];
        else
            traIndex = [traIndex Candi_index'];
        end
    end
    
    while(length(traIndex) < traSlonum)
        Candi_index = setdiff(1:N,traIndex);
        traIndex = [traIndex (Candi_index(randi([1,length(Candi_index)],1,traSlonum-length(traIndex))))];
        traIndex = unique(traIndex);
    end
    
end

