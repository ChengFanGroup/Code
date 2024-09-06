function  Index_Fs = FS_customized4( X,Y,TaskNum, maxRate)
%------------------------------------------
% 基于PCC
%------------------------------------------
    %scores = abs(corr(X, Y, 'type', 'Pearson')) ;
    Y(Y==0) = -1;
    scores = [];
    for i = 1 : size(X,2)
        scores = [scores; i abs(corr(X(:,i), Y, 'type', 'Pearson'))];
    end
    %mapminmax(rank(:,1)',0,1);
    rank = sortrows(scores,2,'descend');
    %%%%%%%%%%%%%%%
    featureNum = size(X,2);
    mustSel = round(maxRate * 10 * sqrt(featureNum));%round(sqrt(featureNum));
    maxSel = round(maxRate * (featureNum));
    %%%%%%%%%%%%%%%
    p = 0.6;
    Index_Fs = zeros(TaskNum,featureNum);
       
   for T = 1 : TaskNum
       count = 0;
       for j = rank(:,1)'
           if (count < mustSel)
               Index_Fs(T,j) = 1;
               count = count+1;
           elseif (count < maxSel)  
               if (rand(1) <= p)%Probability(j)
                   Index_Fs(T,j) = 1;
                   count = count+1;
               end
           else
               break;
           end
       end
   end
   
end

