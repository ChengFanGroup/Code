 
clear
clc
%Input imageè¾“å…¥å›¾åƒæ•°æ®
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  çœŸå®å›¾åƒï¼Œæ¯”è¾ƒç«¯å…ƒçš„æ—¶ï¿½?ï¿½ä½¿ï¿??
% reference = M; %reference of endmembers   ç«¯å…ƒçš„å‚ï¿??
% 
% load Urban_R1621.mat
% load end6_groundTruth.mat
% reference = M;
% X = Y./1000;  %2-dimensional input image  

% load samson_1.mat
% load end3.mat
% reference = M;
% reference(:,3)=reference(:,3).*0.1;
% X = V;

% load CupriteS1_R188.mat
% load CupriteS1_groundtreth.mat
% reference = M;
% X = Y./1000; %250.190

% load jasperRidge2_R198.mat
% load end4.mat
% reference = M.*5;
% X = Y./1000; %100.100
% 
% 
% 
% [L,N] = size(X);
% row = 100;
% col = 100;
% 
% 
% image_3d = zeros(row,col,L);
% for i = 1:L
%     image_3d(:,:,i) = reshape(X(i,:),row,col);
% end
% P = 4;   % Number of endmembers

% [rgb] = func_hyperImshow(image_3d,[64,52,36]); % func_hyperImshow(3D¸ß¹âÆ×Í¼Ïñ,[R,G,B])

% 


load('C:\Users\chnk\Desktop\data\samson\MODPSO_data3.mat')
load('C:\Users\chnk\Desktop\data\samson\IMODPSO_data1.mat')
load('C:\Users\chnk\Desktop\data\samson\MODE_data4.mat')
load('C:\Users\chnk\Desktop\data\samson\MYEA_data4.mat')
load('C:\Users\chnk\Desktop\data\local\Local_data11.mat')
load('C:\Users\chnk\Desktop\data\samson\DPSO_data2.mat')
load('C:\Users\chnk\Desktop\data\samson\NFINDER_data2.mat')
1

% PF=[1,0.02]; %urban
% PF=[0.008,0.1]; %jasper
PF=[0.01,0.01];
[HV1,PopObj1] = HV(f_GBA,PF);
[HV2,PopObj2] = HV(If_GBA,PF);
[HV3,PopObj3] = HV(Ds,PF);
[HV4,PopObj4] = HV(Ms,PF);



% scatter(f_GBA(:,1),f_GBA(:,2),'o','DisplayName','MODPSO'); 
% hold on;
% scatter(If_GBA(:,1),If_GBA(:,2),'x','DisplayName','IMODPSO');
% hold on;
% scatter(Ds(:,1),Ds(:,2),'*','DisplayName','(u+¦Ë)MODE');
% hold on;
% scatter(sl(:,1),sl(:,2),'filled','h','DisplayName','MY');
% hold on;
% scatter(0.0053,0.0059,'filled','v','DisplayName','DPSO');
% hold on;
% scatter(0.0042,0.0412,'filled','<','DisplayName','NFINDER');
% hold on;
% legend('MODPSO','IMODPSO','(¦Ì+¦Ë)MODE','GL-EA','DPSO','NFINDER')
% xlabel('f_1=1/Volume');
% ylabel('f_2=RMSE');



% scatter(f_GBA(:,1),f_GBA(:,2),'o','DisplayName','MODPSO'); 
% hold on;
% scatter(If_GBA(:,1),If_GBA(:,2),'x','DisplayName','IMODPSO');
% hold on;
% scatter(Ds(:,1),Ds(:,2),'*','DisplayName','(u+¦Ë)MODE');
% hold on;
% scatter(sl(:,1),sl(:,2),'filled','h','DisplayName','MY');
% hold on;
% legend('MODPSO','IMODPSO','(¦Ì+¦Ë)MODE','GL-EA') 
% xlabel('f_1=1/Volume');
% ylabel('f_2=RMSE');

