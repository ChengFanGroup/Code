% load('C:\Users\chnk\Desktop\data\local\Local_data1.mat')
%fengdu tu 
load('C:\Users\chnk\Desktop\data\local\Local_data2.mat')
load('C:\Users\chnk\Desktop\data\urban\MYEA_data4.mat')
load Urban_R162.mat
load end6_groundTruth.mat
reference = M;
X = Y./1000;  %307.307
[~,A]=unmixed2(X,X(:,Mbest_x(3,:)==1),3);



A=max(0,A);
[p,n] = size(A); 
row =307;
col =307;
image_3d = zeros(row,col,p);
for i = 1:p
    image_3d(:,:,i) = reshape(A(i,:),row,col);
end
a=image_3d(:,:,1);
b=image_3d(:,:,2);
c=image_3d(:,:,3);
d=image_3d(:,:,4);
e=image_3d(:,:,5);
f=image_3d(:,:,6);
figure(1)
imagesc(a)%»­Í¼
colorbar;
figure(2)
imagesc(b)
colorbar;
figure(3)
imagesc(c)
colorbar;
figure(4)
imagesc(d)
colorbar;
figure(5)
imagesc(e)
colorbar;
figure(6)
imagesc(f)
colorbar;

