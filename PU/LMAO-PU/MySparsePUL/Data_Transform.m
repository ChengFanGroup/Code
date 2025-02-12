% 
% 
%
% Parameters:
%               data:       Original training dataset instance
%               label:      Original training dataset label
%               p:          Proportion of positive samples
% Outputs:
%               dataPos:    Positive data instance
%               labelPos:   Positive data label
%               dataUN:     Unlabeled data instance
%               labelUN:    Ground-truth of Unlabeled data 
% Use:
%               Make original Positive-Negative dataset become 
%               Positive-Unlabeled dataset

function [dataPos,labelPos,dataUN,labelUN]=Data_Transform(data,label,p)
data=data';
dataPositive = data(:,find(label==1));
dataNegative = data(:,find(label==-1));
Pos_num = size(dataPositive,2); % the number of Positive data

% Draw out (1-p) percent Positive data as P in PU
A = randperm(Pos_num,ceil((1-p)*Pos_num));
dataPos = dataPositive(:,A);
labelPos = ones(length(dataPos),1);

% Left positive data add into unlabeled data
dataPositive(:,A)=[];
dataUN = [dataPositive,dataNegative];
labelUN = [ones(size(dataPositive,2),1);zeros(size(dataNegative,2),1)];
end