load('C:\Users\chnk\Desktop\data\jasper\MODPSO_data2.mat')
load('C:\Users\chnk\Desktop\data\jasper\IMODPSO_data2.mat')
load('C:\Users\chnk\Desktop\data\jasper\MODE_data5.mat')
load('C:\Users\chnk\Desktop\data\jasper\MYEA_data2.mat')
load('C:\Users\chnk\Desktop\data\local\Local_data12.mat')
load('C:\Users\chnk\Desktop\data\jasper\DPSO_data1.mat')
load('C:\Users\chnk\Desktop\data\jasper\NFINDER_data2.mat')
PF=[0.01,0.08];
[HV1,PopObj1] = HV(f_GBA,PF);
[HV2,PopObj2] = HV(If_GBA,PF);
[HV3,PopObj3] = HV(Ds,PF);
[HV4,PopObj4] = HV(Ms,PF);

2


% scatter(f_GBA(:,1),f_GBA(:,2),'o','DisplayName','MODPSO'); 
% hold on;
% scatter(If_GBA(:,1),If_GBA(:,2),'x','DisplayName','IMODPSO');
% hold on;
% scatter(Ds(:,1),Ds(:,2),'*','DisplayName','(u+¦Ë)MODE');
% hold on;
% scatter(sl(:,1),sl(:,2),'filled','h','DisplayName','MY');
% hold on;
% scatter(0.0021,0.0641,'filled','v','DisplayName','DPSO');
% hold on;
% 
% legend('MODPSO','IMODPSO','(¦Ì+¦Ë)MODE','GL-EA','DPSO')
% xlabel('f_1=1/Volume');
% ylabel('f_2=RMSE');


% scatter(f_GBA(:,1),f_GBA(:,2),'o','DisplayName','MODPSO'); 
% hold on;
% scatter(If_GBA(:,1),If_GBA(:,2),'x','DisplayName','IMODPSO');
% hold on;
% scatter(Ds(:,1),Ds(:,2),'*','DisplayName','(u+¦Ë)MODE');
% hold on;
% scatter(sl(:,1),sl(:,2),'filled','h','DisplayName','MY');
% hold on;
% legend('MODPSO','IMODPSO','(¦Ì+¦Ë)MODE','GL-EA') 
% xlabel('f_1=1/Volume');
% ylabel('f_2=RMSE');

load('C:\Users\chnk\Desktop\data\urban\MODPSO_data1.mat')
load('C:\Users\chnk\Desktop\data\urban\IMODPSO_data5.mat')
load('C:\Users\chnk\Desktop\data\urban\MODE_data10.mat')
load('C:\Users\chnk\Desktop\data\urban\MYEA_data5.mat')
load('C:\Users\chnk\Desktop\data\local\Local_data13.mat')
load('C:\Users\chnk\Desktop\data\urban\DPSO_data2.mat')
load('C:\Users\chnk\Desktop\data\urban\NFINDER_data1.mat')
PF=[0.03,0.02];
[HV1,PopObj1] = HV(f_GBA,PF);
[HV2,PopObj2] = HV(If_GBA,PF);
[HV3,PopObj3] = HV(Ds,PF);
[HV4,PopObj4] = HV(Ms,PF);
3

scatter(f_GBA(:,1),f_GBA(:,2),'o','DisplayName','MODPSO'); 
hold on;
scatter(If_GBA(:,1),If_GBA(:,2),'x','DisplayName','IMODPSO');
hold on;
scatter(Ds(:,1),Ds(:,2),'*','DisplayName','(u+¦Ë)MODE');
hold on;
scatter(sl(:,1),sl(:,2),'filled','h','DisplayName','MY');
hold on;
scatter(0.0022,0.0076,'filled','v','DisplayName','DPSO');
hold on;

legend('MODPSO','IMODPSO','(¦Ì+¦Ë)MODE','GL-EA','DPSO')
xlabel('f_1=1/Volume');
ylabel('f_2=RMSE');
% 

% scatter(f_GBA(:,1),f_GBA(:,2),'o','DisplayName','MODPSO'); 
% hold on;
% scatter(If_GBA(:,1),If_GBA(:,2),'x','DisplayName','IMODPSO');
% hold on;
% scatter(Ds(:,1),Ds(:,2),'*','DisplayName','(u+¦Ë)MODE');
% hold on;
% scatter(sl(:,1),sl(:,2),'filled','h','DisplayName','GL-EA');
% hold on;
% legend('MODPSO','IMODPSO','(¦Ì+¦Ë)MODE','GL-EA') 
% xlabel('f_1=1/Volume');
% ylabel('f_2=RMSE');


%---------------------------------------------------------------------------------------------------------------------%
