function idx = random_choose(n,m)
%从n个数里随机选择m个，返回索引
w=1:n;
idx=zeros(1,m);
for i=1:m
    p=fix(rand()*n)+1;
    idx(i)=w(p);
    w=setdiff(w,w(p));
    n=n-1;
end

%可以改进为直接从数组中选元素，返回数组
end