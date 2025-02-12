
 
clear
clc



% load jasperRidge2_R198.mat
% load end4.mat
% reference = M.*5;
% X = Y./1000; %100.100

load('C:\Users\chnk\Desktop\data-NEW\data\samson\MODPSO_data3.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\samson\IMODPSO_data3.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\samson\MODE_data2.mat')

load('C:\Users\chnk\Desktop\data-NEW\data\samson\MYEA_data2.mat')

load('C:\Users\chnk\Desktop\data-NEW\data\samson\DPSO_data1.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\samson\NFINDER_data1.mat')
load samson_1.mat
load end3.mat
reference = M;
% reference(:,1) = reference(:,1).*0.5;
reference(:,3)=reference(:,3).*0.1;
X = V;
p=3;
[L,N] = size(X);

num=1:L;
% generations=0:5:200;


endmember1 = X(:,GBA(8,:)==1);
SAM1 = SAMpipei(reference,endmember1);
[~,SAM_idx1]=sort(SAM1(1,1:p));
SAM1=SAM1(:,SAM_idx1);

endmember2 = X(:,IGBA(1,:)==1);
SAM2 = SAMpipei(reference,endmember2);
[~,SAM_idx2]=sort(SAM2(1,1:p));
SAM2=SAM2(:,SAM_idx2);

endmember3 = X(:,Dbest_x(6,:));
SAM3 = SAMpipei(reference,endmember3);
[~,SAM_idx3]=sort(SAM3(1,1:p));
SAM3=SAM3(:,SAM_idx3);

endmember4 = X(:,Mbest_x(2,:)==1);
% endmember4 = X(:,Mbest_x(13,:)==1);
SAM4 = SAMpipei(reference,endmember4);
[~,SAM_idx4]=sort(SAM4(1,1:p));
SAM4=SAM4(:,SAM_idx4);
endmember5 = X(:,gbest(1,:)==1);
SAM5 = SAMpipei(reference,endmember5);
[~,SAM_idx5]=sort(SAM5(1,1:p));
SAM5=SAM5(:,SAM_idx5);
endmember6 = X(:,E(1,:));
SAM6 = SAMpipei(reference,endmember6);
[~,SAM_idx6]=sort(SAM6(1,1:p));
SAM6=SAM6(:,SAM_idx6);

plot(num,reference(:,2),'k.-','DisplayName','reference')
hold on;
plot(num,endmember1(:,SAM1(2,2))*0.87,'r.-','DisplayName','Mi')
hold on;
plot(num,endmember3(:,SAM3(2,2)),'m.-','DisplayName','Mi’')
hold on;
legend('reference','Mi','Mi''')
xlabel('Bands');
ylabel('Reflectance');
1



% load('C:\Users\chnk\Desktop\data-NEW\data\jasper\MODPSO_data1.mat')
% load('C:\Users\chnk\Desktop\data-NEW\data\jasper\IMODPSO_data2.mat')
% load('C:\Users\chnk\Desktop\data-NEW\data\jasper\MODE_data3.mat')
% load('C:\Users\chnk\Desktop\data-NEW\data\jasper\MYEA_data2.mat')
% 
% load('C:\Users\chnk\Desktop\data-NEW\data\jasper\DPSO_data2.mat')
% load('C:\Users\chnk\Desktop\data-NEW\data\jasper\NFINDER_data1.mat')
% load jasperRidge2_R198.mat
% load end4.mat
% reference = M.*5;
% X = Y./1000; %100.100
% p=4;



load('C:\Users\chnk\Desktop\data-NEW\data\urban\MODPSO_data2.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\urban\IMODPSO_data2.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\urban\MODE_data2.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\urban\MYEA_data4.mat')

load('C:\Users\chnk\Desktop\data-NEW\data\urban\DPSO_data2.mat')
load('C:\Users\chnk\Desktop\data-NEW\data\urban\NFINDER_data1.mat')


load Urban_R1621.mat
load end6_groundTruth.mat
reference = M;
X = Y./1000;  %2-dimensional input image  
p=6;

[L,N] = size(X);

num=1:L;
% generations=0:5:200;


endmember1 = X(:,GBA(1,:)==1);
SAM1 = SAMpipei(reference,endmember1);
[~,SAM_idx1]=sort(SAM1(1,1:p));
SAM1=SAM1(:,SAM_idx1);

