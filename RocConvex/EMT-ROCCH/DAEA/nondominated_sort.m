% function [PF, maxF] = nondominated_sort(pop, obj, N)
%     k = 1;
%     while N > 0
%         PF{k} = [];
%         Dominated = zeros(N, 1);
%         Dominated = logical(Dominated);
%         for i = 1:N
%             for j = i+1:N
%                 if dominates(obj(i, :), obj(j, :))
%                     Dominated(j) = true;
%                 elseif dominates(obj(j, :), obj(i, :))
%                     Dominated(i) = true;
%                 end
%             end
%         end
%         PF{k} = [PF{k} pop(~Dominated)];
%         maxF = K;
%         N = N - sum(~Dominated);
%     end
% end

function [FrontNo,MaxFNo] = nondominated_sort(PopObj,nSort)
    [PopObj,~,Loc] = unique(PopObj,'rows');
    Table   = hist(Loc,1:max(Loc));
    [N,M]   = size(PopObj);
    FrontNo = inf(1,N);
    MaxFNo  = 0;
    while sum(Table(FrontNo<inf)) < min(nSort,length(Loc))
        MaxFNo = MaxFNo + 1;
        for i = 1 : N
            if FrontNo(i) == inf
                Dominated = false;
                for j = i-1 : -1 : 1
                    if FrontNo(j) == MaxFNo
                        m = 2;
                        while m <= M && PopObj(i,m) >= PopObj(j,m)
                            m = m + 1;
                        end
                        Dominated = m > M;
                        if Dominated || M == 2
                            break;
                        end
                    end
                end
                if ~Dominated
                    FrontNo(i) = MaxFNo;
                end
            end
        end
    end
    FrontNo = FrontNo(:,Loc);
end
