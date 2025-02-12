% load('C:\Users\chnk\Desktop\data\samson\MODPSO_data3.mat')
% load('C:\Users\chnk\Desktop\data\samson\IMODPSO_data1.mat')
% load('C:\Users\chnk\Desktop\data\samson\MODE_data4.mat')
% load('C:\Users\chnk\Desktop\data\samson\MYEA_data4.mat')
% load('C:\Users\chnk\Desktop\data\samson\DPSO_data1.mat')
% 
% load('C:\Users\chnk\Desktop\data\local\Local_data11.mat')
% recordfit4(:,33:41)=recordfitl;


% load('C:\Users\chnk\Desktop\data\jasper\MODPSO_data2.mat')
% load('C:\Users\chnk\Desktop\data\jasper\IMODPSO_data2.mat')
% load('C:\Users\chnk\Desktop\data\jasper\MODE_data5.mat')
% load('C:\Users\chnk\Desktop\data\jasper\MYEA_data2.mat')
% load('C:\Users\chnk\Desktop\data\jasper\DPSO_data1.mat')
% 
% load('C:\Users\chnk\Desktop\data\local\Local_data12.mat')
% recordfit4(:,33:41)=recordfitl;

% 
load('C:\Users\chnk\Desktop\data\urban\MODPSO_data1.mat')
load('C:\Users\chnk\Desktop\data\urban\IMODPSO_data2.mat')
load('C:\Users\chnk\Desktop\data\urban\MODE_data5.mat')
load('C:\Users\chnk\Desktop\data\urban\MYEA_data5.mat')
load('C:\Users\chnk\Desktop\data\local\Local_data13.mat')
load('C:\Users\chnk\Desktop\data\urban\DPSO_data1.mat')
recordfit4(:,33:41)=recordfitl;


% generations=0:5:200;
% % plot(generations,log10(recordfit5(1,:)),'-d');
% % axis([0 200 -3 -1.5]); 
% % hold on;
% plot(generations,log10(recordfit1(1,:)),'-+'); %'-+b实线，+号，颜色'
% hold on;
% plot(generations,log10(recordfit2(1,:)),'-x');
% hold on;
% plot(generations,log10(recordfit3(1,:)),'-*');
% hold on;
% plot(generations,log10(recordfit4(1,:)),'-h');
% hold on;
% 
% legend('MODPSO','IMODPSO','(μ+λ)MODE','GL-EA')
% xlabel('Generations');
% ylabel('log_1_0(f_1=1/Volume)');

generations=0:5:200;
% plot(generations,log10(recordfit5(1,:)),'-d');
% % axis([0 200 -1.25 -1]); 
% hold on;
plot(generations,log10(recordfit1(2,:)),'-+'); %'-+b实线，+号，颜色'
hold on;
plot(generations,log10(recordfit2(2,:)),'-x');
hold on;
plot(generations,log10(recordfit3(2,:)),'-*');
hold on;
plot(generations,log10(recordfit4(2,:)),'-h');
hold on;


legend('MODPSO','IMODPSO','(μ+λ)MODE','GL-EA')
xlabel('Generations');
ylabel('log_1_0(f_2=RMSE)');