endmember2 = X(:,IGBA(1,:)==1);
SAM2 = SAMpipei(reference,endmember2);
[~,SAM_idx2]=sort(SAM2(1,1:p));
SAM2=SAM2(:,SAM_idx2);

endmember3 = X(:,Dbest_x(6,:));
SAM3 = SAMpipei(reference,endmember3);
[~,SAM_idx3]=sort(SAM3(1,1:p));
SAM3=SAM3(:,SAM_idx3);

endmember4 = X(:,Mbest_x(1,:)==1);
% endmember4 = X(:,Mbest_x(13,:)==1);
SAM4 = SAMpipei(reference,endmember4);
[~,SAM_idx4]=sort(SAM4(1,1:p));
SAM4=SAM4(:,SAM_idx4);
endmember5 = X(:,gbest(1,:)==1);
SAM5 = SAMpipei(reference,endmember5);
[~,SAM_idx5]=sort(SAM5(1,1:p));
SAM5=SAM5(:,SAM_idx5);
endmember6 = X(:,E(1,:));
SAM6 = SAMpipei(reference,endmember6);
[~,SAM_idx6]=sort(SAM6(1,1:p));
SAM6=SAM6(:,SAM_idx6);

% plot(num,reference(:,1),'k.-','DisplayName','referenc')
% hold on;
% plot(num,endmember1(:,SAM1(2,1)),'g.-','DisplayName','MODPSO')
% hold on;
% plot(num,endmember2(:,SAM2(2,1)),'b.-','DisplayName','IMODPSO')
% hold on;
% plot(num,endmember3(:,SAM3(2,1)),'m.-','DisplayName','(u+λ)MODE')
% hold on;
% plot(num,endmember4(:,SAM4(2,1)),'r.-','DisplayName','MYEA')
% hold on;
% plot(num,endmember5(:,SAM5(2,1)),'y.-','DisplayName','DPSO')
% hold on;
% plot(num,endmember6(:,SAM6(2,1)),'c.-','DisplayName','N-FINDER')
% hold on;
% 
% legend('referenc','MODPSO','IMODPSO','(u+λ)MODE','GL-EA','DPSO','N-FINDER')
% xlabel('Bands');
% ylabel('Reflectance');

% plot(num,reference(:,3),'k.-','DisplayName','referenc')
% hold on;
% plot(num,endmember1(:,SAM1(2,2)),'g.-','DisplayName','MODPSO')
% hold on;
% plot(num,endmember2(:,SAM2(2,2)),'b.-','DisplayName','IMODPSO')
% hold on;
% plot(num,endmember3(:,SAM3(2,2)),'m.-','DisplayName','(u+λ)MODE')
% hold on;
% plot(num,endmember4(:,SAM4(2,2)),'r.-','DisplayName','MYEA')
% hold on;
% plot(num,endmember5(:,SAM5(2,2)),'y.-','DisplayName','DPSO')
% hold on;
% plot(num,endmember6(:,SAM6(2,2)),'c.-','DisplayName','N-FINDER')
% hold on;
% legend('referenc','MODPSO','IMODPSO','(u+λ)MODE','GL-EA','DPSO','N-FINDER')
% xlabel('Bands');
% ylabel('Reflectance');

% plot(num,reference(:,3),'k.-','DisplayName','referenc')
% hold on;
% plot(num,endmember1(:,SAM1(2,3)),'g.-','DisplayName','MODPSO')
% hold on;
% plot(num,endmember2(:,SAM2(2,3)),'b.-','DisplayName','IMODPSO')
% hold on;
% plot(num,endmember3(:,SAM3(2,3)),'m.-','DisplayName','(u+λ)MODE')
% hold on;
% plot(num,endmember4(:,SAM4(2,3)),'r.-','DisplayName','MYEA')
% hold on;
% plot(num,endmember5(:,SAM5(2,3)),'y.-','DisplayName','DPSO')
% hold on;
% plot(num,endmember6(:,SAM6(2,3)),'c.-','DisplayName','N-FINDER')
% hold on;
% legend('referenc','MODPSO','IMODPSO','(u+λ)MODE','GL-EA','DPSO','N-FINDER')
% xlabel('Bands');
% ylabel('Reflectance');

