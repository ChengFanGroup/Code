function [tempkGenArchive] = disEva(arChive)
% 对特征子集做“距离”评价
%   此处显示详细说明
global data label trIdx;

[M,~] = size(arChive);
tempkGenArchive = zeros(1,M); % 距离结果
tempkGenArchive2 = zeros(1,M); % 距离结果00

trlabel = label(trIdx,:);
% temp = zeros(1,size(DM,1));
for j = 1:1:M % arChive中的每一个特征子集
    featIdx = arChive(j,:);
    D = pdist(data(trIdx,featIdx));
    DM = squareform(D);
    
    farHit = zeros(1,size(DM,1));
    nearMiss = zeros(1,size(DM,1));
    for i = 1:size(DM,1)
        sameClassIdx = trlabel(:,:)==trlabel(i,:);
        otherClassIdx = ~sameClassIdx;

%         sameClassOrder = sort(DM(i,sameClassIdx), 'descend');
%         otherClassOrder  = sort(DM(i,otherClassIdx),'ascend');
%         farHit(i) = sameClassOrder(1);
%         nearMiss(i) = otherClassOrder(1);
        farHit(i) = max(DM(i,sameClassIdx));
        nearMiss(i) = min(DM(i,otherClassIdx));
    end
%     tempkGenArchive(1,j) = mean(farHit-nearMiss) / sum(arChive(j,:));
    len = length(farHit);
    tmpCom = [farHit,nearMiss];
    tmpComNom = mapminmax(tmpCom,0,1);
    farHitNom = tmpComNom(1:len);
    nearMissNom = tmpComNom(len+1:end);
%     tempkGenArchive(1,j) = mean(farHitNom-nearMissNom); %越大越好
    tempkGenArchive(1,j) = mean(nearMissNom./farHitNom);
    
%     if ~isempty(find((farHitNom-nearMissNom)<=0))
%         error('error!');
end
        
end

% end % function

