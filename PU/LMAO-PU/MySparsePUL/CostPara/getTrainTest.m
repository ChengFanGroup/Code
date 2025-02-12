function [Train_Dataset,Train_Label,Test_Dataset,Test_Label] = getTrainTest(data,label)
 %randSelect=unidrnd(5);
 numS=size(data,1);
 randSelect=randperm(numS);
 trainSize=round(0.8*numS);
 testSize=round(0.2*numS);
 Train_Dataset=data(randSelect(1:trainSize),:);
 Train_Label=label(randSelect(1:trainSize),:);
 Test_Dataset=data(randSelect(1:testSize),:);
 Test_Label=label(randSelect(1:testSize),:);

end

