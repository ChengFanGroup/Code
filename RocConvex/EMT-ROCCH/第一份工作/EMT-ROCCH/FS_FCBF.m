function [selectedFeatures]=FS_FCBF(features,labels,threshold)
%输入：
%features:输入的特征数据
%labels：输入的标签数据
%threshold:选择阈值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输出：
%selectedFeatures：输出最优的特征子集
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%By Tang Xianyu
 
%% 主函数
n_feat=size(features,2);%特征的个数
%n_samp=size(features,1);%采样的个数
 
classScore=zeros(n_feat,1);%初始化SUic的向量值为0
 
%t1=cputime;
for i=1:n_feat
    classScore(i)=SuCal(features(:,i),labels);%计算每个特征的SUic值
end
 
[classScore, indexScore]=sort(classScore,1,'descend');%将计算的SUic值降序排列
indexScore=indexScore(classScore>threshold);%删除小于阈值的特征
classScore=classScore(classScore>threshold);%删除小于阈值的特征
 
if ~isempty(indexScore)%判断是否为空
    curPosition=1;
else
    curPosition=0;
end
 
while curPosition<=length(indexScore)
    j=curPosition+1;
    preFeature=indexScore(curPosition);%确定已选择的主特征
        
    while j<length(indexScore)
        scoreFiFj=SuCal(features(:,indexScore(j)),features(:,preFeature));%计算特征间的SU值
        if scoreFiFj>classScore(j)
            indexScore(j)=[];%如果SUij>SUic，则删除该特征
            classScore(j)=[];%删除该特征后，后面的特征自动向前移动一位，所以不用j+1
         else
            j=j+1;%不删除特征情况下，j需要加1
        end
    end
        curPosition=curPosition+1;
end
selectedFeatures=indexScore;%最终赋值
selectedFeatures = sort(selectedFeatures);
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SU计算函数
function SU=SuCal(f1,f2)
h1=h(f1);
h2=h(f2);
ig=mi(f1,f2);
SU=2.0*ig/(h1+h2);
end

