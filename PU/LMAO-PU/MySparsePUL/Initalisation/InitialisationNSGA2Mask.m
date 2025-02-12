function Pop = InitialisationNSGA2Mask(individuVide, ProblemParameters,GAParameters)

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
      
%     Pop(i).Mask= (A+(B-A)*rand(n,1));
    Pop(i).Val = (A+(B-A)*rand(n,1));

end
    FeatSub = (0.5+(B-0.5)*rand(n-1,1));
    save FeatSub FeatSub;
end
    