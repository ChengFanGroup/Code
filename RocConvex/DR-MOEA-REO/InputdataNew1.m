 function [dataset,labelset,name,generation,Rep,JLInterval] = InputdataNew(s)
%INPUTDATANEW 导入数据集为最新留下数据集
%

filepath = 'C:\Users\GGbond\Desktop\师兄代码\数据\';
switch s
    case 1
        name='australian';
        %导入australian数据集
        [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,labelset] =textread('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\australian.txt','%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
        labelset=labelset';
        dataset=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14];
        dataset=dataset';
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 2
        load('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\ecoli3.mat');%%%导入数据集
        dataset = A(:,1:end-1)' ;%instance          %%行为特征数7，列为数据量336
        labelset =  A(:,end)';%label
        name='ecoli3';
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 3
        name='sonarall';
        %导入sonarall的数据集,R设为0，M设为1
        % function [dataset,whether]=inputdataset()
        [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A40,A41,A42,A43,A44,A45,A46,A47,A48,A49,A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,A60,whethertemp] =textread('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\sonarall.txt','%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','delimiter', ',');
        whethertemp=whethertemp';
        % whether=str2num(char(whethertemp));
        % a=size(whethertemp);

        labelset=zeros(1,size(whethertemp,2));
        for i=1:size(whethertemp,2)
            if whethertemp{i}=='M'
                labelset(i)=1;
            else
                labelset(i)=0;
            end
        end

        dataset=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A40,A41,A42,A43,A44,A45,A46,A47,A48,A49,A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,A60];
        dataset=dataset';
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 4
        name='DNA';
        load('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\dna.mat');
        dataset =  instance' ;%instance Xtr          %%行为特征数，列为数据量683
        labelset =  label';%label Ytr
        labelset(labelset==-1)=0;%%负样本标签为0
       
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 5
        %导入Spectf数据集
        fid = fopen('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\xxs\V6 Spectf.txt','r');
        juzhen=textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
        dataset=cell2mat(juzhen);
        labelset=dataset(:,size(dataset,2));
        labelset=labelset';
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        fclose(fid);
        name = 'Spectf';
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 6
        name = 'qsar';
        dataset = load([filepath,'data_large\qsar\qsar.csv']);
        labelset = load([filepath,'data_large\qsar\qsar_label.csv']);
        dataset = dataset';
        labelset = labelset';
        labelset(labelset==1)=0;labelset(labelset==2)=1;
        generation = 800;
        Rep = 30;
        JLInterval = 10;
%         case 7
%         name='a1a';
%         %导入a1a数据集   32561*123    0.3172  
%         dataset=load([filepath,'dataset\a1a\a1adata.mat']);
%         labelset=load([filepath,'dataset\a1a\a1awhether.mat']);
%         dataset=(cell2mat(struct2cell(dataset)))';
%         labelset=(cell2mat(struct2cell(labelset)))';
%         generation=800;
%         Rep=30;
%         JLInterval=10;
%         case 8
%         %导入w1a数据集  49749*300   0.0306
%         name='w1a';
%         dataset=load([filepath,'dataset\w1a\w1adata.mat']);
%         labelset=load([filepath,'dataset\w1a\w1awhether.mat']);
%         dataset=(cell2mat(struct2cell(dataset)))';
%         labelset=(cell2mat(struct2cell(labelset)))';
%         generation=800;
%         Rep=30;
%         JLInterval=10;
%         case 8
%         name = 'IADS';
%         dataset = load([filepath,'data_large\IADS\ad.csv']);
%         labelset = load([filepath,'data_large\IADS\ad_label.csv']);
%         dataset = dataset';
%         labelset = labelset';
%         labelset(labelset==1)=0;labelset(labelset==2)=1;
%         generation = 800;
%         Rep = 30;
%         JLInterval = 10;
%         case 9
%         name = 'PCMAC';
%         s = load([filepath,'data_large\PCMAC.mat']);
%         dataset = (s.X)';
%         labelset = (s.Y)';
%         labelset(labelset~=2) = 0;
%         labelset(labelset==2) = 1;
%         generation = 800;
%         Rep = 30;
%         JLInterval = 10;
%         case 11
%         name = 'SMK_CAN_187';
%         s = load([filepath,'data_large\SMK_CAN_187.mat']);
%         dataset = (s.X)';
%         labelset = (s.Y)';
%         labelset(labelset==1)=0;labelset(labelset==2)=1;
%         generation = 800;
%         Rep = 30;
%         JLInterval = 10;
%         case 10
%         name = 'gisette';
%         s = load([filepath,'data_large\gisette.mat']);
%         dataset = (s.X)';
%         labelset = (s.Y)';
%         labelset(labelset==-1) = 0;
%         generation = 800;
%         Rep = 30;
%         JLInterval = 10;

        case 7
        name='musk1';
        %导入musk1数据集
        fid = fopen('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\musk1\clean1\clean1.data','r');
        juzhen=textscan(fid,'%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');

        dataset=cell2mat(juzhen);
        labelset=dataset(:,size(dataset,2));
        labelset=labelset';
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        %         datasettemp=textscan(fid,'%s',167,'delimiter', ',');
        %textscan(fid,'%*s %*s','delimiter', ',');
        %xs = fscanf(fid, '%f', [476 167])；
        fclose(fid);
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 8
        load('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\ecoli1.mat');%%%导入数据集
        dataset = A(:,1:end-1)' ;%instance          %%行为特征数7，列为数据量336
        labelset =  A(:,end)';%label
        name='ecoli1';
        generation = 800;
        Rep = 30;
        JLInterval = 10;
        case 9
        load('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\ecoli2.mat');%%%导入数据集
        dataset = A(:,1:end-1)' ;%instance          %%行为特征数7，列为数据量336
        labelset =  A(:,end)';%label
        name='ecoli2';
        generation = 800;
        Rep = 30;
        JLInterval = 10;
         case 10
        %导入transfusion数据集
        % function [dataset,whether]=inputdataset()
        [A1,A2,A3,A4,whether]=textread('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\transfusion.txt','%f%f%f%f%f','delimiter', ',');
        dataset=[A1,A2,A3,A4];
        dataset=dataset';
        name='transfusion';
        labelset=whether';
        % end
        
    case 11
        %导入magic的数据集
        % function [dataset,whether]=inputdataset()
        [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,whethertemp] =textread('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\magic.txt','%f%f%f%f%f%f%f%f%f%f%s','delimiter', ',');
        whethertemp=whethertemp';
        % whether=str2num(char(whethertemp));
        % a=size(whethertemp);
        name='magic';
        labelset=zeros(1,size(whethertemp,2));
        for i=1:size(whethertemp,2)
            if whethertemp{i}=='g'
                labelset(i)=1;
            else
                labelset(i)=0;
            end
        end
        
        dataset=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10];
        dataset=dataset';
         case 12
        % %导入Ionosphere的数据集,g代表good,b代表bad,因此，g赋值为1，b赋值为0
        % function [dataset,whether]=inputdataset()
        [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,A34,whethertemp] =textread('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\ionosphere.txt','%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','delimiter', ',');
        whethertemp=whethertemp';
        % whether=str2num(char(whethertemp));
        % a=size(whethertemp);
        name='Ionosphere';
        labelset=zeros(1,size(whethertemp,2));
        for i=1:size(whethertemp,2)
            if whethertemp{i}=='g'
                labelset(i)=1;
            else
                labelset(i)=0;
            end
        end
        
        dataset=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,A34];
        dataset=dataset';
