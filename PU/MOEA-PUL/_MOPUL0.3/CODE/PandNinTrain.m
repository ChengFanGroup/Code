function [pacc,nacc,pnacc] = PandNinTrain(model,labeltrain,datasettrain,A)

labeltrain(find(labeltrain==0))=-1;
[pred,pnac,~]=predict(labeltrain,sparse(datasettrain),model);
B=setdiff([1:size(datasettrain,1)],A);
labelUN=labeltrain(B);
dataUN=datasettrain(B,:);
predUN=pred(B);


indexp=find(labelUN==1);
Pdata=dataUN(indexp,:);
Plabel=labelUN(indexp); %选择P数据
% [~,pacc,~]=predict(Plabel,sparse(Pdata),model);%tp/N+
% pacc=pacc(1);
indexn=find(labelUN==-1);
Ndata=dataUN(indexn,:);
Nlabel=labelUN(indexn); %选择N数据
% [~,tnr,~]=predict(Nlabel,sparse(Ndata),model);
% nacc=tnr(1);                         %fp/N-
% [pred,pnac,~]=predict(label,sparse(dttest),model);
pnacc=length(find(predUN==labelUN))/length(labelUN);
p_pred=predUN(indexp,:);
n_pred=predUN(indexn,:);
pacc=length(find(p_pred==Plabel))/length(Plabel);
nacc=length(find(n_pred==Nlabel))/length(Nlabel);

end
