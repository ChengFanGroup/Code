function [pop,obj] = EnvironmentalSelection(pop, popsize, obj)
% NSGA¢ò¿ò¼Ü»·¾³Ñ¡Ôñ
    %% 
    Pop = [pop, obj];
    Pop = unique(Pop, 'rows');
    pop = Pop(:, 1 : end - 2);
    obj = Pop(:, end - 1 : end);
    if size(pop,1) > popsize
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
        pop = pop(selected, :);
        obj = obj(selected, :); 
    end

end