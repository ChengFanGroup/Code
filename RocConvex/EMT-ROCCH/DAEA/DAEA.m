function finalPop = DAEA()
    global Global
%     global selected_half
    
    %% Initialization
    Population = InitialPop();
    gen = 1;
    
    %% Optimization
    while Global.evals < Global.maxEvals
%         waitbar(Global.evals/Global.maxEvals,h, sprintf('Completed %3.1f%%', (Global.evals/Global.maxEvals)*100)); % progress bar
        %disp(['GEN ', int2str(gen)]);
        Offspring = NicVariation(Population);
        Population = EnvironmentalSelection([Population; Offspring], Global.N, Global.D);
%         if mod(gen,10) == 0
%             o = Population(:,Global.D+1:Global.D+2);
%             save(['D:\code\Matlab\DGEA\temp\d',num2str(gen/10)],'o');
%         end
%         if mod(gen, 5) == 0
            
            
            
%            %% selected number
%            selected = [selected; sum(Population(:, 1:Global.D), 1)];
%            % selected ratio in top half
%            selInx = SelectHalf(Population, ceil(Global.N / 2));
%            selected_half = [selected_half; sum(Population(selInx, 1:Global.D), 1)];
           
%            %% variance of feature
%            Mean = repmat(mean(Population(:, 1:Global.D)), size(Population, 1), 1);
%            selected = [selected; sum((Population(:, 1:Global.D) - Mean).^2, 1)/size(Population, 1)];
%            % selected ratio in top half
%            selInx = SelectHalf(Population, ceil(Global.N / 2));
%            Mean1 = repmat(mean(Population(selInx, 1:Global.D)), size(selInx, 2), 1);
%            selected_half = [selected_half; sum((Population(selInx, 1:Global.D) - Mean1).^2, 1)/size(selInx, 2)];
           
%         end
%         if mod(gen, 1) == 0
%         figure(1);
%         scatter(Population(:, end-1), Population(:,end), 24, 'r', 'filled');
% %         axis([0 0.2 0 0.2]);
%         xlabel(['Iteration', num2str(gen)]);
% %         saveas(gcf, ['D:\code\Matlab\DGEA\output\Iteration', num2str(i), '.jpg']);
% %     save(['D:\code\Matlab\DGEA\temp\a',num2str(i/10)],'obj');
%         end
       % [h(gen),~] = HV(Population(:,end-1:end));
        gen = gen+1;
    end
    finalPop = Population;
%     close(h)
%     delete(h)
end

% function PopInx = SelectHalf(Population, num)
%     global Global
%     D = Global.D;
%     %% Non-dominated sorting
%     [FrontNo,MaxFNo] = NDSort(Population(:, D+1:D+2),num);
%     Next = FrontNo < MaxFNo;
%     
%     %% Calculate the crowding distance of each solution
%     addpath('D:\kanezxk\MyProgram\Matlab\DAEA\test_selected_ratio')
%     CrowdDis = CrowdingDistanceAll(Population(:, D+1:D+2),FrontNo, MaxFNo, false);
%     
%     %% Select the solutions in the last front based on their crowding distances
%     Last     = find(FrontNo==MaxFNo);
%     [~,Rank] = sort(CrowdDis(Last),'descend');
%     Next(Last(Rank(1:num-sum(Next)))) = true;
%     
%     %% Population for next generation
%     PopInx = find(Next==true);
% 
% end



function Pop = InitialPop()
    global Global
    N = Global.N;
    D = Global.D;
    T = min(D, N * 3);
    Pop = zeros(N, D);
    for i = 1 : N
        k = randperm(T, 1);
        j = randperm(D, k);
        Pop(i, j) = 1;
    end
%     Pop = [Pop, Global.CalObj(Pop)];
%     Pop = randi([0,1], N, D);
    obj = zeros(N,2);
    for i = 1:N
        SF = sum(Pop(i,:)) / D;
        X = logical(Pop(i,:));
        err = KNNLOOCV(Global.samples(:,1:D),Global.samples(:,D+1),X);
        obj(i,:) = [SF,err];
    end
    Pop = [Pop,obj];
end

