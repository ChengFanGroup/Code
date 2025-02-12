function [Index_F,y1,y2,tt1] = FS_VSCCPSO(x,y)
%FS_VSCCPSO 此处显示有关此函数的摘要
%   此处显示详细说明

%主程序
%-----初始化参数
% clear
X = [y x];
X=data_t(X);
[kk,k]=size(X);
bounds(1:k-1,1)=0;  %对每一维粒子设置边界
bounds(1:k-1,2)=1;
N=100;%个体的总数目
mm=2;%协同进化，分成了三组
popsizemax=min(N,(2*N)/mm);
popsizemin=max(5,N/(2*mm));
TMAX=7000;
AC=[];
%--------------------------------------特征分组
[u,F]=grouping(k,X,mm);
%--------------------------------------子种群规模初始化
pop=cell(mm,1);
popsize=zeros(mm,1);
Fim_p=zeros(mm,1);%保存子空间重要程度
w=zeros(mm,1);%保存子种群初始化时每个子空间的权重
for i=1:mm
    Fim_p(i)=sum(F{i});
end
p_sum=sum(Fim_p);
for i=1:mm
    w(i)=Fim_p(i)/p_sum;
    popsize(i)=round((w(i))*N);
    if popsize(i)<popsizemin
        popsize(i)=popsizemin;
    end
    if popsize(i)>popsizemax
        popsize(i)=popsizemax;
    end
end
%-------------------------------------初始化得到mm个初始种群，分别对应pop1，pop2，pop3...popmm
for i=1:mm
    
    pop{i}=initialize(popsize(i),bounds,u{i});
    
end
%--------------------------------------
% 每个子种群进行解码
xpop=cell(mm,1);
for i=1:mm
    m1=size(pop{i},2);
    xpop{i}=jiema(pop{i},m1);
end


%--------------------------------------
%%%计算个体适应值，并保存初始位置后，个体和全局极值点
popeff=cell(mm,1);
zheneff=cell(mm,1);
LBEST=cell(mm,1);
gbest=cell(mm,1);
jie_lbest=cell(mm,1);
jie_gbest=cell(mm,1);
fmax=cell(mm,1);% fmax存放每个子种群中所有代的最优值
fmin=cell(mm,1);
d_ave=cell(mm,1);%  D_ave存放每个子种群中代表多样性的种群适应值的均值

F_max=cell(mm,1);
D_ave=cell(mm,1);
a=zeros(mm,1);
d=zeros(mm,1);

A=cell(100,1);
D=cell(100,1);
no_eva_times=cell(mm,1);
for i=1:mm
    [zheneff{i},popeff{i}]=evaluation1(xpop{i},xpop,pop{i},X,i,kk,k,u,popsize,popsize(i),mm);
    LBEST{i}=zheneff{i};
    jie_lbest{i}=popeff{i};
    m=size(pop{i},2);
    [~,va2]=sort(LBEST{i}(:,m+1));
    gbest{i}=LBEST{i}(va2(popsize(i)),1:m+2);
    jie_gbest{i}=jie_lbest{i}(va2(popsize(i)),:);
    %%%----------------------------------计算每个子种群第一代的最优值和多样性值
    fmax{i}=max(popeff{i}(:,k));
    fmin{i}=min(popeff{i}(:,k));
    d0=sum(popeff{i}(:,k));
    d1=(1/popsize(i))*d0;
    d2=0;
    for ii=1:size(popeff{i},1)
        d2=d2+abs(popeff{i}(ii,k)-d1);
        %              d2=d2+abs((popeff{i}(ii,k)-d1)/(fmax{i}-fmin{i}));
    end
    d_ave{i}=(1/popsize(i))*d2;
    %--------------------------------------------------------------------
    no_eva_times{i}=popsize(i);
end
F_max{i}=[ F_max{i};fmax{i}];
D_ave{i}=[ D_ave{i};d_ave{i}];
t0=clock;
t_0=cell(mm,1);% ————————————自适应判据中间的间隔代数进化能力公式中的间隔
% t_1=ones(1,mm);% ————————————自适应判据中间的间隔代数
p_swich=zeros(1,mm);% —————————增加或删减规模规模的判断开关
N_swich=zeros(1,mm);% —————————增加或删减规模的大小
pN_swish=zeros(1,mm);% —————————增加或删减规模的大小
C_D=zeros(1,mm);
M=zeros(1,mm);
M1=zeros(1,mm);
eva_times=0;
for ii=1:mm
    eva_times=eva_times+no_eva_times{i}(1);
    %     stagnation{ii}=1;
