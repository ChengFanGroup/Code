function [dataset,labelset,name,generation,Rep,JLInterval] = Inputdata_2M(s)
%INPUTDATA 此处显示有关此函数的摘要
%   此处显示详细说明
    filepath = 'C:\Users\admin\Desktop\';
   switch s
        
        case 11
            name = 'Dexter';
            dataset = load([filepath,'data_large\Dexter\Dexter_full.csv']);
            labelset = load([filepath,'data_large\Dexter\Dexter_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 1200;
            Rep = 10;
            JLInterval = 10;
       case 10
            name = 'ARB';
            dataset = load([filepath,'data_large\ARB\ARB.csv']);
            labelset = load([filepath,'data_large\ARB\ARB_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 800;
            Rep = 10;
            JLInterval = 10;
        case 8
            name = 'RELATHE';
            s = load([filepath,'data_large\RELATHE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
            generation = 1600;
            JLInterval = 20;
            Rep = 10;
        case 4
            name = 'PCMAC';
            s = load([filepath,'data_large\PCMAC.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
            generation = 2000;
            Rep = 10;
            JLInterval = 20;
        case 6
            name = 'BASEHOCK';
            s = load([filepath,'data_large\BASEHOCK.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
            generation = 2400;
            Rep = 10;
            JLInterval = 20;
        case 3
            name = 'IADS';
            dataset = load([filepath,'data_large\IADS\ad.csv']);
            labelset = load([filepath,'data_large\IADS\ad_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 2000;
            Rep = 20;
            JLInterval = 20;
        case 1
            name = 'qsar';
            dataset = load([filepath,'data_large\qsar\qsar.csv']);
            labelset = load([filepath,'data_large\qsar\qsar_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 200;
            Rep = 20;
            JLInterval = 5;
        case 5
            name = 'SMK_CAN_187';
            s = load([filepath,'data_large\SMK_CAN_187.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 200;
            Rep = 20;
            JLInterval = 5;
         case 12
            name = 'FaceBook';
            dataset = load([filepath,'data_large\FaceBook\FaceBook.csv']);
            labelset = load([filepath,'data_large\FaceBook\FaceBook_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 1600;
            Rep = 5;
            JLInterval = 20;
        case 9
            name = 'gisette';
            s = load([filepath,'data_large\gisette.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==-1) = 0;
            generation = 1600;
            Rep = 5;
            JLInterval = 20;
        case 7
            s = load([filepath,'data_large\Prostate_GE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            name = 'PGE';
            generation = 200;
            Rep = 20;
            JLInterval = 5;
        case 2
            name = 'Malware';
            dataset = load([filepath,'data_large\Malware\data.csv']);
            labelset = load([filepath,'data_large\Malware\label.csv']);
            dataset = dataset';
            labelset = labelset';
            generation = 1600;
            Rep = 10;
            JLInterval = 20;
    end
    
         %%%%%————————————————————————————————
    
            dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
            dataset = dataset';
            
end

