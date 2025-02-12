function [dataset,whether,name] = LOADdata(s)
%LOADDATA 此处显示有关此函数的摘要
%   此处显示详细说明
        switch s

             case 5
               name = 'appendicitis';
               S = load('..\dataset\appendicitis.mat');%%%导入数据集
               A = S.A;
            case 7777
                name='haberman'; 
                S = load('..\dataset\haberman.mat');%%%导入数据集
                A = S.A;
            case 3       
                name='liver-disorders';
                S = load('..\dataset\liver-disorders.mat');%%%导入数据集
                A = S.A;
            case 1001
                name = 'fourclass';
                S = load('..\dataset\fourclass.mat');%%%导入数据集
                A = [full(S.instance) S.label];
            case 1 
                name = 'mammogra';
                S = load('..\dataset\mammogra.mat');%%%导入数据集
                A = S.A;

            case 1006
                name = 'breast';
                S = load('..\dataset\breast.mat');%%%导入数据集
                A = [full(S.Xtr) S.Ytr];
       
            case 2       
                name = 'heart';
                S = load('..\dataset\heart.mat');%%%导入数据集
                A = S.A;
                %        whether(find(whether==2))=0;%%负样本标签为%%备注正负标签难以分辨，根据实验结果判断应该是正样本比较多。

            case 4
                name = 'wisconsin';
                S = load('..\dataset\wisconsin.mat');%%%导入数据集
                A = S.A;
%                whether(find(whether==2))=0;%%负样本标签为
%                whether(find(whether==4))=1;%%负样本标签为
                

%             case 28
%                 name = 'thyroid1';
%                 A = load('..\dataset\imbalance\thyroid1.csv');%%%导入数据集
% %             case 2
% %                 name = 'thyroid2';
% %                 A = load('..\dataset\imbalance\thyroid2.csv');%%%导入数据集
            case 6
                name = 'ecoli3';
                S = load('..\dataset\imbalance\ecoli3.mat');%%%导入数据集
                A = S.A;
%             case 3
%                 name = 'glass2';
%                 A = load('..\dataset\imbalance\glass2.csv');%%%导入数据集
            case 10
                name = 'glass6';
                A = load('..\dataset\imbalance\glass6.csv');%%%导入数据集
% %             case 6
% %                 name = 'segment0';
% %                 A = load('C:\Users\admin\Desktop\dataset\imbalance\segment0.csv');%%%导入数据集
% %             case 7
% %                 name = 'yeast3';
% %                 A = load('C:\Users\admin\Desktop\dataset\imbalance\yeast3.csv');%%%导入数据集
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--extreme imbalance--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 7
                name = 'abalone19';
                A = load('..\dataset\imbalance\100\abalone19.csv');%%%导入数据集
%             case 32
%                 name = 'kddcup';
%                 A = load('..\dataset\imbalance\100\kddcup-rootkit.csv');%%%导入数据集
%             case 31
%                 name = 'poker';
%                 A = load('..dataset\imbalance\100\poker.csv');%%%导入数据集
%             case 8
%                 name = 'shuttle0';
%                 S = load('..\dataset\shuttle0.mat');%%%导入数据集
%                 A = S.A;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--larger1--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             case 11
%                 name = 'letter';
%                 A = load('..dataset\large\01\letter.csv');%%%导入数据集
%             case 12
%                 name = 'page-block0';
%                 A = load('..\dataset\large\01\page-block0.csv');%%%导入数据集
%             case 13
%                 name = 'penbased';
%                 A = load('..\dataset\large\01\penbased.csv');%%%导入数据集
%             case 14
%                 name = 'magic';
%                 A = load('..\dataset\large\01\magic.csv');%%%导入数据集
            case 13
                name = 'coil2000';
                S = load('..\dataset\large\01\coil2000.mat');%%%导入数据集
                A = S.A;
