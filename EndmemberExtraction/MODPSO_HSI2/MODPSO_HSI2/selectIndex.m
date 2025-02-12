function index = selectIndex(Np,k,ProMod)

  
Seq = 1:Np;
R = Np-Seq;

if ProMod==0
    p=ones(1,Np); 
elseif ProMod==1
    p = R/Np;
elseif ProMod==2
    p = (R/Np).^0.5;
elseif ProMod==3
    p = (R/Np).^2;
elseif ProMod==4
    p = 0.5*(1-cos((R*pi)/Np));
end

index(1) = randi(Np);
while rand>p(index(1)) | index(1)==k
    index(1) = randi(Np);
end

index(2) = randi(Np);
while rand>p(index(2)) | index(2)==index(1) | index(2)==k
    index(2) = randi(Np);
end

index(3) = randi(Np);
while index(3)==index(1) |  index(3)==index(2) | index(3)==k
    index(3) = randi(Np);
end






 

