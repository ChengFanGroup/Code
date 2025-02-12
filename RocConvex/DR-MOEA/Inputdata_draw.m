function [dataset,labelset,name,generation,Rep,JLInterval] = Inputdata_draw(s)
%INPUTDATA 此处显示有关此函数的摘要
%   此处显示详细说明
   switch s
        
        case 11
            name = 'Dexter';
            dataset = load('C:\Users\Admin\Desktop\data_large\Dexter\Dexter_full.csv');
            labelset = load('C:\Users\Admin\Desktop\data_large\Dexter\Dexter_label.csv');
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 600;
            Rep = 10;
            JLInterval = 10;
       case 10
            name = 'ARB';
            dataset = load('C:\Users\Admin\Desktop\data_large\ARB\ARB.csv');
            labelset = load('C:\Users\Admin\Desktop\data_large\ARB\ARB_label.csv');
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 400;
            Rep = 10;
            JLInterval = 10;
        case 24%8
            name = 'RELATHE';
            s = load('C:\Users\Admin\Desktop\data_large\RELATHE.mat');
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
            generation = 800;
            JLInterval = 20;
            Rep = 10;
        case 4
            name = 'PCMAC';
            s = load('C:\Users\Admin\Desktop\data_large\PCMAC.mat');
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
            generation = 1000;
            Rep = 20;
            JLInterval = 20;
        case 6
            name = 'BASEHOCK';
            s = load('C:\Users\Admin\Desktop\data_large\BASEHOCK.mat');
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
            generation = 1200;
            Rep = 5;
            JLInterval = 20;
        case 3
            name = 'IADS';
            dataset = load('C:\Users\Admin\Desktop\data_large\IADS\ad.csv');
            labelset = load('C:\Users\Admin\Desktop\data_large\IADS\ad_label.csv');
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 1000;
            Rep = 20;
            JLInterval = 20;
        case 1
            name = 'qsar';
            dataset = load('C:\Users\Admin\Desktop\data_large\qsar\qsar.csv');
            labelset = load('C:\Users\Admin\Desktop\data_large\qsar\qsar_label.csv');
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 100;
            Rep = 30;
            JLInterval = 5;
        case 5
            name = 'SMK_CAN_187';
            s = load('C:\Users\Admin\Desktop\data_large\SMK_CAN_187.mat');
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 100;
            Rep = 20;
            JLInterval = 5;
         case 12
            name = 'FaceBook';
            dataset = load('C:\Users\Admin\Desktop\data_large\FaceBook\FaceBook.csv');
            labelset = load('C:\Users\Admin\Desktop\data_large\FaceBook\FaceBook_label.csv');
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            generation = 800;
            Rep = 5;
            JLInterval = 20;
        case 9
            name = 'gisette';
            s = load('C:\Users\Admin\Desktop\data_large\gisette.mat');
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==-1) = 0;
            generation = 800;
            Rep = 10;
            JLInterval = 20;
        case 7
            s = load('C:\Users\Admin\Desktop\data_large\Prostate_GE.mat');
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            name = 'PGE';
            generation = 100;
            Rep = 20;
            JLInterval = 5;
        case 2
            name = 'Malware';
            dataset = load('C:\Users\Admin\Desktop\data_large\Malware\data.csv');
            labelset = load('C:\Users\Admin\Desktop\data_large\Malware\label.csv');
            dataset = dataset';
            labelset = labelset';
            generation = 800;
            Rep = 10;
            JLInterval = 20;
    end
    
         %%%%%————————————————————————————————
    
            dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
            dataset = dataset';
            
end