%         case 13
%         %导入musk1数据集
%         fid = fopen('E:\dataset\musk1\clean1\clean1.data','r');
%         juzhen=textscan(fid,'%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
%         
%         dataset=cell2mat(juzhen);
%         whether=dataset(:,size(dataset,2));
%         whether=whether';
%         dataset=dataset(:,1:size(dataset,2)-1);
%         dataset=dataset';
%         %         datasettemp=textscan(fid,'%s',167,'delimiter', ',');
%         %textscan(fid,'%*s %*s','delimiter', ',');
%         %xs = fscanf(fid, '%f', [476 167])；
%         fclose(fid);
        
    case 13
        %导入musk2数据集
        fid = fopen('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\musk1\clean2\clean2.data','r');
        juzhen=textscan(fid,'%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
        name='musk2';
        dataset=cell2mat(juzhen);
        whether=dataset(:,size(dataset,2));
        labelset=whether';
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        %         datasettemp=textscan(fid,'%s',167,'delimiter', ',');
        %textscan(fid,'%*s %*s','delimiter', ',');
        %xs = fscanf(fid, '%f', [476 167])；
        fclose(fid);
        
        
%     case 14
% %         导入madelon数据集
%         fid = fopen('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\madelon\madelon_train.data','r');
%         juzhen=textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');  
%         dataset=cell2mat(juzhen);
%         dataset=dataset';
%         fclose(fid);
%         name='madelon';
%         fid = fopen('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\madelon\madelon_train.labels','r');
%         whethertemp=textscan(fid,'%f','delimiter', ',');
%         whether=cell2mat(whethertemp);
%         labelset=whether';
% %         对whether进行处理，把-1变为0
%         labelset(find(labelset==-1))=0;
       
        case 14
        %导入skin数据集
        fid = fopen('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\skin\skin.data','r');
        juzhen=textscan(fid,'%f%f%f%f','delimiter', ',');
        name='skin';
        dataset=cell2mat(juzhen);
        whether=dataset(:,size(dataset,2):size(dataset,2));
        %对数据进行初步处理，将2改为0作为标签
        whether(find(whether==2))=0;
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        labelset=whether';
%         fclose(fid);
%         case 15
%         %导入mushrooms数据集
%         name='mushrooms';
%         dataset=load('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\mushrooms\mushroomsdata.mat');
%         whether=load('C:\Users\GGbond\Desktop\师兄代码\数据\dataset\mushrooms\mushroomswhether.mat');
%         dataset=(cell2mat(struct2cell(dataset)))';
%         labelset=(cell2mat(struct2cell(whether)))';
%         
        
end
% dataset=dataset';
% disp(size(dataset, 1)); % 输出 dataset 的行数
% dataset=dataset';
dataset = mapminmax(dataset);%mapminmax函数对矩阵的每一行归一化

end

