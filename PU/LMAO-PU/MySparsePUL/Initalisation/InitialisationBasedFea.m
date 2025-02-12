function Pop = InitialisationBasedFea(individuVide, ProblemParameters,GAParameters)

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

load('FeatSub');
new1(:,FeatSub1>0.5)=1;
new1(:,FeatSub1<=0.5)=0;
new2(:,FeatSub2>0.5)=1;
new2(:,FeatSub2<=0.5)=0;
new3(:,FeatSub3>0.5)=1;
new3(:,FeatSub3<=0.5)=0;
new1=new1';
new2=new2';
new3=new3';
for i=1:N
    if rand(1)*3<=1
        int=A+(B-A)*rand(n,1);
        Pop(i).Val=new1.*int;
    elseif  rand(1)*3<=2
        int=A+(B-A)*rand(n,1);
        Pop(i).Val=new2.*int;
    elseif  rand(1)*3<=3
        int=A+(B-A)*rand(n,1);
        Pop(i).Val=new3.*int;
    end
end
%-----------------------------------------
