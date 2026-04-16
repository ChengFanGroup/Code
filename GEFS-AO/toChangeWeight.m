function toChangeWeight(kGenWeiArchive, kGenAccArchive,arChive)
% 根据前k代距离评价，改变节点权重

global vWeight1;

% addVal = kGenWeiArchive.*kGenAccArchive;
% % % addVal = sqrt(addVal);
% % a = reshape(addVal',1,size(arChive,1));
% % w0 = a*arChive;
% 
% % addVal = (1-kGenWeiArchive).*kGenAccArchive;
% % addVal = sqrt(addVal);
% a = reshape(addVal',1,size(arChive,1));
% w0 = a*arChive;
% % vWeight = [vWeight;vWeight+w0];
% vWeight = [vWeight+w0];

%% 尝试不考虑精度的情况下，只考虑样本空间距离评价来更新权重
w0 = kGenWeiArchive*arChive;
vWeight1 = [vWeight1+w0];
end
