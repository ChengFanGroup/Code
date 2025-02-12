function [pacc,nacc,pnacc] = PandNinU(model,labelUN,dataUN)

dttest=dataUN';
label=labelUN;
label(find(label==0))=-1;
indexp=find(label==1);
Pdata=dttest(indexp,:);
Plabel=label(indexp); %选择P数据
% [~,pacc,~]=predict(Plabel,sparse(Pdata),model);%tp/N+
% pacc=pacc(1);
indexn=find(label==-1);
Ndata=dttest(indexn,:);
Nlabel=label(indexn); %选择N数据
% [~,tnr,~]=predict(Nlabel,sparse(Ndata),model);
% nacc=tnr(1);                         %fp/N-
[pred,pnac,~]=predict(label,sparse(dttest),model);
pnacc=pnac(1);
p_pred=pred(indexp,:);
n_pred=pred(indexn,:);
pacc=length(find(p_pred==Plabel))/length(Plabel);
nacc=length(find(n_pred==Nlabel))/length(Nlabel);

end
