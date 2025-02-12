
function [rmse]=unmixed(mixed_pixel,endmember,unmixed_method)
%丰度反演
%输入：
%   mixed_pixel 混合像元矩阵
%   endmember 端元向量组
%   unmixed_method 解混方法选择
%       1:无约束解混
%       2:和为1解混
%       3:非负解混
%       4:全约束解混
%输出：
%   abundance 丰度
%   re_mixed 反混矩阵
%   residual_error 残差矩阵

%计算图像基本信息
[~,pixel_n] = size(mixed_pixel);
[band_n,endmember_n] = size(endmember);

switch unmixed_method
    case 1
        abundance = pinv(endmember)*mixed_pixel;
%         abundance2 = (endmember.' * endmember) \ endmember.' * mixed_pixel;
        abundance = max(0,abundance);
        abundance = abundance ./ (ones(endmember_n,1) * sum(abundance));       
%         abundance = hyperUcls( mixed_pixel, endmember );
    case 2
        endmember_1 = ones(band_n+1,endmember_n);
        endmember_1(1:band_n,:) = endmember;
        mixed_pixel_1 = ones(band_n+1,pixel_n);
        mixed_pixel_1(1:band_n,:) = mixed_pixel;
        abundance = pinv(endmember_1)*mixed_pixel_1;
    case 3
        abundance = zeros(endmember_n,pixel_n);
%         for i=1:pixel_n
%             abundance(:,i) = lsqnonneg(endmember,mixed_pixel(:,i));
%         end
        abundance = hyperNnls( mixed_pixel, endmember );
        abundance = max(0,abundance);
%          abundance = abundance ./ (ones(endmember_n,1) * sum(abundance));      
%          abundance = abundance ./ (ones(endmember_n,1) * sum(abundance));         
    case 4
        endmember_1 = ones(band_n+1,endmember_n);
        endmember_1(1:band_n,:) = endmember;
        mixed_pixel_1 = ones(band_n+1,pixel_n);
        mixed_pixel_1(1:band_n,:) = mixed_pixel;
        abundance = zeros(endmember_n,pixel_n);
        for i=1:pixel_n
            [abundance(:,i) ,~,~,EXITFLAG] = lsqnonneg(endmember_1,mixed_pixel_1(:,i));
            if EXITFLAG == 0
                disp(num2str(i));
            end
        end
    otherwise
        disp('输入错误！');
end
% abundance(abs(abundance)<10^(-4))=0;
re_mixed = endmember*abundance;
residual_error =abs( mixed_pixel-re_mixed);

A=abundance;
rmse = sum(sqrt(sum(residual_error.^2)/band_n))/pixel_n;

end
