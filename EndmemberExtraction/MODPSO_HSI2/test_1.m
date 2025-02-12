clear
clc

a=ones(1,2)

% f1 = [0.0372 0.5   
%      0.6861 6    
%      0.6233 0.9    
%      0.6233 0.9];
% %  
%  [f1,idx] = unique(f1,'row');
%  if length(idx) < 4 
%      for j = length(idx)+1:4
%          f1(j,randperm(2,1))=1;
%      end
%  end
%  a=[ 1 0 0 
%      0 1 1
%      1 0 1];
%  temp1=a(sum(a,2)==2,:)
%  temp2=a(sum(a,2)~=2,:)
% b=[ 0 1 0 0 0 0 0 0]; 
% one_idx = find(b(1,:)==1)
% if any(one_idx>=3)
%     one_idx = one_idx+1
% end 

%  c=3;
%  d=[1 0 1];
% %  a = cat(2,a(1,1:c),b(1,c+1:7));
% % b = cat(2,b(1,1:c),a(1,c+1:7));
% 
% e =[a;d];
% f=sum(a(1,:));
% f
%  
% g=mod(30,15)
%  
% z=randsrc(1,20,[1,0,-1; 1/2,3/20,7/20])



% xxx=[1 0 0 1 0 0 1]
% p1=ones(1,sum(xxx==1));
% q1=zeros(1,sum(xxx==0));
% p1(rand(1,nume1(p1))<1/nume1(p1))=0;
% q1(rand(1,nume1(q1))<1/nume1(q1))=1;
% xxx([find(xxx==1),find(xxx==0)])=[p1,q1]


f_x=[
    0.0582    0.4535  
    0.0519    0.0144    
    0.0518    0.0049   
    0.0522    0.0141  
    0.0633    0.0069    
    0.0564    0.0233    
    0.0519    0.0145   
    0.0654    0.2014    
    0.0314    0.0056    
    0.0533    0.1732    
    0.0704    0.0601    
    0.0496    0.0148    
    0.00487       182   
    477       298   
    0.0526    0.0084    
    0.0520    0.0123    
    0.0575    0.0084    
    524       603    
    1.0000    2.0000
    3.0000    4.0000];
p_index = TournamentSelection(5,2,f_x(:,1),f_x(:,2))
% 
% temp1fit(temp1fit(:,4)==1,:)
% find(temp1fit(:,4)==1) 
% temp1fit =[1,1;2,2;1.1,0.9;3,3;2,8;4,4;4,4;0.5,3];
% [FrontNo,MaxFNo] = NDSort(temp1fit,3)
% CrowdDis = CrowdingDistance(temp1fit,FrontNo)
% F(1).ss=find(FrontNo(1,:)==1)
% F(2).ss=find(FrontNo(1,:)==inf)
% F(1)
% F(2)
% F.ss=[]

% mod(95,100)
% randperm(2,1)
% random_choose(2,1)
% 
% new_x=[1 0 1 0
%        0 1 0 1
%        1 0 0 0
%        1 1 1 0
%        1 0 0 1]
% temp1=new_x(sum(new_x,2)==2,:)
% temp2=new_x(sum(new_x,2)~=2,:) 
% temp2fit=[3
%           5
%           7
%           2
%           1
%           9]
% [~,idx_t2fit]=sort(temp2fit);
% idx_t2fit

% M=2;  %目标个数
% x_num=30; %问题维度
% x_max=ones(1,x_num);
% x_min=zeros(1,x_num);   
% N = 200;          % 种群大小
% X = repmat(x_min,N,1)+rand(N,x_num).*repmat(x_max-x_min,N,1) 

% randperm(10)
% 
% v1=[99  99  11  14]
% temp1=unique(v1)
% m1=randperm(2,4-length(temp1))
% temp1=[temp1,m1]
% v1=temp1
% randi([1,10],1,4)


