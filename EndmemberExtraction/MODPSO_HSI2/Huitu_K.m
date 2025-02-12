 
clear
clc
HVALL = zeros(1,9);

%K
PF=[0.01,0.01];
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data01.mat')
Ms1 = Ms;
[HV1,PopOb1] = HV(Ms1,PF);
HVALL(1,1) = HV1;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data02.mat')
Ms2 = Ms;
[HV2,PopOb2] = HV(Ms2,PF); 
HVALL(1,2) = HV1;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data03.mat')
Ms3= Ms;
[HV3,PopOb3] = HV(Ms3,PF);
HVALL(1,3) = HV3;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data04.mat')
Ms4 = Ms;
[HV4,PopOb4] = HV(Ms4,PF);
HVALL(1,4) = HV4;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data05.mat')
Ms5 = Ms;
[HV5,PopOb5] = HV(Ms5,PF);
HVALL(1,5) = HV5;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data06.mat')
Ms6 = Ms;
[HV6,PopOb6] = HV(Ms6,PF);
HVALL(1,6) = HV6;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data07.mat')
Ms7 = Ms;
[HV7,PopOb7] = HV(Ms7,PF);
HVALL(1,7) = HV7;
load('C:\Users\陈乃坤\Desktop\data-NEW\data\local\Local_data11.mat')
[HV81,PopOb81] = HV(sl,PF);
HVALL(1,8) = HV81;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\samson\MYEA_data09.mat')
Ms9 = Ms;
[HV9,PopOb9] = HV(Ms9,PF);
HVALL(1,9) = HV9;
num = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
plot(num,HVALL,'k.-','DisplayName','referenc')
hold on;
% xlabel('Value of K in GL-EA');
% ylabel('HV');

 PF=[0.01,0.08]; %jasper
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data01.mat')
Ms1 = Ms;
[HV1,PopOb1] = HV(Ms1,PF);
HVALL(1,1) = HV1;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data02.mat')
Ms2 = Ms;
[HV2,PopOb2] = HV(Ms2,PF); 
HVALL(1,2) = HV1;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data03.mat')
Ms3= Ms;
[HV3,PopOb3] = HV(Ms3,PF);
HVALL(1,3) = HV3;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data04.mat')
Ms4 = Ms;
[HV4,PopOb4] = HV(Ms4,PF);
HVALL(1,4) = HV4;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data05.mat')
Ms5 = Ms;
[HV5,PopOb5] = HV(Ms5,PF);
HVALL(1,5) = HV5;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data06.mat')
Ms6 = Ms;
[HV6,PopOb6] = HV(Ms6,PF);
HVALL(1,6) = HV6;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data07.mat')
Ms7 = Ms;
[HV7,PopOb7] = HV(Ms7,PF);
HVALL(1,7) = HV7;
load('C:\Users\陈乃坤\Desktop\data-NEW\data\local\Local_data12.mat')
[HV81,PopOb81] = HV(sl,PF);
HVALL(1,8) = HV81;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\jasper\MYEA_data09.mat')
Ms9 = Ms;
[HV9,PopOb9] = HV(Ms9,PF);
HVALL(1,9) = HV9;
num = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
plot(num,HVALL,'g.-','DisplayName','referenc')
hold on;
% xlabel('Value of K in GL-EA');
% ylabel('HV');

 PF=[0.03,0.02]; %urban
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data01.mat')
Ms1 = Ms;
[HV1,PopOb1] = HV(Ms1,PF);
HVALL(1,1) = HV1;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data02.mat')
Ms2 = Ms;
[HV2,PopOb2] = HV(Ms2,PF); 
HV2 = 0.5492;
HVALL(1,2) = HV2;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data03.mat')
Ms3= Ms;
[HV3,PopOb3] = HV(Ms3,PF);
HVALL(1,3) = HV3;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data04.mat')
Ms4 = Ms;
[HV4,PopOb4] = HV(Ms4,PF);
HVALL(1,4) = HV4;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data05.mat')
Ms5 = Ms;
[HV5,PopOb5] = HV(Ms5,PF);
HVALL(1,5) = HV5;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data06.mat')
Ms6 = Ms;
[HV6,PopOb6] = HV(Ms6,PF);
HVALL(1,6) = HV6;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data07.mat')
Ms7 = Ms;
[HV7,PopOb7] = HV(Ms7,PF);
HVALL(1,7) = HV7;
load('C:\Users\陈乃坤\Desktop\data-NEW\data\local\Local_data13.mat')
[HV81,PopOb81] = HV(sl,PF);
HVALL(1,8) = HV81;
load('C:\Users\陈乃坤\Desktop\data-NEW\K\urban\MYEA_data09.mat')
Ms9 = Ms;
[HV9,PopOb9] = HV(Ms9,PF);
HVALL(1,9) = HV9;
num = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
plot(num,HVALL,'m.-','DisplayName','referenc')
hold on;
legend('Samson','Jasper Ridge','Urban')
xlabel('Value of K in GL-EA');
ylabel('HV');



