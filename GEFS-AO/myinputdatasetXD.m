function [dataset,data,whether,datasetName]=myinputdatasetXD(i)

%说明：函数根据输入的序号来读取相应的数据集，序号与数据集对应如上
%输入：i:所需要读取的数据集的序号
%输出：dataset:      读取的数据（样本数*属性）
%      whether:      读取出的数据标签（样本数*标签）
%      datasetName:  数据集的名称



switch i
        
    case 1  %   glass   214*9        6
       load('C:\Users\sunying123\Desktop\数据集\glass.mat');
       dataset=Label_data;
       datasetName='Glass';
    case 2  %  wine   178*13  3
       load('C:\Users\sunying123\Desktop\数据集\wine.mat');
       dataset=Label_data;
       datasetName='Wine';
    
    case 3  %   hepatitis   155*19         2
       load('C:\Users\sunying123\Desktop\数据集\hepatitis.mat');
       dataset=Label_data;
       datasetName='Hepatitis';   
    case 4  %   WDBC   569*30   2
       load('C:\Users\sunying123\Desktop\数据集\WDBC.mat');
       dataset=Label_data;
       datasetName='Wdbc';
    case 5    %  ionosphere         351*34       2
       load('C:\Users\sunying123\Desktop\数据集\ionosphere1.mat');
       dataset=Label_data;
       datasetName='ionosphere';
    case 6   %  divorce  170*54      2                 
       load('C:\Users\sunying123\Desktop\数据集\divorce.mat');
       dataset=Label_data;
       datasetName='divorce';                  
    case 7  %   Sonar  208*60      2 
       load('C:\Users\sunying123\Desktop\数据集\sonar.mat');
       dataset=Label_data;
       datasetName='Sonar';        
    case 8     %  Hill-Valley        606*101      2
       load('C:\Users\sunying123\Desktop\数据集\Hill_Valley3.mat');
       dataset=Label_data;
       datasetName='Hill-Valley3';       
    case  9   %  Urban         168*148      9
       load('C:\Users\sunying123\Desktop\数据集\Urban.mat');
       dataset=Label_data;
       datasetName='Urban';
    case 10  %   Musk1   476*166    2
       load('C:\Users\sunying123\Desktop\数据集\Musk1.mat');
       dataset=Label_data;
       datasetName='Musk1';
    case 11     %  LSVT         126*309       2
       load('C:\Users\sunying123\Desktop\数据集\LSVT.mat');
       dataset=Label_data;
       datasetName='LSVT';
    case 12   %  lung_discrete  73*325      7                 
       load('C:\Users\sunying123\Desktop\数据集\lung_discrete.mat');
       dataset=Label_data;
       datasetName='lung_discrete';  

    case 13  %   madelon  2000*5      2
       load('C:\Users\sunying123\Desktop\数据集\madelon.mat');
       dataset=Label_data;
       datasetName='Madelon';
    
    case 14   %  Isolet  1560*617      26                 
       load('C:\Users\sunying123\Desktop\数据集\Isolet.mat');
       dataset=Label_data;
       datasetName='Isolet';     
    
    case 15   %  CNAE9  1080*856      9                 
       load('C:\Users\sunying123\Desktop\数据集\CNAE9.mat');
       dataset=Label_data;
       datasetName='CNAE9'; 
    case 16   %  ORL            400*1024        40          
       load('C:\Users\sunying123\Desktop\数据集\ORL.mat');
       dataset=Label_data;
       datasetName='ORL';
    case 17     %  Yale         165*1024       15
       load('C:\Users\sunying123\Desktop\数据集\Yale.mat');
       dataset=Label_data;
       datasetName='Yale';  
  

    case 18  %  colon  62*2000    2
       load('C:\Users\sunying123\Desktop\数据集\colon.mat');
       dataset=Label_data;
       fprintf('conlon\n');
       datasetName='Colon';
    case 19      %  SRBCT          83*2308         4
       load('C:\Users\sunying123\Desktop\数据集\SRBCT.mat');
       dataset=Label_data;
       datasetName='SRBCT';    
      
    case 20    %  lung           203×3312       5
       load('C:\Users\sunying123\Desktop\数据集\lung.mat');
       dataset=Label_data;
       datasetName='lung';  
       
       
    case 21     %  lymphoma       96*4026         9
       load('C:\Users\sunying123\Desktop\数据集\lymphoma.mat');
       dataset=Label_data;
       datasetName='lymphoma';
       
       
    case 22     %  TOX_171   171*5748       4
       load('C:\Users\sunying123\Desktop\数据集\TOX_171.mat');
       dataset=Label_data;
