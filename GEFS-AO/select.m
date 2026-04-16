function p=select(bucket)
global vWeight;
[M,~]=size(bucket);
p=[];
% feat=[];
for i=1:1:M-1
%     feat=[feat,bucket{i}'];
    feat=bucket{i}';
    featweg=vWeight(feat);
    [~,idx]=sort(featweg,'descend');
    p=[p,feat(idx(1))];
end

% featweg=vWeight(feat);
% [~,idx]=sort(featweg,'descend');
% p=[p,feat(idx(1))];   