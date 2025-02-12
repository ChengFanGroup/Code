clear
clc


load MODPSO_data.mat
load IMODPSO_data.mat
load MODE_data.mat
load MYEA_data.mat

PF=[0.01,0.01];
[Score1,PopObj1] = HV(f_GBA,PF);
[Score2,PopObj2] = HV(If_GBA,PF);
[Score3,PopObj3] = HV(Ds,PF);
[Score4,PopObj4] = HV(Ms,PF);

figure(1)
scatter(f_GBA(:,1),f_GBA(:,2),'filled','+','DisplayName','MODPSO', 'MarkerEdgeColor', 'r');
hold on;
scatter(If_GBA(:,1),If_GBA(:,2),'filled', 'v','DisplayName','IMODPSO');
hold on;
scatter(Ds(:,1),Ds(:,2),'filled','DisplayName','(μ+λ)MODE');
hold on;
scatter(Ms(:,1),Ms(:,2),'filled','h','DisplayName','GL-EA');
hold on;
xlabel(['f1=1/Volume']);
ylabel('f2=RMSE');
%axis equal;
legend;   
       

 figure(2)
subplot(1, 2, 1);
a(1,:)=log10(recordfit1(1,:));
plot([0:5:200],a(1,:),'-g*','DisplayName','MODPSO','Linewidth',1.5);
legend;
hold on;
b(1,:)=log10(recordfit2(1,:));
plot([0:5:200],b(1,:),'-bo','DisplayName','IMODPSO','Linewidth',1.5);
legend;
hold on;
c(1,:)=log10(recordfit3(1,:));
plot([0:5:200],c(1,:),'-s', 'Color', '#FFA500','DisplayName','(μ+λ)MODE','Linewidth',1.5);
legend;
hold on;
d(1,:)=log10(recordfit4(1,:));
plot([0:5:200],d(1,:),'-m+','DisplayName','GL-EA','Linewidth',1.5);
xlabel('Generations');
ylabel('lg(f1=1/Volume)');
title('f1收敛速度');
legend;

subplot(1, 2, 2);  % 如果有多个子图，可以根据需要调整这里
a(2,:)=log10(recordfit1(2,:));
plot([0:5:200],a(2,:),'-g*','DisplayName','MODPSO','Linewidth',1.5);
legend;
hold on;
b(2,:)=log10(recordfit2(2,:));
plot([0:5:200],b(2,:),'-bo','DisplayName','IMODPSO','Linewidth',1.5);
legend;
hold on;
c(2,:)=log10(recordfit3(2,:));
plot([0:5:200],c(2,:),'-s', 'Color', '#FFA500','DisplayName','(μ+λ)MODE','Linewidth',1.5);
legend;
hold on;
d(2,:)=log10(recordfit4(2,:));
plot([0:5:200],d(2,:),'-m+','DisplayName','GL-EA','Linewidth',1.5);

xlabel('Generations');
ylabel('lg(f2=RMSE)');
title('f2收敛速度');
legend;