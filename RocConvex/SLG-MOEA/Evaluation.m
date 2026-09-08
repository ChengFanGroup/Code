function [tpr,fpr]=Evaluation(evaluation,whether)%%正常的评估函数
positivenumber = sum(whether);%计算多少个标签为1的
negativenumber = length(whether) - positivenumber;

whetherMat = repmat(whether, size(evaluation,1),1);
tp = sum(whetherMat & evaluation,2);
fp = sum(~whetherMat & evaluation,2);

tpr=tp/positivenumber;
fpr=fp/negativenumber;
%计算出FPR及tpr


