K=5;% the indices number of K-fold

dataname = 'usps';

load(strcat(dataname,'.mat'));
datasetsource =  instance';
labely =  label';
labely(find(labely==-1))=0;% make the negative label be 0

Indices        =  crossvalind('Kfold', size(datasetsource,2), K);
datasetsource  =  datasetsource';
p = 0.3;


for i  =  1:K
    %---------Divide datasets into test sets and training sets--------------
    datasettrain  =  datasetsource(find(Indices~=i),:);% 5-fold
    datasettrain  =  datasettrain';
    labeltrain  =  labely(find(Indices~=i));
    datasettest  =  datasetsource(find(Indices==i),:);
    datasettest  =  datasettest';
    labeltest  =  labely(find(Indices==i));
    
    [dataPositive,labelPositive,dataUN,labelUN]=Data_Transform(datasettrain,labeltrain,p);

    for j=1:size(mode(i).mdl,2)
        
        
        dttest=dataUN';
        label=labelUN;
        label(find(label==0))=-1;
        indexp=find(label==1);
        Pdata=dttest(indexp,:);
        Plabel=label(indexp); %选择P数据
        % [~,pacc,~]=predict(Plabel,sparse(Pdata),model);%tp/N+
        % pacc=pacc
        indexn=find(label==-1);
        Ndata=dttest(indexn,:);
        Nlabel=label(indexn); %选择N数据
        % [~,tnr,~]=predict(Nlabel,sparse(Ndata),model);
        % nacc=tnr(1);                         %fp/N-
        [pred,pnac,~]=predict(label,sparse(dttest),mode(i).mdl(j));
        pnacc=pnac(1);
        p_pred=pred(indexp,:);
        n_pred=pred(indexn,:);
        pacc=length(find(p_pred==Plabel))/length(Plabel);
        nacc=length(find(n_pred==Nlabel))/length(Nlabel);
        Pareto_u(j,1)=pacc; %U中正类精度
        Pareto_u(j,2)=nacc; %U中负类精度
        Pareto_u(j,3)=pnacc./100;%U中的总体精度
        %       计算测试集和U中的
%         pnauc = calc_auc_model(model(i).mdl(j),labeltest',datasettest');
%         Pareto_u(i,4)=pnauc;%测试集上的AUC
         %       计算测试集和U中的
        testauc = calc_auc_model(mode(i).mdl(j),labeltest',datasettest');
        pnauc=calc_auc_model(mode(i).mdl(j),labelUN,dataUN');
        Pareto_auc(j,1)=testauc;%测试集上的AUC
        Pareto_auc(j,2)=pnauc;
    end
    uacc(i).u=[]; %记录U中的精度
    uacc(i).u=Pareto_u;
    Pareto_u=[];
    
    auc(i).u=[]; %记录auc
    auc(i).u=Pareto_auc;
    Pareto_auc=[];
end
save('D:\_MOPUL\Code\MO-PUL\aucInTestandU\usps','auc');   