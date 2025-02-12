clear
clc
load end4.mat
reference = M;
reference(:,:)=reference(:,:).*5;


figure(1);  % 创建一个新的图形窗口
plot(reference(:, 1), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('Tree');

load MODPSO_data.mat
plot(endmember(:, 4) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 1) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 1) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 4) , 'DisplayName', 'GL-EA');
figure(2);  % 创建一个新的图形窗口
plot(reference(:, 2), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('Water');

load MODPSO_data.mat
plot(endmember(:, 1) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 2) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 2) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 2) , 'DisplayName', 'GL-EA');
figure(3);  % 创建一个新的图形窗口
plot(reference(:, 3), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('Dirt');

load MODPSO_data.mat
plot(endmember(:, 2) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 3) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 3) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 1) , 'DisplayName', 'GL-EA');
figure(4);  % 创建一个新的图形窗口
plot(reference(:, 4), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('Road');

load MODPSO_data.mat
plot(endmember(:, 3) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 4) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 4) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 3) , 'DisplayName', 'GL-EA');