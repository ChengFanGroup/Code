function [F1,recall,precision]=getF1(weight,Test_Dataset,Test_Label)
    Dom=size(Test_Dataset,2);
    load('classifier');
    Fnum=size(weight,1);
    for j=1:Fnum
     for i=1:Dom
         if weight(j,i)>0.5
             new(j,i)=1;
         else
             new(j,i)=0;
         end
     end
    end
     newpop=new.*classifier(:,1:Dom);
% Reference=[1,1];  
for i=1:Fnum
    test_result = newpop(i,1:Dom) * Test_Dataset'+classifier(:,end);
    test_result(find(test_result<=0)) = -1;
    test_result(find(test_result>0)) = 1;       
    predictlabel=test_result';
    
    tp=0;
    fp=0;
    fn=0;
    tn=0;
    for y = 1:size(predictlabel,1)
        if predictlabel(y,1)==1 && Test_Label(y,1)==1
            tp=tp+1;
        elseif predictlabel(y,1)==1 && Test_Label(y,1)==-1
            fp=fp+1;
        elseif predictlabel(y,1)==-1 && Test_Label(y,1)==1
            fn=fn+1;
        elseif predictlabel(y,1)==-1 && Test_Label(y,1)==-1
            tn=tn+1;
        end
    end

    precision(i) = tp / (tp + fp);
    recall(i) = tp / (tp + fn);
    F1(i) = (2 * precision(i) * recall(i))/ (precision(i) + recall(i));
end
    if sum(isnan(F1))==length(F1)
        F1=0;
        recall=0;
        precision=0;
    else
        index=find(F1==max(F1));
        F1=F1(index(1));
        recall=recall(index(1));
        precision=precision(index(1));
    end

end
 