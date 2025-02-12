%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Algorithme NSGA2 for Mask
%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [G,F1]=NSGA2forMask(UserInput,ProblemParameters,GAParameters,i,G, ll)

%-----------------------------------------
%   Init individuvide
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
if G<29
    Po = InitialisationforDoubPop(individuVide, ProblemParameters,GAParameters);
else
    Po = InitialisationBasedFea(individuVide, ProblemParameters,GAParameters);
end
temp=G; 


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

%-----------------------------------------
%   Itation pendant Gmax gations
%-----------------------------------------
while (G <temp+20)
    
    %-----------------------------------------
    %   Selection du MP par tournoi binaire
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
    %   Parents + Enfants mut
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
    %   On conserve les N (taille pop) premiers éléments
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
    
    % Store F1x
    F1 = P(F{1});
    
   
    disp(['ll= ' num2str(ll) ' CrossOver= ' num2str(i)  '// G = '  num2str(G) ' // Taille Front = ' num2str(size(F1,1))]);
    G = G+1;
end 
    findFeatSub([F1.Val]');

%-----------------------------------------
%   
%-----------------------------------------

   
end