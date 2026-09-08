function functionvalue=clos_2(results2,popnum,~,cankaotubao)


U=results2;

% A caller may already have retained N convex-hull points, in which case
% it requests zero additional individuals. Return a correctly shaped empty
% matrix instead of leaving the output argument unassigned.
functionvalue=zeros(0,size(U,2));
if isempty(U) || popnum<=0
    return;
end


num=min(floor(popnum),size(U,1));
M=size(cankaotubao,1)-1;
N=size(U,1);

% Defensive fallback for a degenerate reference hull.
if M<1
    functionvalue=U(1:num,:);
    return;
end

discankao=[];
% Points=setdiff(paretotubao, dis,'rows');
for i=1:M
    p1=cankaotubao(i,:)';
    p2=cankaotubao(i+1,:)';
    distance1=zeros(1,N);
    paixu=[];
    index=[];
    for j=1:N
        p0=U(j,:)';
        distance1(j)=abs(det([p2-p1,p0-p1]))/norm(p2-p1);%p0,p1,p2均为列向量
    end
        [~,index]=sort(distance1);
        discankao=[discankao;index];
end

number=0;
ind=[];
ind1=[];
ind2=[];
ind3=[];
j1=1;
while number < num
    %-------这里实现将每个个体与参考线距离去除重复------------------
    for i1=1:M
        ind=[ind discankao(i1,j1)];%discankao里面存储的是距离的序号22*200，
        % 每一列代表一个个体与所有参考点的距离
        ind=unique(ind);%去除重复并从大到小排序
        number=size(ind,2);
        if number>=num
%             population=newpopulation(ind,:);
            functionvalue=U(ind,:);
            return ;
        end
    end
    j1=j1+1;
end



% p0 = [p0x ; p0y];
% p1 = [p1x ; p1y];
% p2 = [p2x ; p2y];
% d = abs(det([p2-p1,p0-p1]))/norm(p2-p1);
% 


