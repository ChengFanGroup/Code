function [newGBA,newf_GBA] = non_dom_V(oldGBA,oldf_GBA,pbest,f_pbest)
%输入：f_x，每一列代表所有粒子对于某一个目标函数的值
%输出：排序的non dominant solution
newGBA = [];
newf_GBA = [];
x = [oldGBA;pbest];
f_x = [oldf_GBA;f_pbest];
[r,c] = size(f_x);
f1 = f_x(:,1);
f2 = f_x(:,2);

for i = 1:r
    pop_s(i).np = 0;   
    pop_s(i).Sp = [];   
end

for i=1:r
    for j=1:r 
        if Dominate(f_x(i,:),f_x(j,:))   % P(i) donimates P(j)  
             pop_s(i).Sp = [pop_s(i).Sp j ];
        elseif Dominate(f_x(j,:),f_x(i,:))   % P(i) is dominated by P(j) 
             pop_s(i).np = pop_s(i).np+1;
        end   
    end
end

front = 1;
F = [];   
for i = 1:r
    if pop_s(i).np == 0
        Fnum(i,:) = 1;
        F = [F i];
    end
end

newGBA=x(F,:);
newf_GBA=f_x(F,:);

[newf_GBA,ia,~] = unique(newf_GBA,'rows');
newGBA = newGBA(ia,:);

[newf_GBA(:,1),idx] = sort(newf_GBA(:,1));
newf_GBA(:,2) = newf_GBA(idx,2);
newGBA = newGBA(idx,:);

end

