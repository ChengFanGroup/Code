clc;clear;
load("./lastdata/leukemia.mat")

label(label==2) = -1;

save leukemia data label
