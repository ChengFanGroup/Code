function auc = calc_auc_model(model,labelset,dataset)
% dataset=dataset';
labelset(find(labelset==0))=-1;
indexp=find(labelset==1);
indexn=find(labelset==-1);
datasetp=dataset(indexp,:);
datasetn=dataset(indexn,:);

yp=datasetp*model.w'+model.bias;
yn=datasetn*model.w'+model.bias;
%         PreLabel(y>=0,:)=1;
%         PreLabel(y<0,:)=-1;
score=0;
for i=1:size(yp,1)
    for j=1:size(yn,1)
        if yp(i)>=yn(j)
            score=score+1;
        end
    end
end
 auc=score/(size(yp,1)*size(yn,1));
 score=0;
end