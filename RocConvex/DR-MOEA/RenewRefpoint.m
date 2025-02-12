function new_refpoint = RenewRefpoint(old_refpoint,obj_value,lambda,G,Gmax)
%   调整参考点
%   阈值（1-G/Gmax）*λ
    k = (1-G/Gmax)*lambda;
    [pointnum,~] = size(old_refpoint);
    [obj_num,~] = size(obj_value);
    
    optimalpoint = old_refpoint(1,:);
    leftpoint = old_refpoint(2:(pointnum+1)/2,:);
    toppoint = old_refpoint((pointnum+1)/2+1:pointnum,:);
    new_leftpoint = zeros((pointnum-1)/2,2);
    new_toppoint = ones((pointnum-1)/2,2);
    
    %调整leftpoint
    for i = 1 : (pointnum-1)/2
        dset = zeros(obj_num,1);
        %计算第i个参考点与每个个体距离
        x0 = leftpoint(i,1);
        y0 = leftpoint(i,2);
        for j = 1:obj_num
             x1 = obj_value(j,1);
             y1 = obj_value(j,2);
             if(x0==x1 && y0==y1)
                 dset(j) = 0;
             else
                 dset(j) = sqrt((x0-x1)^2+(y0-y1)^2);
             end
        end
        %对需要调整的点进行修改，存入
        if(min(dset)<k)
            if i == 1
                new_leftpoint(i,2) = leftpoint(i,2)/2;
            elseif i == 2
                new_leftpoint(i,2) = leftpoint(i-1,2)/2;
            else
                gap = zeros(i-1,1);
                gap(1) = leftpoint(1,2);
                for t = 2:i-1
                    gap(t) = leftpoint(t,2)-leftpoint(t-1,2);
                end
                [~,index] = max(gap);
                if index ==1
                    new_leftpoint(i,2) = leftpoint(index,2)/2;
                else
                    new_leftpoint(i,2) = (leftpoint(index,2)+leftpoint(index-1,2))/2;
                end
            end
        else
            new_leftpoint(i,2) = leftpoint(i,2);
        end
    end
    
     %toppoint 调整
    for i = 1 : (pointnum-1)/2
        dset = zeros(obj_num,1);
        %计算第i个参考点与每个个体距离
        x0 = toppoint(i,1);
        y0 = toppoint(i,2);
        for j = 1:obj_num
             x1 = obj_value(j,1);
             y1 = obj_value(j,2);
             if(x0==x1 && y0==y1)
                 dset(j) = 0;
             else
                 dset(j) = sqrt((x0-x1)^2+(y0-y1)^2);
             end
        end
        %对需要调整的点进行修改，存入
        if(min(dset)<k)
            if i == 1
                new_toppoint(i,1) = toppoint(i,1)/2;
            elseif i == 2
                new_toppoint(i,1) = toppoint(i-1,1)/2;
            else
                gap = zeros(i-1,1);
                gap(1) = toppoint(1,1);
                for t = 2:i-1
                    gap(t) = toppoint(t,1)-toppoint(t-1,1);
                end
                [~,index] = max(gap);
                if index == 1
                    new_toppoint(i,1) = toppoint(index,1)/2;
                else
                    new_toppoint(i,1) = (toppoint(index,1)+toppoint(index-1,1))/2;
                end
            end
        else
            new_toppoint(i,1) = toppoint(i,1);
        end     
    end
    
    [~,leftindex] = sort(new_leftpoint(:,2),'descend');
    new_leftpoint = new_leftpoint(leftindex,:);
    [~,topindex] = sort(new_toppoint(:,1));
    new_toppoint = new_toppoint(topindex,:);
    new_refpoint = [optimalpoint;new_leftpoint;new_toppoint];
end

