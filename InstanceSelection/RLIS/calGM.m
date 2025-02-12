function [GM,class_acc] = calGM(class,label,predict_label)
%GM 计算GMeans值
%   input:真实标签，预测结果
%   output:GM值，每类分类精度（向量）
    
    class_true_num = zeros(1,length(class));
    GM =1;
    te_class_num=length(class);
    for i = 1:length(class)
        index = label==class(i);
        class_num = sum(index);
        if class_num==0
            te_class_num=te_class_num-1;
        else
            class_true_num(i) = sum(class(i)==predict_label(index));
            class_acc(i) = class_true_num(i)/class_num;
            GM = GM*class_acc(i);
        end
    end
    GM = GM^(1/te_class_num);
end