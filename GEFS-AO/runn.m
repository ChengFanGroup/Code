function [R1,R2,datasetName,HV_test] = runn(dataIdx, RUNS)
%% 预处理



global data label;
global trIdx teIdx;
global featNum;
global Zout Zout2 Zout3;
global vWeight vWeight1;
global Weic ght Ecout;
global trData trLabel teData teLabel;
global assiNumInside; % 查看Archive中保留的第一前沿面解的个数 
global archievepop1;

%% 数据导入0

[condata,~, label, datasetName] = myinputdatasetXD(dataIdx);
conData=condata(:,2:end);
conData = mapminmax(conData',0,1)';
    conData(isnan(conData)) = 0;



archievepop1 =[];
[ACC, FNUM] = deal(zeros(RUNS, 1));
FSET = cell(RUNS+2,1);

assiNum = zeros(RUNS,1);

%% 参数设置 数据划分
zData = mapminmax(conData',0,1)'; % 使用该函数注意转置
data = zData;
% zData = zscore(conData);
featNum = size(zData, 2);

THRESHOLD = 0.6; % 切边阈值
T = zeros(RUNS,1);
kNeigh = 1;
HV_test=zeros(RUNS,1);
R1=zeros(RUNS,3);
R2=zeros(RUNS,3);
for Rtimes = 1:RUNS
     rng(Rtimes)
    Ecout=0;
    fprintf('----第%d次--------\n',Rtimes );

    assiNumInside = 0; %重置
    tic;

    row = size(zData,1);    R = randperm(row);
    trIdx = zeros(row, 1);
    trIdx(R(1:round(row*0.7)),:) = 1;
    teIdx = ~trIdx;
    trIdx = logical(trIdx);

    trData = zData(trIdx,:);trLabel = label(trIdx);
    teData = zData(teIdx,:);teLabel = label(teIdx);
    


    [~,vWeight0] = fisherScore(trData,trLabel);% 全部特征上计算权重
    vWeight = 1+mapminmax(vWeight0,0,1); %% +1，确保不为0
    vWeight1=vWeight;
    



    %%相关性
   
    


    adj = 1-pdist(trData', 'correlation'); % 转置以计算特征相关性
    adj(isnan(adj))=0;

    adj = abs(adj);
    
    
    adj = 1- adj;
    adj = 1./(1+exp(-zscore(adj)));  
    Zout = squareform( adj);

    %=====================2019-12-12
    %增加的K近邻特征判断
    kNeiMatrix = zeros(featNum,kNeigh);
    kNeiZoutMode = zeros(size(Zout));
    
    for i = 1:size(Zout,1)
        [~,I] = sort(Zout(i,:),'descend');
        idx = I(1:kNeigh);   
        kNeiMatrix(i,:) = idx;
        kNeiZoutMode(i,idx) = 1;
    end
%     kNeiZoutMode=kNeiZoutMode+kNeiZoutMode';
    
    kNeiZout1 = logical(kNeiZoutMode);
    %kNeiAdj = squareform(kNeiZout);



    adj2 = 1-pdist(trData', 'cosine'); % 转置以计算特征相关性
    adj2(isnan(adj2))=0;

    adj2 = abs(adj2);
    
    
%     adj = 1- adj;
%     adj = 1./(1+exp(-zscore(adj)));  
    Zout2 = squareform( adj2);

    %=====================2019-12-12
    %增加的K近邻特征判断
    kNeiMatrix2 = zeros(featNum,kNeigh);
    kNeiZoutMode2 = zeros(size(Zout2));
    
    for i = 1:size(Zout2,1)
        [~,I] = sort(Zout2(i,:),'descend');
        idx = I(1:kNeigh);   
        kNeiMatrix2(i,:) = idx;
        kNeiZoutMode2(i,idx) = 1;
    end
%     kNeiZoutMode=kNeiZoutMode+kNeiZoutMode';
    
    kNeiZout2 = logical(kNeiZoutMode2);
    %kNeiAdj = squareform(kNeiZout);



    adj3 = 1-pdist(trData', 'spearman'); % 转置以计算特征相关性
    adj3(isnan(adj3))=0;

    adj3 = abs(adj3);
    
    
%     adj = 1- adj;
%     adj = 1./(1+exp(-zscore(adj)));  
    Zout3 = squareform( adj3);

    %=====================2019-12-12
    %增加的K近邻特征判断
    kNeiMatrix3 = zeros(featNum,kNeigh);
    kNeiZoutMode3 = zeros(size(Zout3));
    
    for i = 1:size(Zout3,1)
        [~,I] = sort(Zout3(i,:),'descend');
        idx = I(1:kNeigh);   
        kNeiMatrix3(i,:) = idx;
        kNeiZoutMode3(i,idx) = 1;
    end
%     kNeiZoutMode=kNeiZoutMode+kNeiZoutMode';
    
    kNeiZout3 = logical(kNeiZoutMode3);
    %kNeiAdj = squareform(kNeiZout);




    g1 = kNeiZout1;
    g2 = kNeiZout2;
    g3 = kNeiZout3;


    
    [acc1,acc2,featsize1,hv_test] = newEA(g1,g2,g3,50,100);
    
    
    T=toc;
    HV_test(Rtimes,1)=hv_test;
    R1(Rtimes,1)=1-acc1;R1(Rtimes,2)=featsize1;R1(Rtimes,3)=T;
    R2(Rtimes,1)=1-acc2;R2(Rtimes,2)=featsize1;R2(Rtimes,3)=T;

end

end