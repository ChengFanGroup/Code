function auc = TestMaxAuc(weight,Test_Dataset,Test_Label)

Dom=size(Test_Dataset,2);
Test_Label(find(Test_Label==0))=-1;
indexp=find(Test_Label==1);
indexn=find(Test_Label==-1);
datasetp=Test_Dataset(indexp,:);
datasetn=Test_Dataset(indexn,:);



load('classifier');
    Fnum=size(weight,1);
    for j=1:Fnum
     for i=1:Dom
         if weight(j,i)>0.5
             new(j,i)=1;
         else
             new(j,i)=0;
         end
     end
    end
     newpop=new.*classifier(:,1:Dom);
% Reference=[1,1];  
for i=1:Fnum
    yp = newpop(i,1:Dom) * datasetp'+classifier(:,end);
    yn = newpop(i,1:Dom) * datasetn'+classifier(:,end);
    score=0;
    
    for k=1:size(yp,2)
        for j=1:size(yn,2)
            if yp(k)>=yn(j)
                score=score+1;
            end
        end
    end
    auc(i)=score/(size(yp,2)*size(yn,2));
    score=0;
end
   auc=max(auc);

end