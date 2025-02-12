
clear
clc
load CupriteS1_groundtreth.mat
reference = M;
reference(:,:)=reference(:,:).*5;

figure(1);  % 创建一个新的图形窗口
plot(reference(:, 1), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('1.Alunite');

load MODPSO_data.mat
plot(endmember(:, 7) , 'DisplayName', 'MODPSO');
%hold on;
%load IMODPSO_data.mat
%plot(endmember(:, 3) , 'DisplayName', 'IMODPSO');
%hold on;
%load MODE_data.mat
%plot(endmember1(:, 1) , 'DisplayName', 'MODE');
%hold on;
load MYEA_data.mat
plot(endmember(:, 6) , 'DisplayName', 'GL-EA');

figure(2);  % 创建一个新的图形窗口
plot(reference(:, 2), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('2.Andradite');

%load MODPSO_data.mat
%plot(endmember(:, 4) , 'DisplayName', 'MODPSO');
%hold on;
load IMODPSO_data.mat
plot(endmember(:, 10) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 9) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 11) , 'DisplayName', 'GL-EA');


figure(4);  % 创建一个新的图形窗口
plot(reference(:, 4), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('4.Dumortierite');

load MODPSO_data.mat
plot(endmember(:, 4) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 6) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 9) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 10) , 'DisplayName', 'GL-EA');

figure(5);  % 创建一个新的图形窗口
plot(reference(:, 5), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('5.Kaolinite_1');

load MODPSO_data.mat
plot(endmember(:, 3) , 'DisplayName', 'MODPSO');
hold on;
%load IMODPSO_data.mat
%plot(endmember(:, 3) , 'DisplayName', 'IMODPSO');
%hold on;
load MODE_data.mat
plot(endmember1(:, 5) , 'DisplayName', 'MODE');
hold on;
%load MYEA_data.mat
%plot(endmember(:, 1) , 'DisplayName', 'GL-EA');

figure(6);  % 创建一个新的图形窗口
plot(reference(:, 6), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('6.Kaolinite_2');

load MODPSO_data.mat
plot(endmember(:, 7) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 9) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 7) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 8) , 'DisplayName', 'GL-EA');


figure(8);  % 创建一个新的图形窗口
plot(reference(:, 8), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('8.Montmorillonite');

load MODPSO_data.mat
plot(endmember(:, 11) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 12) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 9) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 9) , 'DisplayName', 'GL-EA');

figure(9);  % 创建一个新的图形窗口
plot(reference(:, 9), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('9.Nontronite');

load MODPSO_data.mat
plot(endmember(:, 2) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 1) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 4) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 4) , 'DisplayName', 'GL-EA');

figure(10);  % 创建一个新的图形窗口
plot(reference(:, 10), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('10.Pyrope');

load MODPSO_data.mat
plot(endmember(:, 3) , 'DisplayName', 'MODPSO');
hold on;
%load IMODPSO_data.mat
%plot(endmember(:, 3) , 'DisplayName', 'IMODPSO');
%hold on;
load MODE_data.mat
plot(endmember1(:, 5) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 2) , 'DisplayName', 'GL-EA');

figure(11);  % 创建一个新的图形窗口
plot(reference(:, 11), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('11.Sphene');

%load MODPSO_data.mat
%plot(endmember(:, 1) , 'DisplayName', 'MODPSO');
%hold on;
load IMODPSO_data.mat
plot(endmember(:, 1) , 'DisplayName', 'IMODPSO');
%hold on;
%load MODE_data.mat
%plot(endmember1(:, 1) , 'DisplayName', 'MODE');
%hold on;
%load MYEA_data.mat
%plot(endmember(:, 1) , 'DisplayName', 'GL-EA');

figure(12);  % 创建一个新的图形窗口
plot(reference(:, 12), 'k','DisplayName', 'Reference');
    hold on;
    xlabel('Bands');
    ylabel('Reflectance');
    legend;
    title('12.Chalcedony');

load MODPSO_data.mat
plot(endmember(:, 9) , 'DisplayName', 'MODPSO');
hold on;
load IMODPSO_data.mat
plot(endmember(:, 3) , 'DisplayName', 'IMODPSO');
hold on;
load MODE_data.mat
plot(endmember1(:, 1) , 'DisplayName', 'MODE');
hold on;
load MYEA_data.mat
plot(endmember(:, 5) , 'DisplayName', 'GL-EA');