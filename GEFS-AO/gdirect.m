function [idx,ermaxloc,fmmaxloc,zonghemaxloc,pop3,gpbest1,gpbest2,gpbest3,gpbestfitness1,gpbestfitness2,gpbestfitness3,ger1,ger2,ger3,gfm1,gfm2,gfm3] = gdirect(g1,g2,g3,t,oldpop,gpbest1,gpbest2,gpbest3,gpbestfitness1,gpbestfitness2,gpbestfitness3,ger1,ger2,ger3,gfm1,gfm2,gfm3)


 global Zout Zout2 Zout3 featNum ;
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
 pop = zeros(3,featNum);
 ak1 = Zout;
 ak2 =  Zout2;
 ak3 = Zout3 ;
 ak1 = ak1 .*g1;
 ak2 = ak2 .*g2;
 ak3 = ak3 .*g3;
 wmax = 0.5;
 wmin = 0.3;
 wnow = wmax-(wmax-wmin)*t/100;
 featidx1 = kshell_2(ak1);  idx1 = zeros(1,featNum);  idx1(:,featidx1 ) = 1; 
 featidx2 = kshell_2(ak2);  idx2 = zeros(1,featNum);  idx2(:,featidx2 ) = 1; 
 featidx3 = kshell_2(ak3);  idx3 = zeros(1,featNum);  idx3(:,featidx3 ) = 1; 
 
%  pop(1,:) = idx1;
%  pop(2,:) = idx2;
%  pop(3,:) = idx3;


 n = evaluate_objective_f(2, idx1);
%  pop(1,featNum+1:featNum+2) = n;
 er1 = n(1,1); fm1 = n(1,2); fitness1 = 0.9*er1 + 0.1*fm1/featNum;
 fitnesszonghe1 = 0.5*er1 + 0.5*fm1/featNum;
 if fitness1 < gpbestfitness1
    gpbestfitness1 = fitness1;
    gpbest1 = idx1;
    ger1 = er1;
    gfm1 = fm1;
 end
  k1 = 1/((0.9*ger1)*(0.9*ger1)+(0.1*gfm1/featNum)*(0.1*gfm1/featNum));

 [n2] = evaluate_objective_f(2, idx2);
%  pop(2,featNum+1:featNum+2) = n2;
 er2 = n2(1,1); fm2 = n2(1,2); fitness2 = 0.9*er2 + 0.1*fm2/featNum;
 fitnesszonghe2 = 0.5*er2 + 0.5*fm2/featNum;
 if fitness2 < gpbestfitness2
    gpbestfitness2 = fitness2;
    gpbest2 = idx2;
    ger2 = er2;
    gfm2 = fm2;
 end
  k2 = 1/((0.9*ger2)*(0.9*ger2)+(0.1*gfm2/featNum)*(0.1*gfm2/featNum));
 [n3] = evaluate_objective_f(2, idx3);
%  pop(3,featNum+1:featNum+2) = n3;
 er3 = n3(1,1); fm3 = n3(1,2);  fitness3 = 0.9*er3 + 0.1*fm3/featNum;
 fitnesszonghe3 = 0.5*er3 + 0.5*fm3/featNum;
 if fitness3 < gpbestfitness3
    gpbestfitness3 = fitness3;
    gpbest3 = idx3;
    ger3 = er3;
    gfm3 = fm3;
 end
 k3 = 1/((0.9*ger3)*(0.9*ger3)+(0.1*gfm3/featNum)*(0.1*gfm3/featNum));
 %%%%%图引导
 
 pop(1,:) = gpbest1; 
 pop(1,featNum+1:featNum+2) = [ger1,gfm1]; 
 pop(2,:) = [gpbest2,ger2,gfm2];
%  pop(2,featNum+1:featNum+2) = [ger2,gfm2];
 pop(3,:) = [gpbest3,ger3,gfm3]; 
%  pop(3,featNum+1:featNum+2) = [ger3,gfm3];


 
 [lia,loc] =ismember(pop,oldpop,"rows");
 
 pop3 = pop(~lia,:);



 
 ww1 = k1/(k1 +k2 +k3) *wnow;
 ww2 = k2/(k1 +k2 +k3) *wnow;
 ww3 = k3/(k1 +k2 +k3) *wnow;
 
 idx = ww1*gpbest1 + ww2*gpbest2 + ww3*gpbest3;
%  idx = idx + x;
 erarray = [er1,er2,er3];
 [~,ermaxloc] = max(erarray);
 fmarrary = [fm1,fm2,fm3];
 [~,fmmaxloc] = max(fmarrary);
 zonghe = [ fitnesszonghe1, fitnesszonghe2, fitnesszonghe3 ];
 [~,zonghemaxloc] = max(zonghe);

end