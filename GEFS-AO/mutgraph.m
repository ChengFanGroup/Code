function [NewChrom] = mutgraph(NewChrom,studyflag,p2,m,n,teac)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

    if  studyflag ==1
        
        nost = xor(p2,NewChrom);
        tost = nost & p2;
        Pst1 = sum(tost,2)./(2*n);
        final1 = rand(m,n);
        final1 = final1 <Pst1;
        tost1 = tost & final1;
        NewChrom = NewChrom +tost1;

        tost0 = xor(nost,tost);
        Pst0 = sum(tost0,2)./(n);
        final0 = rand(m,n);
        final0 = final0 <Pst0;
        tost0 = tost0 & final0;
        NewChrom = NewChrom -tost0;
        NewChrom = double(NewChrom);
    else
        tode = teac & NewChrom;
        Pst10 = sum(tode,2)./n;
        final10 = rand(m,n);
        final10 = final10 <Pst10;
        tode10 = tode &final10;
        NewChrom = NewChrom -tode10;

        ad = ones(m,n);
        tost11 = xor(ad,teac);
        final12 = rand(m,n);
        final12= final12 <0.01;
        toup = tost11 & final12;
        NewChrom = logical(NewChrom + toup);
        NewChrom = double(NewChrom);
    end



end