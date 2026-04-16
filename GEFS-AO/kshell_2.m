function [p] = kshell_2(Gadj0)
%UNTITLED2 改进的k-shell 从网络中提取特征子集
%   参夸基本的k-shell 算法
global  featNum ;
global vWeight1;
% Gadj 是邻接矩阵
% global featMAXCG;
Gadj = Gadj0; %副本
[~,M] = size(Gadj);
featSeq = 1:1:M;
% G = graph( Gadj,'upper');
bucket = {};

temp = [];
it = 1;
bucketidx = 1;
while(~isempty(featSeq)) % 循环直至所有点被删除

    D = my_degree(Gadj,featSeq);
%     DD = degree(G);
%     ADD = [D,DD]
    minD = min(D);
    if sum(isnan(D))
%         save('1.mat',"D");
%          save('w.mat',"vWeight1");
        error('计算出现Nan');
    end
    while(true)
        
        feat = find(D==minD); %找到度等于minD的节点

        if (~length(feat))
            bucket{bucketidx,1} = temp';
            temp = [];
            bucketidx = bucketidx+1;
            it = it+1;
            break; %跳出
        else
            a = featSeq(feat);
            temp = [temp,a];
            featSeq(feat) = [];        
%             G = rmnode(G, feat); % 耗时
%             G = graph( Gadj(featSeq,featSeq),'upper'); % 同样很耗时
            Gadj(feat,:) = 0;
            Gadj(:,feat) = 0; %对应点的所有相连边的权重置0，等同删点
            D = my_degree(Gadj,featSeq);
        end
    end
end



% 
% feat =MAXCG2FS(bucket,Gadj);


[Nbkt,~] = size(bucket);
if Nbkt>1
    feat=select(bucket);
    p = [feat,bucket{Nbkt,1}'];
else
    p = bucket{Nbkt,1}';
end

p = sort(p);
sumc = sum(Gadj0(:,p));
[w,re] = sort(sumc,2,'descend');
post = find(w > 0);
qe = length(post);
if qe > ceil(sqrt(featNum))
   qe = ceil(sqrt(featNum));
end
p = p(re(:,1:qe));




end