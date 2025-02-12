function [FunctionValue] = Cal_ObjV(population,datasettrain,whethertrain)
%CAL_OBJV 此处显示有关此函数的摘要
%   此处显示详细说明
        datasettrain = datasettrain';
        evaluation = population*datasettrain*10^(-3);
        evaluation((evaluation >= 0)) = 1;
        evaluation((evaluation < 0)) = 0;   
        [fpr,tpr] = calculatetprandfpr(evaluation,whethertrain);
        FunctionValue = [fpr,tpr];
end

