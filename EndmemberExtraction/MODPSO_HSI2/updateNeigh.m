function  [X,fit ]= updateNeigh(X,fit,Bi,y,y_fit) 
 
for i=1:length(Bi)
%比较新的解y和邻居切比雪夫分解法的g值
    g1 = teFit(fit(Bi(i),:),Bi(i));
    g2 = teFit(y_fit,Bi(i));
    if  g2 <= g1
% 如果y的g值小，更新邻居
        X(Bi(i),:) = y;
        fit(Bi(i),:) = y_fit;
    end
end
 