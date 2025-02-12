function  OutToExcel

    filepath = '.\lastdata'; %读取数据所在的文件夹
    AllDataSet = dir(fullfile(filepath, '*.mat'));
    
    for k= 1 : 10  %length(AllDataSet) %读每个数据集
       dataname =  AllDataSet(k).name; %提取每个数据集的name字段，数据集的名称
       load(strcat(dataname));
       dataList(k)=size(instance,2);
    end
    [~,sequnce]=sort(dataList);
    for k=1 : 10
       dataname =  AllDataSet(k).name;
       load([strcat(dataname),'90.mat']);
       outList(k)=ACC;
       misList(k)=Mis;
       comList(k)=Com;   
    end
    outList=roundn(outList',-3);
    outList=outList(sequnce);
%     outList=num2str(outList);
    misList=roundn(misList',-3);
    misList=misList(sequnce);
%     misList=num2str(misList,-3);
    out=cell(10,1);
    plus='±';
    for i =1:10
      out{i}=[num2str(outList(i)),plus,num2str(misList(i))];
    end
    xlswrite('result.xls',out,1,'a2');
  
end

