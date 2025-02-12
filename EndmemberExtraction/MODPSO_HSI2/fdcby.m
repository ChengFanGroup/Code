 function off=fdcby(pa1)
[~,n]=size(pa1);
off=zeros(1,n);
p=sum(pa1);
p1=ones(1,sum(pa1==1));
q1=zeros(1,sum(pa1==0));
p1(rand(1,numel(p1))<1/numel(p1))=0;
q1(rand(1,numel(q1))<1/numel(q1))=1;
pa1([find(pa1==1),find(pa1==0)])=[p1,q1];
if sum(pa1(1,:))==p
    off(1,:)=pa1;
elseif sum(pa1(1,:))>=p
    pa1_idx=find(pa1==1);
    n_idx=pa1_idx(random_choose(length(pa1_idx),p));
    off(1,n_idx)=1;
else
    off(1,:)=pa1;
    zero_idxx=find(pa1==0);
    g=p-sum(pa1(1,:));
    o_idxx=zero_idxx(random_choose(n-p,g));
    off(1,o_idxx)=1;    
end    
end