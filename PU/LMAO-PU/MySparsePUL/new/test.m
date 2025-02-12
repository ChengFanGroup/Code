clc;
clear;

name = 'RELATHE';

load(name);
% instance = X;
% label = Y;

label(label == 2) = -1;

save RELATHE  instance label;