function Offspring = NicVariation(Population)
    global Global
    N = Global.N;
    D = Global.D;
    Objs = Population(:, D+1:D+2);
    Decs = Population(:, 1:D);

    % Selecting parents
    T = max(4, ceil(N * 0.2));
    normObjs = (mapminmax(Objs', 0, 1))';
    ED = pdist2(normObjs, normObjs, 'euclidean');
    ED(logical(eye(length(ED)))) = inf;
    [~, INic] = sort(ED, 2);
    INic = INic(:, 1 : T);
    IP_1 = (1 : N);
    IP_2 = zeros(1, N);
    for i = 1 : N
        if rand < 0.8 % local mating
            IP_2(i) = INic(i, randi(T, 1));
        else % global mating
            IG = (1 : N);
            IG(i) = [];
            IP_2(i) = IG(randi(N - 1, 1));
        end
    end
    Parent_1 = Decs(IP_1, :);
    Parent_2 = Decs(IP_2, :);
    Offspring = Parent_1;

    % do crossover
    for i = 1 : N
        k = find(xor(Parent_1(i, :), Parent_2(i, :)));
        t = length(k);
        if t > 1
            j = k(randperm(t, randi(t - 1, 1)));
            Offspring(i, j) = Parent_2(i, j);
        end
    end

    % do mutation
    for i = 1 : N
        if rand < 0.2
            j1 = find(Offspring(i, :));
            j0 = find(~Offspring(i, :));
            k1 = rand(1, length(j1)) < 1 / (length(j1) + 1);
            k0 = rand(1, length(j0)) < 1 / (length(j0) + 1);
            Offspring(i, j1(k1)) = false;
            Offspring(i, j0(k0)) = true;
        else
            k = rand(1, D) < 1 / D;
            Offspring(i, k) = ~Offspring(i, k);
        end
    end

    % get unique Offspring and individuals (function evaluated)
    Offspring = unique(Offspring, 'rows');
    Global.evals = Global.evals + size(Offspring, 1);
%     Offspring = [Offspring, Global.CalObj(Offspring)];
    obj = zeros(size(Offspring,1),2);
    for i = 1:size(Offspring,1)
        SF = sum(Offspring(i,:)) / D;
        X = logical(Offspring(i,:));
        err = KNNLOOCV(Global.samples(:,1:D),Global.samples(:,D+1),X);
        obj(i,:) = [SF,err];
    end
    Offspring = [Offspring,obj];
end

function Population = EnvironmentalSelection(Population, N, D)
    % Get unique individuals in decision space
    [~, U_Decs, ~] = unique(Population(:, 1:D), 'rows');
    UP = Population(U_Decs, :);
    UP = UP(UP(:, D+1) ~= 0, :);
    Objs = UP(:, D+1:D+2);
    Decs = UP(:, 1:D);

    if length(UP) > N 
        % Calculate solution difference in decision space
        SD = pdist2(Decs, Decs, 'cityblock');
        SD(logical(eye(length(SD)))) = inf;

        % remove some duplicated solutions in objective space
        [U_Objs, ~, I_Objs] = unique(Objs, 'rows');
        duplicated = [];
        %D = size(Decs, 2);
        for i = 1 : size(U_Objs, 1)
            j = find(I_Objs == i);
            if length(j) > 1
                t = sum(Decs(j(1), :));
                d = min(SD(j, j), [], 2) / 2;
                p = d / t;
                r = find(p < 0.8 - 0.6 * (t - 1) / (D - 1));
                if ~isempty(r)
                    duplicated = [duplicated; j(r(randperm(length(r), length(r) - 1)))];
                end
            end
        end

        % reset population
        if length(UP) - length(duplicated) > N
            UP(duplicated, :) = [];
            Objs = UP(:, D+1:D+2);
        end

        % nondominated sorting
        [Front, MaxF] = NDSort(Objs, N);
        Selected = Front < MaxF;
        Candidate = Front == MaxF;

        % Calculate crowding distance
        CD = CrowdingDistance(Objs, Front, MaxF);

        % select last front
        while sum(Selected) < N
            S = Objs(Selected, 1);
            IC = find(Candidate);
            [~, ID] = sort(CD(IC), 'descend');
            IC = IC(ID);
            C = Objs(IC, 1);
            Div_Vert = zeros(1, length(C));
            for i = 1 : length(C)
                Div_Vert(i) = length(find(S == C(i)));
            end
            [~, IDiv_Vert] = sort(Div_Vert);
            IS = IC(IDiv_Vert(1));
            % reset Selected and Candidate
            Selected(IS) = true;
            Candidate(IS) = false;
        end
        Population = UP(Selected, :);
    else
        Population = [UP, Population(randperm(length(Population), (N - length(UP))), :)];  % the number of individuals is not enough 
    end
end

function CrowdDis = CrowdingDistance(PopObj,FrontNo, MaxF)
    [N,M]    = size(PopObj);
    CrowdDis = zeros(1,N);
    Front = find(FrontNo==MaxF);
    Fmax  = max(PopObj(Front,:),[],1);
    Fmin  = min(PopObj(Front,:),[],1);
    for i = 1 : M
        [~,Rank] = sortrows(PopObj(Front,i));
        CrowdDis(Front(Rank(1)))   = inf;
        CrowdDis(Front(Rank(end))) = inf;
        for j = 2 : length(Front)-1
            CrowdDis(Front(Rank(j))) = CrowdDis(Front(Rank(j)))+(PopObj(Front(Rank(j+1)),i)-PopObj(Front(Rank(j-1)),i))/(Fmax(i)-Fmin(i));
        end
    end
end

function err = KNNLOOCV(data, label, X)
% LOOCV
% KNN, k = 1
    X = logical(X);
    if sum(X) == 0
        err = 1;
        return;
    end
    data = data(:, X);
    dist = pdist2(data, data);
    [~, idx] = min(dist + eye(size(data, 1)) * max(max(dist) * 2), [], 2);
    y = label(idx);
    y = y == label;
    acc = sum(y) / numel(y);
    err = 1 - acc;
end
