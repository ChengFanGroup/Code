function Pop = InitialisationforDoubPop(individuVide, ProblemParameters,GAParameters)

%-----------------------------------------
%	Init variables
%-----------------------------------------
A = ProblemParameters.LowerLimit;
B = ProblemParameters.UpperLimit;
N = GAParameters.PopSize;
n = ProblemParameters.NbVariablesDecision;

%-----------------------------------------
%	Regroupement des colonnes en une tab
%-----------------------------------------
Pop = repmat(individuVide,N,1);

%-----------------------------------------

%-----------------------------------------

for i = 1:N
    Pop(i).Val = A+(B-A)*rand(n,1);
end
