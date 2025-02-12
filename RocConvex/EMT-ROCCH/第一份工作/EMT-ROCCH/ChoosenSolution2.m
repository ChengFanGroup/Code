function [traIndex] = ChoosenSolution2(point,traSlonum)
%   分区域选解 三种倾向
%  
    traIndex = [];
    N = size(point,1);
    interval = 1/(traSlonum/2);
    PointGroup = zeros(1,N);
    O = [1,0];
    left = zeros(traSlonum/2+1,2);
    left(:,2) = 0:interval:1;
    right = ones(traSlonum/2,2);
    right(:,1) = interval:interval:1;
    curve = [left;right];
    
    for n = 1 : N
        dist = zeros(traSlonum+1,1);
        for i = 1:traSlonum+1
            dist(i) = abs(det([curve(i,:)-O;point(n,:)-O]))/norm(curve(i,:)-O);
        end
        [~,index] = sort(dist);
        PointGroup(n) = min(index(1),index(2));
    end
    
    T = ismember(1:traSlonum,PointGroup);
    for k = 1:traSlonum        
        if(T(k)==1)
            index = find(PointGroup==k);
            Arc = point(index,:);
            if k<traSlonum/2
                [~,a] = min(Arc(:,1));
                traIndex = [traIndex index(a)];
            elseif (k == traSlonum/2) || (k == traSlonum/2+1)
                 h = size(Arc,1);
                 d = zeros(h,1);
                 for t = 1:h
                    d(t) = norm([0 1] - Arc(t,:));
                 end
                 [~,a] = min(d);
                traIndex = [traIndex index(a)];
            else
                [~,a] = max(Arc(:,2));
                traIndex = [traIndex index(a)];
            end
        end
    end
    while length(traIndex)<traSlonum
        if(T(traSlonum/2)==1 && T(traSlonum/2+1)==1)
            Candi_index = [find(PointGroup==traSlonum/2) find(PointGroup==traSlonum/2+1)];
        elseif(T(traSlonum/2+1)==1 && T(traSlonum/2)==0)
            Candi_index = find(PointGroup==traSlonum/2+1);
        elseif(T(traSlonum/2)==1 && T(traSlonum/2+1)==0 )
            Candi_index = find(PointGroup==traSlonum/2);
        else
            Candi_index = [];
        end
        Candi_index = setdiff(Candi_index,traIndex);
        if isempty(Candi_index)
            Candi_index = setdiff(1:N,traIndex);
        end
        Addindex = (Candi_index(randi([1,length(Candi_index)],1,min(traSlonum-length(traIndex),length(Candi_index)))));
%         disp(Addindex);
        traIndex = [traIndex Addindex];
%         disp(traIndex);
        traIndex = unique(traIndex);
    end
end

