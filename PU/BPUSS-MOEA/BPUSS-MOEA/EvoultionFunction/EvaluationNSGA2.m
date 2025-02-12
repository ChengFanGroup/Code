%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       
%
%     评价函数
%     选择问题计算适应度值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function P = EvaluationNSGA2(UserInput,Po)

%-----------------------------------------
%	Init variables
%-----------------------------------------
N = size(Po,1);
P = Po;

%-----------------------------------------
%	Affectation des valeurs de fitness
%-----------------------------------------
for i = 1:N
   
    P(i).ValObjective = Probleme(UserInput.Probleme,Po(i).Val);

end