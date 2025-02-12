function [dataset,labelset,name,Rep] = Inputdata1(s)
%INPUTDATA 此处显示有关此函数的摘要
%   此处显示详细说明
    filepath = 'C:/Users/admin/Desktop/';
    Rep = 1;
    
    switch s
       case 1
            name = 'qsar';
            dataset = load([filepath,'data_large/qsar/qsar.csv']);
            labelset = load([filepath,'data_large/qsar/qsar_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 2
            name = 'Malware';
            dataset = load([filepath,'data_large/Malware/data.csv']);
            labelset = load([filepath,'data_large/Malware/label.csv']);
            dataset = dataset';
            labelset = labelset';
        case 3
            name = 'IADS';
            dataset = load([filepath,'data_large/IADS/ad.csv']);
            labelset = load([filepath,'data_large/IADS/ad_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 4
            name = 'PCMAC';
            s = load([filepath,'data_large/PCMAC.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
        case 5
            name = 'RELATHE';
            s = load([filepath,'data_large/RELATHE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
        case 6
            name = 'BASEHOCK';
            s = load([filepath,'data_large/BASEHOCK.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
        case 7
            s = load([filepath,'data_large/Prostate_GE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            name = 'PGE';
       case 8
            name = 'ARB';
            dataset = load([filepath,'data_large/ARB/ARB.csv']);
            labelset = load([filepath,'data_large/ARB/ARB_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 9
            name = 'SMK_CAN_187';
            s = load([filepath,'data_large/SMK_CAN_187.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 10
            name = 'Dexter';
            dataset = load([filepath,'data_large/Dexter/Dexter_full.csv']);
            labelset = load([filepath,'data_large/Dexter/Dexter_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 11
            name = 'FaceBook';
            dataset = load([filepath,'data_large/FaceBook/FaceBook.csv']);
            labelset = load([filepath,'data_large/FaceBook/FaceBook_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            Rep = 1;
        case 12
            name = 'gisette';
            s = load([filepath,'data_large/gisette.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==-1) = 0;
            Rep = 1;
            
    end
    
         %%%%%————————————————————————————————
    
            dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
            dataset = dataset';
            
            
end