%        fprintf("PGE\n\n");
       datasetName='TOX_171';
    case 23     %  leukemia.  72 * 7070      2
       load('C:\Users\sunying123\Desktop\数据集\leukemia.mat');
       dataset=Label_data;
%        fprintf("PGE\n\n");
       datasetName='leukemia';   
    case 24    % ALLAML.ma   72*7129       2
       load('C:\Users\sunying123\Desktop\数据集\ALLAML.mat');
       dataset=Label_data;
%        fprintf("PGE\n\n");
       datasetName='ALLAML';   

    case 25     %  Prostate		102	*10509		2
       load('C:\Users\sunying123\Desktop\数据集\Prostate.mat');
       dataset=Label_data;
       datasetName='Prostate';       
   

       
    case 26     %  Carcinom       174*9182        11 
       load('C:\Users\sunying123\Desktop\数据集\Carcinom.mat');
       dataset=Label_data;%(:,1:1000);
       datasetName='Carcinom';
   
    case 27     %  DLBCL  77*5469     2                      91 82
       load('C:\Users\sunying123\Desktop\数据集\DLBCL.mat');
       dataset=Label_data;
       datasetName='DLBCL';
       
    case 28   %  COLL20'        1440*1024       20       95 97 95 93
       load('C:\Users\sunying123\Desktop\数据集\COLL20.mat');
       dataset=Label_data;
       datasetName='COLL20';
    case 29   %  BASEHOCK        1993*4862        2    78 83  74
       load('C:\Users\sunying123\Desktop\数据集\BASEHOCK.mat');
       dataset=Label_data;
       datasetName='BASEHOCK';   
    case 30   %  PCMAC  1943*3289      2               65 74  66
       load('C:\Users\sunying123\Desktop\数据集\PCMAC.mat');
       dataset=Label_data;
       datasetName='PCMAC';
           
    case 31   %  GLIOMA   50*4434     4                    60  80  80
       load('C:\Users\sunying123\Desktop\数据集\GLIOMA.mat');
       dataset=Label_data;
       datasetName='GLIOMA';
           
    case 32   %  9Tumor  60*5726      9                 0.333
       load('C:\Users\sunying123\Desktop\数据集\9Tumor.mat');
       dataset=Label_data;
       datasetName='9Tumor';
           

     
      
    
       
       
       
       
       
       
       
    case 71     %  Hill-Valley        606*101      2
       load('C:\Users\sunying123\Desktop\数据集\Hill_Valley1.mat');
       dataset=Label_data;
       datasetName='Hill-Valley1';     
    case 72     %  Hill-Valley        606*101      2
       load('C:\Users\sunying123\Desktop\数据集\Hill_Valley2.mat');
       dataset=Label_data;
       datasetName='Hill-Valley2';     
    case 73     %  Hill-Valley        606*101      2
       load('C:\Users\sunying123\Desktop\数据集\Hill_Valley3.mat');
       dataset=Label_data;
       datasetName='Hill-Valley3';     
    case 74     %  Hill-Valley        606*101      2
       load('C:\Users\sunying123\Desktop\数据集\Hill_Valley4.mat');
       dataset=Label_data;
       datasetName='Hill-Valley4';    
    case 75     %  uraban       606*101      2
       load('C:\Users\sunying123\Desktop\数据集\Urban_train.mat');
       dataset=Label_data;
       datasetName='Urban_train';   
    otherwise
            error('没有与 编号%d 对应的数据集.',i);
end % switch

whether=dataset(:,1);
classNum=size(unique(whether),1);
if size(whether, 2)~=1
    dataset = dataset';
    whether = whether';
    fprintf('adsadsadsa');
end
[Ins,featnum]=size(dataset);
fprintf('------%s    特征数= %d   样本数= %d    类数= %d \n',datasetName,featnum-1,Ins,classNum);
if size(dataset,1)~= size(whether,1)
    error('Error. 数据集和标签维度不一致.')
end

whether(whether==-1)=0; %对whether进行处理，把-1变为0
datasetName = cat(2,upper(datasetName(1)), lower(datasetName(2:end)));

end