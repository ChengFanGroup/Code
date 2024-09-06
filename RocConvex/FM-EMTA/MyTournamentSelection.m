function [MatingPool] = MyTournamentSelection(FrontNo_pop,CrowdDis_pop,K,popnum,SelectionNum)
%       K元锦标赛选择
%   此处显示详细说明
        MatingPool = zeros(1,SelectionNum);
        for i = 1 : SelectionNum
            r = randi([1,popnum],1,K);
            r = unique(r);
            while(length(r) ~= K)
                r = randi([1,popnum],1,K);
            end
            r = sort(r);
            FrontNo  = FrontNo_pop(r);
            CrowdDis = CrowdDis_pop(r);
            MinFront = min(FrontNo);
            [~,index_1] = find(FrontNo==MinFront);
            [~,index_2] = max(CrowdDis(index_1));
            MatingPool(1,i) = r(index_1(index_2));
        end
end

