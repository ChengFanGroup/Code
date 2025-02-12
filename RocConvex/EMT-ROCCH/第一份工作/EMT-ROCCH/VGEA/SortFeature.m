function [info, r] = SortFeature(data, label)
% Get infomation from dataset

    c = GetPearsonCorr(data, label);
    [~, r1] = sort(c, 'descend');
    [~, r1] = sort(r1, 'ascend');

    [su, ent] = GetSU(data, label);
    [~, r4] = sort(su, 'descend');
    [~, r4] = sort(r4, 'ascend');

    [~, r5] = sort(ent, 'descend');
    [~, r5] = sort(r5, 'ascend');

    % chi2 = getChi2(data, label);
    % [~, r6] = sort(chi2, 'descend');
    % [~, r6] = sort(r6, 'ascend');

    % r = r1 .* r4 .* r6;
    % r = r1 .* r4;
    r = (r1 + r4) ./ 2;
    % r = r4 .* r5;
    r = r';
    c = (c - min(c)) ./ (max(c) - min(c));
    su = (su - min(su)) ./ (max(su) - min(su));
    ent = (ent - min(ent)) ./ (max(ent) - min(ent));
    % chi2 = (chi2 - min(chi2)) ./ (max(chi2) - min(chi2));
    % info = [c, su, chi2];
    info = [c, su];

    info(isnan(info)) = 0;

end


function [su, ent] = GetSU(x, y)

su = zeros(size(x, 2), 1);
ent = zeros(size(x, 2), 1);
for i = 1 : size(x, 2)
    [su(i), ent(i)] = MItest(x(:, i), y);
end

end

function [mi, Ha] = MItest(a,b)
%culate MI of a and b in the region of the overlap part

%计算重叠部分
[Ma,Na] = size(a);
[Mb,Nb] = size(b);
M=min(Ma,Mb);
N=min(Na,Nb);

%初始化直方图数组
hab = zeros(256,256);
ha = zeros(1,256);
hb = zeros(1,256);

%归一化
if max(max(a))~=min(min(a))
    a = (a-min(min(a)))/(max(max(a))-min(min(a)));
else
    a = zeros(M,N);
end

if max(max(b))-min(min(b))
    b = (b-min(min(b)))/(max(max(b))-min(min(b)));
else
    b = zeros(M,N);
end

a = double(int16(a*255))+1;
b = double(int16(b*255))+1;

%统计直方图
for i=1:M
    for j=1:N
       indexx =  a(i,j);
       indexy = b(i,j) ;
       hab(indexx,indexy) = hab(indexx,indexy)+1;%联合直方图
       ha(indexx) = ha(indexx)+1;%a图直方图
       hb(indexy) = hb(indexy)+1;%b图直方图
   end
end

%计算联合信息熵
hsum = sum(sum(hab));
index = find(hab~=0);
p = hab/hsum;
Hab = sum(sum(-p(index).*log(p(index))));

%计算a图信息熵
hsum = sum(sum(ha));
index = find(ha~=0);
p = ha/hsum;
Ha = sum(sum(-p(index).*log(p(index))));

%计算b图信息熵
hsum = sum(sum(hb));
index = find(hb~=0);
p = hb/hsum;
Hb = sum(sum(-p(index).*log(p(index))));

%计算a和b的互信息
mi = Ha+Hb-Hab;

%计算a和b的归一化互信息
%mi = hab/(Ha+Hb);
end

function v = getVar(data)

featNum = size(data, 2);

v = zeros(featNum, 1);

for i = 1 : featNum
    v(i) = var(data(:, i));
end

end


function chi2 = getChi2(data, label)

[m, n] = size(data);

chi2 = zeros(n, 1);
for i = 1 : n
    [~, chi2(i), ~, ~] = crosstab(data(:, i), label);
end

end


function c1 = GetPearsonCorr(data, label)

[m, n] = size(data);

c1 = zeros(n, 1);

for i = 1 : n
    c1(i) = abs(corr(data(:, i), label, 'type', 'Pearson'));
end

end