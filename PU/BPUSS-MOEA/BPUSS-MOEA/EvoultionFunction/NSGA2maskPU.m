%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Algorithme  NSGA2 for double population
%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [F1,NewF1]=NSGA2maskPU(UserInput,ProblemParameters,GAParameters,i)

%-----------------------------------------
%   Init individu vide
%-----------------------------------------


individuVide.Val = [];
individuVide.ValObjective = [];
individuVide.Rank = [];
individuVide.CrowdingDistance = [];
individuVide.DominationSet = [];
individuVide.DominatedCount = [];


%-----------------------------------------
%   Initialisation de la premiere population Po
%-----------------------------------------
Po = InitialisationNSGA2Mask(individuVide, ProblemParameters,GAParameters);
G = 1;

%-----------------------------------------
%   Evaluation de Po (P)
%-----------------------------------------
P = EvaluationNSGA2(UserInput,Po);

%-----------------------------------------
%   Non Dominated Sorting
%-----------------------------------------
[P, F] = NonDominatedSorting(P);

%-----------------------------------------
%   Crowding Distance
%-----------------------------------------
P = CrowdingDistance(P,F);

%-----------------------------------------
%   Tri en fct du rang puis de la distance
%-----------------------------------------
[P, ~] = SortPopulation(P);

% figure(1); clf; axis([1 100 0 1]); xlabel('Number of Iterations');
% ylabel('Sparse Value'); title('Convergence Curve'); grid on;
%-----------------------------------------
%   Itation pendant Gmax gations
%-----------------------------------------
while (G < GAParameters.Gmax)
    
    %-----------------------------------------
    %   使用二进制锦标赛选择父母
    %-----------------------------------------
    MP = SelectionTournoi(individuVide, UserInput.Algorithme, P);
    
    %-----------------------------------------
    %   Croisement (simulated binary crossover)
    %-----------------------------------------
    Enfants = SimulatedBinaryCrossover(individuVide, GAParameters, ProblemParameters, MP);
    
    %-----------------------------------------
    %   Mutation (polynomial mutation)
    %-----------------------------------------
    Mutants = PolynomialMutation(UserInput.Algorithme,UserInput.Probleme, GAParameters, ProblemParameters, Enfants);
    Mutants = EvaluationNSGA2(UserInput, Mutants);

    %-----------------------------------------
    %   Parents + Enfants mut閟
    %-----------------------------------------
    R = [P ; Mutants];
    
    %-----------------------------------------
    %   Non Dominated Sorting & Crowding Distance
    %-----------------------------------------
    [R, F] = NonDominatedSorting(R);
    R = CrowdingDistance(R,F);
    
    
    %-----------------------------------------
    %   Tri en fct du rang puis de la distance
    %-----------------------------------------
    [Q, ~] = SortPopulation(R);

    %-----------------------------------------
    %   On conserve les N (taille pop) premiers 閘閙ents
    %-----------------------------------------
    P = Q(1:GAParameters.PopSize);
    
    %-----------------------------------------
    %   Non Dominated Sorting & Crowding Distance
    %-----------------------------------------
    [P, F] = NonDominatedSorting(P);
    P = CrowdingDistance(P,F);
    
    %-----------------------------------------
    %   Tri en fct du rang puis de la distance
    %-----------------------------------------
    [P, F] = SortPopulation(P);
    
    % Store F1
    F1 = P(F{1});
    
  
    disp(['CrossOver= ' num2str(i)  '// G = '  num2str(G) ' // Taille Front = ' num2str(size(F1,1))]);
    G = G+1;
     if mod(G-1,20)==0&&G~=1 
        [G,NewF1]=DoublePop(i,G,F1);
        [P] = ComPop(P);
         updateCost; 
     end
    
end

%-----------------------------------------
%   Affichage resultats finaux
%-----------------------------------------
%   AffichageResultats(F1, G);

end