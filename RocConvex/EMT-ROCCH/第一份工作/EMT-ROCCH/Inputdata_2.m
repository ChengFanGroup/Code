function [dataset,labelset,name,generation,Rep,JLInterval] = Inputdata_2(s)
%INPUTDATA 此处显示有关此函数的摘要
%   此处显示详细说明
    filepath = 'C:\Users\admin\Desktop\';
    
    Rep = 2;
    generation = 750;
    JLInterval = 250;
    
   switch s
        case 12
            name = 'Dexter';
            dataset = load([filepath,'data_large\Dexter\Dexter_full.csv']);
            labelset = load([filepath,'data_large\Dexter\Dexter_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
       case 10
            name = 'ARB';
            dataset = load([filepath,'data_large\ARB\ARB.csv']);
            labelset = load([filepath,'data_large\ARB\ARB_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;

        case 7
            name = 'RELATHE';
            s = load([filepath,'data_large\RELATHE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;

        case 6
            name = 'PCMAC';
            s = load([filepath,'data_large\PCMAC.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
        case 8
            name = 'BASEHOCK';
            s = load([filepath,'data_large\BASEHOCK.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;

        case 5
            name = 'IADS';
            dataset = load([filepath,'data_large\IADS\ad.csv']);
            labelset = load([filepath,'data_large\IADS\ad_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 3
            name = 'qsar';
            dataset = load([filepath,'data_large\qsar\qsar.csv']);
            labelset = load([filepath,'data_large\qsar\qsar_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
         %   Rep = 1;
        case 11
            name = 'SMK_CAN_187';
            s = load([filepath,'data_large\SMK_CAN_187.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
         case 14
            name = 'FaceBook';
            dataset = load([filepath,'data_large\FaceBook\FaceBook.csv']);
            labelset = load([filepath,'data_large\FaceBook\FaceBook_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 13
            name = 'gisette';
            s = load([filepath,'data_large\gisette.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==-1) = 0;
        case 9
            s = load([filepath,'data_large\Prostate_GE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            name = 'PGE';
        case 4
            name = 'Malware';
            dataset = load([filepath,'data_large\Malware\data.csv']);
            labelset = load([filepath,'data_large\Malware\label.csv']);
            dataset = dataset';
            labelset = labelset';
       case 2
            name = 'pd_speech';
            dataset = load([filepath,'data_large\small\pd_speech\pd_speech.csv']);
            labelset = load([filepath,'data_large\small\pd_speech\pd_speech_label.csv']);
            dataset = dataset';
            labelset = labelset';
           % Rep = 1;
        case 1
            name = 'secom';
            dataset = load([filepath,'data_large\small\secom\secom.csv']);
            labelset = load([filepath,'data_large\small\secom\secom_label.csv']);
            dataset = dataset';
            labelset = labelset';

    end
    
         %%%%%————————————————————————————————
    
            dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
            dataset = dataset';
            
end

