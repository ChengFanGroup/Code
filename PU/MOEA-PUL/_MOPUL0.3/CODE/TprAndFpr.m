function [tpr,fpr] = TprAndFpr(model,labeltest,dttest)

dttest=dttest';
label=labeltest';

indexp=find(label==1);
Pdata=dttest(indexp,:);
Plabel=label(indexp); %选择P数据
[~,tpr,~]=predict(Plabel,Pdata,model);%tp/N+
tpr=tpr(1);
indexn=find(label==-1);
Ndata=dttest(indexn,:);
Nlabel=label(indexn); %选择N数据
[~,tnr,~]=predict(Nlabel,Ndata,model);
fpr=100-tnr(1);                        

end

