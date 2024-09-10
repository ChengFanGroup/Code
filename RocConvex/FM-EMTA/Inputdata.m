function [dataset,labelset,name,Rep] = Inputdata(s)
%INPUTDATA 此处显示有关此函数的摘要
%   此处显示详细说明
    filepath = '';
    Rep = 5;
    
    switch s
        case 1
            name = 'secom';
            dataset = load([filepath,'data_large/small/secom/secom.csv']);
            labelset = load([filepath,'data_large/small/secom/secom_label.csv']);
            dataset = dataset';
            labelset = labelset';
       
      case 13
            name = 'madelon';
            s = load([filepath,'data_large/small/madelon.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=1) = 0;
       case 2
            name = 'qsar';
            dataset = load([filepath,'data_large/qsar/qsar.csv']);
            labelset = load([filepath,'data_large/qsar/qsar_label.csv']);
            dataset = dataset';
            labelset = labelset';
            labelset(labelset==1)=0;labelset(labelset==2)=1;

        case 3
            name = 'PCMAC';
            s = load([filepath,'data_large/PCMAC.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset~=2) = 0;
            labelset(labelset==2) = 1;
        case 4
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
        case 9
            s = load([filepath,'data_large/Prostate_GE.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
            name = 'PGE';

        case 12
            name = 'SMK_CAN_187';
            s = load([filepath,'data_large/SMK_CAN_187.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;

        case 7
            name = 'p53';
            dataset = load([filepath,'data_large/p53/data.csv']);
            labelset = load([filepath,'data_large/p53/label.csv']);
            dataset = dataset';
            labelset = labelset';
        case 10
            name = 'arcene';
            s = load([filepath,'data_large/arcene.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==-1) = 0;
        case 8
            name = 'TOX_171';
            s = load([filepath,'data_large/TOX_171.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
        case 11
            name = 'CLLSUB111';
            s = load([filepath,'data_large/CLLSUB111.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';

        case 5
            name = 'GLIOMA';
            s = load([filepath,'data_large/GLIOMA.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            
    end
    
         %%%%%————————————————————————————————
    
            dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
            dataset = dataset';
            
            
end

