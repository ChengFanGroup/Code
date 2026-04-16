function [NewChrom] = uniformX_grap2(OldChrom,idx,px,pm,chromosome_f,g1,g2,g3,studyflag)
%UNIFORMX 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(OldChrom);
p1 = OldChrom; 
teacher = logical(idx );
teac = repmat(teacher,m,1);
chromidx = repmat(idx,m,1);
aa = rand(m,n);
chromidx = chromidx > aa;
p2 = chromidx;

% f = rand(m,1);
% f = f > 0.5 ;

% template_x = logical(randsrc(M,N, [1,0;px,1-px]));
% 
% % child_1 = OldChrom(parent_2,:) & template + OldChrom(parent_1,:) & ~template;
% % child_2 = OldChrom(parent_1,:) & template + OldChrom(parent_2,:) & ~template;
% 
% child_1 = OldChrom .* template_x + chromidx .* ~template_x;
% child_2 = OldChrom .* ~template_x + chromidx .* template_x;
    

	%% crossover
	np1 = p1 & p2;
	np2 = xor(p1, p2);
	np3 = zeros(m, n);
	% t = rand(m / 2, n) > rand();
	t = randi(n, m, n) > randi(n, m, 1);
	np3(t) = np2(t);
	np4 = xor(np2, np3);

	np3 = np1 | np3;
	np4 = np1 | np4;
	k = rand(m,1) >px ;
	np3(k, :) = p1(k, :);
	np4(k, :) = p2(k, :);
% 	pop2 = [np3; np4];
    child_1 = np3;
    child_2 = np4;
%      child_1 = mut(child_1, pm); % 变异
%      child_2 = mut(child_2, pm); % 变异


     child_1 = mutgraph(child_1,studyflag,p2,m,n,teac) ;
     child_2 = mutgraph(child_2,studyflag,p2,m,n,teac) ;
    

    NewChrom = child_2;
    NewChrom(m+1:2*m,:) = child_1;


%     if  studyflag ==1
%         
%         nost = xor(p2,NewChrom);
%         tost = nost & p2;
%         Pst1 = sum(tost,2)./(2*n);
%         final1 = rand(m,n);
%         final1 = final1 <Pst1;
%         tost1 = tost & final1;
%         NewChrom = NewChrom +tost1;
% 
%         tost0 = xor(nost,tost);
%         Pst0 = sum(tost0,2)./(n);
%         final0 = rand(m,n);
%         final0 = final0 <Pst0;
%         tost0 = tost0 & final0;
%         NewChrom = NewChrom -tost0;
%     else
%         tode = teac & NewChrom;
%         Pst10 = sum(tode,2)./n;
%         final10 = rand(m,n);
%         final10 = final10 <Pst10;
%         tode10 = tode &final10;
%         NewChrom = NewChrom -tode10;
% 
%         ad = ones(m,n);
%         tost11 = xor(ad,teac);
%         final12 = rand(m,n);
%         final12= final12 <(1./(2*n));
%         toup = tost11 & final12;
%         NewChrom = logical(NewChrom + toup);
%     end



%  child_1 = mut(child_1, pm); % 变异
%  child_2 = mut(child_2, pm); % 变异
% % child_1 = newmutteach(child_1,teacher );
% % child_2 = newmutteach(child_2,teacher );

% NewChrom((1:2:2*m),:) = double(child_1);
% NewChrom((2:2:2*m),:) = double(child_2);
[lia,loc] =ismember(NewChrom,chromosome_f,"rows");
ipnewmut = find(lia);
if length(ipnewmut) > 0 
    NewChrom = newmut1(NewChrom,ipnewmut,g1,g2,g3);

end   

% save('111.mat','child_1','template_x','OldChrom','NewChrom')
% ccc
end