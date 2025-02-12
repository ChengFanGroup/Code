function  [UserInput,GAParameters,ProblemParameters]=ParametersSetforMask(NVar)
%一些参数设置
%选择评价函数

UserInput.Probleme = 14; 
UserInput.Algorithme = 2; 

GAParameters.PopSize = 100; %temp
GAParameters.ArchiveSize = 100; %temp
GAParameters.Gmax = 200; %temp
GAParameters.Pc = 0.7; %temp
GAParameters.Pm = 0.4; %temp
ProblemParameters.UpperLimit = 1;
ProblemParameters.LowerLimit = 0;
ProblemParameters.NbVariablesDecision = NVar;

end