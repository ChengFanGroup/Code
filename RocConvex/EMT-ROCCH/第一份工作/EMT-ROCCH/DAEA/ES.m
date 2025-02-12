function [pop,obj] = EnvironmentalSelection(pop, popsize, obj)
% NSGA¢ò¿ò¼Ü»·¾³Ñ¡Ôñ
    %% 
    if length(pop) > popsize
        % choice 20% low error rate soultions
        lowerr = popsize * 0.2;
        [~, rank] = sort(obj(:, 2));
        preselected = rank(1:lowerr, :);
%         obj = obj(rank(lowerr:length(pop), :), :);
        
        % nondominated solutions
        [PF, maxF] = nondominated_sort(obj, popsize);
        
        selected = PF < maxF;
        candidate = PF == maxF;
        
        % crowding distance
        CD = crowdingDistance(obj, PF, maxF);
        
        % select last PF
        while sum(selected) < popsize
            S = obj(selected, 1);
            IC = find(candidate);
            [~, ID] = sort(CD(IC), 'descend');
            IC = IC(ID);
            C = obj(IC, 1);
            Div_Vert = zeros(1, length(C));
            for i = 1 : length(C)
                Div_Vert(i) = length(find(S == C(i)));
            end
            [~, IDiv_Vert] = sort(Div_Vert);
            IS = IC(IDiv_Vert(1));
            % reset Selected and Candidate
            selected(IS) = true;
            candidate(IS) = false;
        end
        selected(preselected) = 1;
        if sum(selected) > popsize
            [~, del] = sort(selected, 'descend');
            del1 = del(1: sum(selected));
            delete = randperm(length(del1), sum(selected) - popsize);
            selected(del1(delete)) = 0;
        end
        pop = pop(selected, :);
        obj = obj(selected, :); 
    end
end