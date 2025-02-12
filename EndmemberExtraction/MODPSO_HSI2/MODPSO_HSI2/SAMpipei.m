function [table] = SAMpipei(A1,A2)
%光谱角度匹配 :A1，A2为待匹配光谱矩阵，A1为参考 A2为估计矩阵
%大小为band*p1 band*p2，p1为参考光谱个数，p2为估计光谱个数,
[band,p1] = size(A1);
[band,p2] = size(A2);
table = zeros(4,p2+2);
for i=1:p2
    table(2,i)=i ;%表格中第2个为估计光谱序号，第1行为参考光谱序号
    temp1=100;
    for j = 1:p1
        temp2 = SAM(A1(:,j),A2(:,i));
        if temp2<temp1
            temp1=temp2;
            table(1,i)= j;
            table(3,i)= temp2;
            table(4,i)= temp2*180/3.1415926;
        end
        
    end
end
table(3,p2+1)=sum(table(3,1:p2))/p2;
table(4,p2+1)=sum(table(4,1:p2))/p2;
table(3,p2+2)=std(table(3,1:p2));
table(4,p2+2)=std(table(4,1:p2));