% plot(num,reference(:,4),'k.-','DisplayName','referenc')
% hold on;
% plot(num,endmember1(:,SAM1(2,5)),'g.-','DisplayName','MODPSO')
% hold on;
% plot(num,endmember2(:,SAM2(2,4)),'b.-','DisplayName','IMODPSO')
% hold on;
% plot(num,endmember3(:,SAM3(2,4)),'m.-','DisplayName','(u+λ)MODE')
% hold on;
% plot(num,endmember4(:,SAM4(2,5)),'r.-','DisplayName','MYEA')
% hold on;
% plot(num,endmember5(:,SAM5(2,4)),'y.-','DisplayName','DPSO')
% hold on;
% plot(num,endmember6(:,SAM6(2,5)),'c.-','DisplayName','N-FINDER')
% hold on;
% 
% legend('referenc','MODPSO','IMODPSO','(u+λ)MODE','GL-EA','DPSO','N-FINDER')
% xlabel('Bands');
% ylabel('Reflectance');



% plot(num,reference(:,5),'k.-','DisplayName','referenc')
% hold on;
% plot(num,endmember1(:,SAM1(2,5)),'g.-','DisplayName','MODPSO')
% hold on;
% plot(num,endmember2(:,SAM2(2,5)),'b.-','DisplayName','IMODPSO')
% hold on;
% plot(num,endmember3(:,SAM3(2,5)),'m.-','DisplayName','(u+λ)MODE')
% hold on;
% plot(num,endmember4(:,SAM4(2,5)),'r.-','DisplayName','MYEA')
% hold on;
% % plot(num,endmember5(:,SAM5(2,6)),'y.-','DisplayName','DPSO')
% % hold on;
% % plot(num,endmember6(:,SAM6(2,5)),'c.-','DisplayName','N-FINDER')
% % hold on;
% 
% legend('referenc','MODPSO','IMODPSO','(u+λ)MODE','GL-EA')
% xlabel('Bands');
% ylabel('Reflectance');


plot(num,reference(:,6),'k.-','DisplayName','referenc')
hold on;
plot(num,endmember1(:,SAM1(2,5)),'g.-','DisplayName','MODPSO')
hold on;
plot(num,endmember2(:,SAM2(2,5)),'b.-','DisplayName','IMODPSO')
hold on;
plot(num,endmember3(:,SAM3(2,6)),'m.-','DisplayName','(u+λ)MODE')
hold on;
plot(num,endmember4(:,SAM4(2,5)),'r.-','DisplayName','MYEA')
hold on;
plot(num,endmember5(:,SAM5(2,5)),'y.-','DisplayName','DPSO')
hold on;
% plot(num,endmember6(:,SAM6(2,4)),'c.-','DisplayName','N-FINDER')
% hold on;

legend('referenc','MODPSO','IMODPSO','(u+λ)MODE','GL-EA','DPSO')
xlabel('Bands');
ylabel('Reflectance');
% 
% 
% num=1:1:L;
% endmember1=X(:,GBA(1,:)==1);
% endmember2=X(:,IGBA(9,:)==1);
% endmember3=X(:,Dbest_x(3,:));
% endmember4=X(:,Mbest_x(12,:)==1);
% 
% endmember5=X(:,gbest(1,:)==1);
% endmember6=X(:,E);
% 
% SAM1 = SAMpipei(reference,endmember1);
% [~,SAM1_idx]=sort(SAM1(1,1:P));
% SAM1=SAM1(:,SAM1_idx);
% SAM2 = SAMpipei(reference,endmember2);
% [~,SAM2_idx]=sort(SAM2(1,1:P));
% SAM2=SAM2(:,SAM2_idx);
% SAM3 = SAMpipei(reference,endmember3);
% [~,SAM3_idx]=sort(SAM3(1,1:P));
% SAM3=SAM3(:,SAM3_idx);
% SAM4 = SAMpipei(reference,endmember4);
% [~,SAM4_idx]=sort(SAM4(1,1:P));
% SAM4=SAM4(:,SAM4_idx);
% SAM5 = SAMpipei(reference,endmember5);
% [~,SAM5_idx]=sort(SAM5(1,1:P));
% SAM5=SAM5(:,SAM5_idx);
% SAM6 = SAMpipei(reference,endmember6);
% [~,SAM6_idx]=sort(SAM6(1,1:P));
% SAM6=SAM6(:,SAM6_idx);