end
%    t=1;
T=1;
while(eva_times<=TMAX)
    %gb2=cell(mm,1);gb3=[];gb1=cell(mm,1);
    before_popsize=popsize;
    eva_times=0;
    before_gbest=gbest;
    for i=1:mm
        if length(F_max{i})>2
            a(i)=(F_max{i}(length(F_max{i}))-2*F_max{i}(length(F_max{i})-t_0{i})+F_max{i}(length(F_max{i})-2*t_0{i}))/(t_0{i}*2);
            d(i)= D_ave{i}(length(F_max{i}))- 0.8*D_ave{i}(length(F_max{i})-t_0{i});
        end
    end
    A{T}=a;
    D{T}=d;
    for i=1:mm
        m=size(pop{i},2);
        t_0{i}=1;%进化能力公式中的间隔
        Rat_Cmax=max(a);%所有子种群t代进化能力最大值
        Rat_Cmin=min(a);
        Rat_Dmax=max(d);%所有子种群t代多样性变化率最大值
        Rat_Dmin=min(d);
        p_swich(i)=0;
        N_swich(i)=0;
        pN_swish(i)=0;
        C_D(i)=0;
        M(i)=0;
        M1(i)=0;
        m_0=1e-10;%趋向于0的数 
        if length(F_max{i})>2  
            if ( a(i)<0 && d(i)>0  )
                p_swich(i)=-0.5;
                C_D(i)=((Rat_Cmax-a(i)+m_0)/(Rat_Cmax-Rat_Cmin+m_0))+((Rat_Dmax-d(i)+m_0)/(Rat_Dmax-Rat_Dmin+m_0));
                if C_D(i)==0
%                     pN_swish(i)=1;
                    pN_swish(i)=randperm(popsizemin,1);
                else
                    M(i)=popsizemin;
                    pN_swish(i)=0.5*C_D(i)*M(i);%需要减少的粒子数目
                end
                pN_swish(i)=ceil(pN_swish(i));%向正无穷取整
            end
            if (a(i)>0 && d(i)<0  )
                p_swich(i)=1;
                C_D(i)=((a(i)-Rat_Cmin+m_0)/(Rat_Cmax-Rat_Cmin+m_0))*((Rat_Dmax-d(i)+m_0)/(Rat_Dmax-Rat_Dmin+m_0)); 
                if C_D(i)==0
%                     pN_swish(i)=1;
                     pN_swish(i)=randperm(popsizemin,1);
                else
                    M(i)=popsizemin;
                    pN_swish(i)=1*C_D(i)*M(i);%需要增加的粒子数目
                end
                pN_swish(i)=ceil(pN_swish(i));%向正无穷取整
            end
            if (a(i)<0 && d(i)<0  )
                p_swich(i)=0.5;
                C_D(i)=(((Rat_Cmax-a(i)+m_0)/(Rat_Cmax-Rat_Cmin+m_0))+((Rat_Dmax-d(i)+m_0)/(Rat_Dmax-Rat_Dmin+m_0)));
                if C_D(i)==0
%                     pN_swish(i)=1;
                     pN_swish(i)=randperm(popsizemin,1);
                else
                    M(i)=popsizemin;
                    pN_swish(i)=0.5*C_D(i)*M(i);%需要增加的粒子数目
                end
                pN_swish(i)=ceil(pN_swish(i));%向正无穷取整
            end
        end
        [popsize(i),pop{i},LBEST{i},jie_lbest{i},gbest{i},jie_gbest{i}]=uppso(pop{i},gbest{i},LBEST{i},jie_lbest{i},jie_gbest{i},m,before_popsize(i),bounds,p_swich(i),pN_swish(i),zheneff{i},jie_gbest,X,i,kk,k,u,mm,popsizemin,popsizemax,u{i},F{i},eva_times,TMAX);
        [LBEST{i},gbest{i},jie_lbest{i},jie_gbest{i},fmax{i},d_ave{i},zheneff{i},pop{i},no_eva_times{i}]=ppso1(jie_lbest{i},jie_gbest{i},pop{i},LBEST{i},popsize(i),m,jie_gbest,before_gbest,before_gbest{i},X,i,kk,k,u,mm,no_eva_times{i});
        if gbest{i}(1,m+1)==0 && gbest{i}(1,m+2)==0
            break
        end
        
        %%%-----------------------------------------------保存每一个子种群每一代的进化能力和代表多样性的均值
        F_max{i}=[ F_max{i};fmax{i}];
        D_ave{i}=[ D_ave{i};d_ave{i}];
        %---------------------------------------------------------------
        eva_times=eva_times+no_eva_times{i}(1);
    end 
    %%%---------------每一代时，从所有子种群的最优解中，选择一个最好的，作为总的算法的最优解
    Gb=jie_gbest{1};
    for i=2:mm
        if jie_gbest{i}(k)>Gb(k)
            Gb=jie_gbest{i};
        else
            if jie_gbest{i}(k)==Gb(k)&&jie_gbest{i}(k+1)<Gb(k+1)
                Gb=jie_gbest{i};
            end
        end
    end
    
    AC=[AC;Gb]; %记录最优解变化
end
y1=Gb(1,k);
y2=Gb(1,k+1);
gg=Gb(1:k-1);
tt1=etime(clock,t0);
Index_F = find(gg==1);
Index_F = sort(Index_F);


end

