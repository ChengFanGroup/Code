function auc = calc_auc(gnd, pred) 
[A,I] = sort(pred); 
P = 0;
N = 0; 
for i = 1:length(pred) 
    if(gnd(i) == 1) 
        P = P+1;  %正类样本数
    else 
        N = N+1;  %负类样本数
    end 
end 
rankP = 0; 
for i = P+N:-1:1 
    if(gnd(I(i)) == 1) 
        rankP = rankP+i;  %正类样本rank相加 
    end 
end
auc=(rankP-(P+1)*P/2)/(P*N); 