function [dataset,labelset,name,Rep] = Inputdata(s)
%INPUTDATA 此处显示有关此函数的摘要
%   此处显示详细说明
    filepath = 'C:/Users/admin/Desktop/';
    Rep = 5;
    
    switch s
        case 1
            name = 'secom';
            dataset = load([filepath,'data_large/small/secom/secom.csv']);
            labelset = load([filepath,'data_large/small/secom/secom_label.csv']);
            dataset = dataset';
            labelset = labelset';
            %Rep = 1;
%        case 2
%             name = 'pd_speech';
%             dataset = load([filepath,'data_large/small/pd_speech/pd_speech.csv']);
%             labelset = load([filepath,'data_large/small/pd_speech/pd_speech_label.csv']);
%             dataset = dataset';
%             labelset = labelset';
           % Rep = 3;
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
%         case 24
%             name = 'Malware';
%             dataset = load([filepath,'data_large/Malware/data.csv']);
%             labelset = load([filepath,'data_large/Malware/label.csv']);
%             dataset = dataset';
%             labelset = labelset';
%         case 14
%             name = 'IADS';
%             dataset = load([filepath,'data_large/IADS/ad.csv']);
%             labelset = load([filepath,'data_large/IADS/ad_label.csv']);
%             dataset = dataset';
%             labelset = labelset';
%             labelset(labelset==1)=0;labelset(labelset==2)=1;
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
%        case 7
%             name = 'ARB';
%             dataset = load([filepath,'data_large/ARB/ARB.csv']);
%             labelset = load([filepath,'data_large/ARB/ARB_label.csv']);
%             dataset = dataset';
%             labelset = labelset';
%             labelset(labelset==1)=0;labelset(labelset==2)=1;
        case 12
            name = 'SMK_CAN_187';
            s = load([filepath,'data_large/SMK_CAN_187.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
            labelset(labelset==1)=0;labelset(labelset==2)=1;
%         case 12
%             name = 'Dexter';
%             dataset = load([filepath,'data_large/Dexter/Dexter_full.csv']);
%             labelset = load([filepath,'data_large/Dexter/Dexter_label.csv']);
%             dataset = dataset';
%             labelset = labelset';
%             labelset(labelset==1)=0;labelset(labelset==2)=1;
%         case 13
%             name = 'FaceBook';
%             dataset = load([filepath,'data_large/FaceBook/FaceBook.csv']);
%             labelset = load([filepath,'data_large/FaceBook/FaceBook_label.csv']);
%             dataset = dataset';
%             labelset = labelset';
%             labelset(labelset==1)=0;labelset(labelset==2)=1;
%             Rep = 3;
%         case 14
%             name = 'gisette';
%             s = load([filepath,'data_large/gisette.mat']);
%             dataset = (s.X)';
%             labelset = (s.Y)';
%             labelset(labelset==-1) = 0;
%             Rep = 3;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 7
            name = 'p53';
            dataset = load([filepath,'data_large/p53/data.csv']);
            labelset = load([filepath,'data_large/p53/label.csv']);
            dataset = dataset';
            labelset = labelset';
%        case 22
%             name = 'qsar_oral';
%             dataset = load([filepath,'data_large/qsar_oral/qsar_oral.csv']);
%             labelset = load([filepath,'data_large/qsar_oral/qsar_oral_label.csv']);
%             dataset = dataset';
%             labelset = labelset';
%             labelset(labelset==2)=0;
%         case 23
%             name = 'ALLAML';
%             s = load([filepath,'data_large/ALLAML.mat']);
%             dataset = (s.X)';
%             labelset = (s.Y)';
%             labelset(labelset==2) = 0;
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
%         case 19
%             name = 'GLI_85';
%             s = load([filepath,'data_large/GLI_85.mat']);
%             dataset = (s.X)';
%             labelset = (s.Y)';
%         case 20
%             name = 'nci9';
%             s = load([filepath,'data_large/nci9.mat']);
%             dataset = (s.X)';
%             labelset = (s.Y)';
        case 5
            name = 'GLIOMA';
            s = load([filepath,'data_large/GLIOMA.mat']);
            dataset = (s.X)';
            labelset = (s.Y)';
%         case 22
%             name = 'lymphoma';
%             s = load([filepath,'data_large/lymphoma.mat']);
%             dataset = (s.X)';
%             labelset = (s.Y)';
            
    end
    
         %%%%%————————————————————————————————
    
            dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化
            dataset = dataset';
            
            
end

