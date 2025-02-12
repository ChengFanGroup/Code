%%计算PAUC(付广龙，2018.1.11)暂时不采用
function [Pauc ]=my_paucpredict2( Xte,Yte,alpha,beta,w)  
pos_num1=sum(Yte==1);%number of positive Xte
neg_num1=sum(Yte==-1);%number of negative Xte

n_alpha2=alpha*neg_num1;
if(n_alpha2==round(n_alpha2))
    j_alpha2=ceil(n_alpha2)+1;
else
    j_alpha2=ceil(n_alpha2);
end
n_beta2=beta*neg_num1;
if(n_beta2==round(n_beta2))
    j_beta2=floor(n_beta2)-1;
else
    j_beta2=floor(n_beta2);%测试集变量，
end
f= Xte*w';
f1=[Yte,f];
 FF=sortrows(f1,-1);
xx=0; yy=0; zz=0;mm=0;
xx1=0; yy1=0; zz1=0;
for i=1:pos_num1
    if FF(i,2)>FF((pos_num1+j_alpha2),2)
        xx1 = xx1+1;
    end
end
xx = xx1*(j_alpha2-n_alpha2);

for i1=(pos_num1+j_alpha2+1):(pos_num1+j_beta2)
    for i2=1:pos_num1
        if FF(i2,2)>FF(i1,2)
            yy1 = yy1+1;
        end
    end
end
yy = yy1;

for i3=1:pos_num1
    if FF(i3,2)>FF((pos_num1+j_beta2+1),2)
        zz1 = zz1+1;
    end
end
zz = zz1*(n_beta2-j_beta2);

mm = xx+yy+zz;
Pauc=mm/((beta-alpha)*pos_num1*neg_num1);
% disp('Pauc=');
disp(Pauc);



