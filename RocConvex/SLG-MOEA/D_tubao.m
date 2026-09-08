function [tubao3] = D_tubao(paretotubao)
%输入paretotubao上一次种群的凸包个体点
%   输出下一代预计种群的参考凸包点（即标量）
init_tubao = paretotubao;
[Value1,~]=sortrows(init_tubao);%计算凸包点
[m,~]=size(Value1);
x=Value1(1:m-1,1);
y=Value1(2:m,2);

tubao=[x y];
[c,number1]=size(tubao);
tubao2=[];
for i=1:c
    p0 = tubao(i,:)';%点
     x=tubao(i,1);
     y=tubao(i,2);
    p1x = 0;
    p1y = 1;
    p2x = 1;
    p2y = 0;
    p1 = [p1x ; p1y];%线的初坐标
    p2 = [p2x ; p2y];%线的末坐标
    p=y/(1-x);
    if(p>1)
        d = abs(det([p2-p1,p0-p1]))/norm(p2-p1);
        x2=x-sqrt(2)*d;
        y2=y-sqrt(2)*d;
    elseif(p<=1)
        d = abs(det([p2-p1,p0-p1]))/norm(p2-p1);
        x2=x+sqrt(2)*d;
        y2=y+sqrt(2)*d;
    end
    tubao1=[x y;x2 y2];
    tubao2=[tubao2;tubao1];
end
tubao3=tubao2;
end

