function f=restart(poplength)
a=zeros(1,poplength);
for i=1:poplength
    if rand(1,1)<0.15
        a(1,i)=1;
    end
end
f=a;

end
