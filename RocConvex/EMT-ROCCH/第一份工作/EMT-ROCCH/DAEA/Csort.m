function [CF,maxF] = Csort(obj)
    %% sperate
    tobj2 = unique(obj(:,2), 'rows');
    tobj1 = unique(obj(:,1), 'rows');
    [~, a] = sort(tobj2);
    [~, b] = sort(tobj1);
    al = tobj2(a(ceil(length(tobj2)/2)));
    bl = tobj1(b(ceil(length(tobj1)/2)));
    idealpoint = [bl,al];
    dis = pdist2(idealpoint,obj);
    [~, nei] = sort(dis, 2);
    refpoint1 = obj(nei(1),:);
    refpoint2 = [max(obj(:,1)),0];
    refpoint3 = [0,max(obj(:,2))];
    k1 = (refpoint1(1,2)-refpoint2(1,2))/(refpoint1(1,1)-refpoint2(1,1));
    k2 = (refpoint1(1,2)-refpoint3(1,2))/(refpoint1(1,1)-refpoint3(1,1));
    %% 
    CF = zeros(1, size(obj,1));
    sumF = zeros(1,4);
    for i = 1:size(obj,1)
        if (obj(i,2) < (k1*(obj(i,1)-refpoint1(1)) + refpoint1(2))) && (obj(i,2) < (k2*(obj(i,1)-refpoint1(1)) + refpoint1(2)))
            CF(i) = 1;
            sumF(1) = sumF(1) + 1;
        elseif (obj(i,2) <= (k1*(obj(i,1)-refpoint1(1)) + refpoint1(2))) && (obj(i,2) >= (k2*(obj(i,1)-refpoint1(1)) + refpoint1(2)))
            CF(i) = 3;
            sumF(2) = sumF(2) + 1;
        elseif (obj(i,2) >= (k1*(obj(i,1)-refpoint1(1)) + refpoint1(2))) && (obj(i,2) <= (k2*(obj(i,1)-refpoint1(1)) + refpoint1(2)))
            CF(i) = 2;
            sumF(3) = sumF(3) + 1;
        else
            CF(i) = 4;
            sumF(4) = sumF(4) + 1;
        end
    end
    for i = 1:4
        if sum(sumF(1:i)) >= 200
            maxF = i;
            break;
        elseif sum(sumF) < 200
            maxF = 4;
        end
    end
    
%         x = 0:0.1:1;
%         y = k1*(x-refpoint1(1,1))+refpoint1(1,2);
%         plot(x,y);
%         hold on;
%         x = 0:0.1:1;
%         y = k2*(x-refpoint1(1,1))+refpoint1(1,2);
%         plot(x,y);
%         hold on;
    
    
    
end