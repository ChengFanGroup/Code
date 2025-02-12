function sum=Calculatearea(results)

results = [0 0;results;1 1];
results=sortrows(results);
sum=0;
for i=1:size(results,1)-1
    j=i+1;
    temp=abs(results(i,1)-results(j,1))*(results(i,2)+results(j,2))*0.5;
    sum=sum+temp;
    
end
end