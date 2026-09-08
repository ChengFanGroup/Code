function [t2] = testquchu10(paretotubaotestckbaoliu1)
%TESTQUCHU10 此处显示有关此函数的摘要
%   此处显示详细说明
t2=paretotubaotestckbaoliu1;
t2=t2';
[~,n]=size(t2);
c=0;
for i=1:n
    if(t2(2,i)==1 )
        c=c+1;
    end
end
q=sortrows(t2',"ascend")';
c1=0;
for i=1:n
    if(q(1,i)==0)
        c1=c1+1;
    end
end
if(c==0 || c1==0)
    t2=paretotubaotestckbaoliu1;
else
    px=t2(:,c);
    py=q(:,c1);
    t2(:,any(t2==0))=[];
    t2(:,any(t2==1))=[];
    t2=[px t2 py];
    t2 = t2(:,any(t2~=1, 1));
    t2=t2';
    t2(all(t2==0,2),:)=[];
end
end

