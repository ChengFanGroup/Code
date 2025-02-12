clear;
clc;
close all;

% DataNames = ["ORL","SRBCT","GLIOMA","Prostate","CLL_SUB_111","SMK_CAN_187","colon","Lung", "Brain1", "Leukemia","Brain2","DLBCL","Leukemia1",];
% DataNames = ["GLIOMA", "colon","Brain1", "Leukemia","Brain2","DLBCL","TOX_171","SMK_CAN_187","prostate","gse19804"];
 DataNames = ["colon"]; 
% DataNames = {'ORL', 'colon', 'SRBCT', 'lymphoma', 'GLIOMA',  'Leukemia1',  'DLBCL','9Tumor',  'TOX_171',  'Brain1',...
%     'leukemia', 'ALLAML', 'Carcinom',  'Brain2', 'prostate', 'CLL_SUB_111', 'Leukemia2',  '11Tumor', 'Lung',...
%     'SMK_CAN_187', 'gse19804', 'GLI_85',...
% 	 'drivface', 'RELATHE',  'COIL20', 'Isolet', 'PCMAC', 'BASEHOCK'};
%运行次数
runtimes = 1;
%设置你需要保存的结果路径
path = ['./result/'];

for a = 1:length(DataNames)
    dataset = DataNames{a};
    folder=[path,char(dataset)]; 
    if exist(folder) == 0 
        mkdir(folder);
    end 
    fid=fopen([path,char(dataset),'.csv'],'a');
    Testacc = zeros(runtimes, 1);
    Trainerr = zeros(runtimes, 1);
    selFeature = zeros(runtimes, 1);
    time = zeros(runtimes, 1);


    for h = 1:runtimes
        disp(['K Fold ', int2str(h), ' on ',char(dataset)]);
        t1 = clock; 

        [traindata, trainlabel,testdata,testlabel,archive] = main(dataset);
        t2 = clock;
        time(h) = etime(t2,t1);

        pop = archive(:,1:end - 2);
        obj = archive(:,end-1 : end);

        saveobj = ['OSC-EA' '-' char(DataNames(a)) '-obj-' char(string(h))]; 
        save([path,char(dataset),'\',saveobj],'obj');

        t = zeros(size(obj,1),1);
        for i = 1:size(obj,1)
            t(i) = testAcc(traindata,trainlabel,testdata,testlabel,logical(pop(i,:)));
        end
        [Testacc(h),loc] = max(t);
        Trainerr(h) = min(obj(:,2));
        selFeature(h) = sum(pop(loc,:));
        tobj = [obj(:,1),1 - t];
        saveobj = ['OSC-EA' '-' char(DataNames(a)) '-obj-test-' char(string(h))]; 
        save([path,char(dataset),'\',saveobj],'tobj');
        fprintf(fid,'%d,%f,%f,%f,%f\n',h,1-Trainerr(h),Testacc(h),selFeature(h),time(h));

    end
    fprintf(fid,'%s,%f,%f,%f,%f\n','mean',1-mean(Trainerr),mean(Testacc),mean(selFeature),mean(time));
    fclose(fid);

end


