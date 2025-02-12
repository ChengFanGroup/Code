function g = teFit(fit,i)
%切比雪夫分解法
global  lamdaMat z

for j = 1:length(lamdaMat(i,:))
    if lamdaMat(i,j)==0
       lamdaMat(i,j)=0.00001; 
    end
end
g = max( lamdaMat(i,:).*abs(fit - z) );



