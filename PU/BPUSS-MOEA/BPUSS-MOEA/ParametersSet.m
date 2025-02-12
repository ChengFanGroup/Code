function  [UserInput,GAParameters,ProblemParameters]=ParametersSet(NVar)
%一些参数设置
%选择评价函数
% 1 MOP:TPR,FPR for PN
% 2 MOP:TPR,FPR for PU
% 3 MOP:ACC,COM for PN  PnClassifierFS
% 4 MOP:AUC,COM for PN
% 5 MOP:AUC,COM for PU
% 6 MOP:AUC,COM +index(选择可信任的P) for PU
% 7 MOP:ACC,COM +index for PU (交替优化稀疏优化使用)
% 8 MOP:TPR,FPR +index for PU （交替优化模型优化使用）
% 9 MOP:ACC,COM + Two stage for PN
% 10 MOP:TPR,FPR 每次使用选择的特征优化
% 11 MOP:ACC,COM +  交替优化for PU
% 12 MOP:使用聚类的方法评价index
% 13 MOP:使用基于距离的代价敏感的方式
UserInput.Probleme = 13; 
UserInput.Algorithme = 2; 

GAParameters.PopSize = 100; %temp
GAParameters.ArchiveSize = 100; %temp
GAParameters.Gmax = 100; %temp
GAParameters.Pc = 0.7; %temp
GAParameters.Pm = 0.4; %temp
ProblemParameters.UpperLimit = 1;
ProblemParameters.LowerLimit = -1;
ProblemParameters.NbVariablesDecision = NVar+1;

end

