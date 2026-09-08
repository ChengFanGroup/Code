function [index,pareto]=chraarea(position)
%position代表坐标点
%直接调用matlab凸包函数来做

position = [0 0;position;1 1];
index = [];
pareto = [];
if(size(position,1)<3)
    ConvexHull=position;
    ConvexHull1=(1:size(position,1))';
else
    try
        ConvexHull1=convhull(position(:,1),position(:,2));%构建凸包集
        ConvexHull = ConvexHull1;
        ConvexHull=position(ConvexHull,:);
    catch
        %当所输入的点都是一条线上的点，convhull无法处理，跳转到catch中来处理
        if all(position(:,1)==zeros(size(position,1),1))%点集中在y轴上
            position=sortrows(position,2);%按y值大小进行排序，从小到大
        end
        if all(position(:,2)==zeros(size(position,1),1))
            position=sortrows(position,1);
        end
        pareto=position(size(position,1),:);
        index=size(position,1);
        return;
    end
end
% figure(1)
% plot(position(:,1),position(:,2),'r*');
% hold on;
% plot(ConvexHull(:,1),ConvexHull(:,2),'b-');



if(length(ConvexHull)==1||length(ConvexHull)==2)
    pareto=ConvexHull;
    index=ConvexHull1;
    return;
end

% 
% figure(1)
% plot(position(:,1),position(:,2), 'r*');
% hold on;
% plot(positiontemp(:,1),positiontemp(:,2),'b-');
% axis([0 1 0 1]);

% ConvexHull(size(ConvexHull,1),:)=[];%因为pareto面中最开始和结束的点会有重复，因此，需要将最后一个点删除掉，防止对pareto面的产生过程产生干扰
% tempposition=position(ConvexHull,:);
ConvexHull(1,:)=[];
ConvexHull1(1,:)=[];
tempposition=ConvexHull;



[~,leftmost]=min(tempposition(:,1));%最左边的点
% [~,downmost]=min(tempposition(:,2));%最下边的点
[~,upmost]=max(tempposition(:,2));%最上面的点

%确定一个点是否同时最左和最下的点
[allleftmost,~]=find(tempposition(leftmost,1)==tempposition(:,1));%找出所有的x坐标是最小的点
% [alldownmost,~]=find(tempposition(downmost,2)==tempposition(:,2));%找出所有的y坐标是最小的点
[allupmost,~]=find(tempposition(upmost,2)==tempposition(:,2));%找出所有的y坐标是最大的点

allleftmost=tempposition(allleftmost,:);
% alldownmost=tempposition(alldownmost,:);
allupmost=tempposition(allupmost,:);

[~,leftmostup]=min(allleftmost(:,2));%最左上边的
% [~,downmostleft]=min(alldownmost(:,1));
[~,upmostleft]=max(allupmost(:,1));%最上边的点中最右边的

% leftmostup=allleftmost(leftmostup,:);
% downmostleft=alldownmost(downmostleft,:);

leftmostup=allleftmost(leftmostup,:);
upmostleft=allupmost(upmostleft,:);


leftmost=findindex(tempposition,leftmostup);
upmost=findindex(tempposition,upmostleft);

% [~,leftmost]=min(tempposition(alldownmost,1));%再从所有最下面的点中找出最左边的点
% [~,downmost]=min(tempposition(alldownmost,1));%再从所有最左边的点中找出最下面的点




if(leftmost==upmost)
    pareto(1)=leftmost;
else
% [downmosty,downmost]=min(tempposition(:,2));
% 
% [leftmostx2,leftmost2]=min(position(:,1));
% [downmosty2,downmost2]=min(position(:,2));

%生成pareto面的时候第一个点必须是最下并且最左的点



uptemp=upmost;
% downtemp=downmost;

i=1;
pareto(i)=uptemp;
uptemp=mod(uptemp,size(tempposition,1))+1;
% while(lefttemp<upmost)
while(uptemp~=leftmost)
%     if(~(zhipei(leftmost,lefttemp)))
%         i=i+1;
%         pareto(i)=lefttemp;
%         leftmost=lefttemp;
%     end
    i=i+1;
    pareto(i)=uptemp;
    uptemp=mod(uptemp,size(tempposition,1))+1;
end
i=i+1;
pareto(i)=uptemp;
end
 index = ConvexHull1(pareto,:);
pareto=ConvexHull(pareto,:);%将tempposition中点的序号转换为position中的序号
end




