function [P1,fit1,Fnum1] = nondSort(P,fit);  
% Fast nondominated sorting
 
global  D M 

popSize = size(P,1);      

for i = 1:popSize
    pop_s(i).np = 0;   
    pop_s(i).Sp = [];   
end

for i=1:popSize
    for j=1:popSize 
        if Dominate(fit(i,:),fit(j,:))   % P(i) donimates P(j)  
             pop_s(i).Sp = [pop_s(i).Sp j ];
        elseif Dominate(fit(j,:),fit(i,:))   % P(i) is dominated by P(j) 
             pop_s(i).np = pop_s(i).np+1;
        end   
    end
end

%   the first Pareto fornt
front = 1;
F = [];   
for i = 1:popSize
    if pop_s(i).np == 0
        Fnum(i,:) = 1;
        F = [F i];
    end
end
 
Q=[];
while ~isempty(F)
    
    for i = 1:length(F)                         
        for j = 1:length(pop_s(F(i)).Sp)        
            ind1 = pop_s(F(i)).Sp(j);            
            pop_s(ind1).np = pop_s(ind1).np-1;
 
            if  pop_s(ind1).np == 0
                Q = [Q ind1];                 
                Fnum(ind1,:) = front+1;
            end    
        end

    end
    front = front+1;
    F = Q;Q = [];

end


[~,sortIndex] = sort(Fnum);
for i = 1:popSize
    P1(i,:) = P(sortIndex(i),:);
    fit1(i,:) = fit(sortIndex(i),:);
    Fnum1(i,:) = Fnum(sortIndex(i),:);

end