% %             case 16
% %                 name = 'ring';
% %                 A = load('..\dataset\large\ring.csv');%%%导入数据集
% %             case 15
% %                 name = 'twonorm';
% %                 A = load('..\dataset\large\01\twonorm.csv');%%%导入数据集
%             case 16
%                 name = 'HTRU2';
%                 A = load('..\dataset\large\01\HTRU2.csv');%%%导入数据集
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%--larger2--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             case 31
% %                 name = 'letter01';
% %                 S = load('..\dataset\large\letter.mat');%%%导入数据集
% %                 A = S.A;
% %             case 32
% %                 name = 'wilt';
% %                 A = load('..\dataset\large\wilt.csv');%%%导入数据集
%             case 33
%                 name = 'satimage';
%                 S = load('..\dataset\large\satimage.mat');%%%导入数据集
%                 A = S.A;
%             case 34
%                 name = 'spambase';
%                 S = load('..\dataset\large\spambase.mat');%%%导入数据集
%                 A = S.A;
%             case 35
%                 name = 'phishing';
%                  S = load('..\dataset\large\phishing.mat');%%%导入数据集
%                 A = S.A;
%             case 36
%                 name = 'splice0';
%                 S = load('..\dataset\large\splice0.mat');%%%导入数据集
%                 A = S.A;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--original--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             case 21
%                name = 'appendicitis';
%                S = load('dataset\appendicitis.mat');%%%导入数据集
%                A = S.A;
%             case 22
%                 name='haberman'; 
%                 S = load('..\dataset\haberman.mat');%%%导入数据集
%                 A = S.A;
%             case 23       
%                 name='liver-disorders';
%                 S = load('..\dataset\liver-disorders.mat');%%%导入数据集
%                 A = S.A;
%             case 24
%                 name = 'fourclass';
%                 S = load('..\dataset\fourclass.mat');%%%导入数据集
%                 A = [full(S.instance) S.label];
%             case 25 
%                 name = 'mammogra';
%                 S = load('C:\Users\admin\Desktop\dataset\mammogra.mat');%%%导入数据集
%                 A = S.A;
% 
% %             case 26
% %                 name = 'breast';
% %                 S = load('..\dataset\breast.mat');%%%导入数据集
% %                 A = [full(S.Xtr) S.Ytr];
%        
%             case 26       
%                 name = 'heart';
%                 S = load('..\dataset\heart.mat');%%%导入数据集
%                 A = S.A;
%                 %        whether(find(whether==2))=0;%%负样本标签为%%备注正负标签难以分辨，根据实验结果判断应该是正样本比较多。
% 
%             case 27
%                 name = 'wisconsin';
%                 S = load('..\dataset\wisconsin.mat');%%%导入数据集
%                 A = S.A;
%                 %        whether(find(whether==2))=0;%%负样本标签为
%                 %        whether(find(whether==4))=1;%%负样本标签为
%                 
%             case 101
%                 name = 'Half-kernel';
%                 S = load('..\dataset\Half-kernel-i.mat');%%%导入数据集
%                 A = S.A;
%             case 102
%                 name = 'Full-Moon';
%                 S = load('..\dataset\Full-Moon.mat');%%%导入数据集
%                 A = S.A;
%             case 103
%                 name = 'outlier';
%                 S = load('..\dataset\outlier-i.mat');%%%导入数据集
%                 A = S.A;
%             case 104
%                 name = 'twospirals';
%                 S = load('..\dataset\twospirals-i.mat');%%%导入数据集
%                 A = S.A;
%             case 107
%                 name = 'corners';
%                 S = load('..\dataset\corners-i.mat');%%%导入数据集
%                 A = S.A;


        end
                dataset = A(:,1:end-1)' ;%instance          %%行为特征数85，列为数据量9822  正样本数为586
                whether =  A(:,end)';%label
                whether(whether == -1) = 0;
                whether(whether == 2) = 0;
                whether(whether == 4) = 1;

                [whether,index] = sort(whether);
                dataset = dataset(:,index);
%                 dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
%                 dataset = dataset';
end
                
            

