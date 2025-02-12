function [pop,obj_value,g] = ChooseReduce(mediumpop,medium_obj_value,refpoint)
% 基于参考点排序+选出子代
    [mediumpopnum,V] = size(mediumpop);
    [medium_obj_num,~] = size(medium_obj_value);
    [pointnum,~] = size(refpoint);
    %初始化子代
    pop = zeros(mediumpopnum/2,V);
    obj_value = zeros(medium_obj_num/2,2);
    
    optimalpoint = refpoint(1,:);
    leftpoint = refpoint(2:(pointnum+1)/2,:);
    toppoint = refpoint((pointnum+1)/2+1:pointnum,:);
    
    T = 0;
    front = 1;
    F(front).p = [];
   
    while(T<mediumpopnum/2) 
        %找出每个参考点的最近个体的索引
        for i = 1:pointnum
            if i == 1
                x0 = optimalpoint(1);
                y0 = optimalpoint(2);
                dset = zeros(medium_obj_num,1);
                for j = 1:medium_obj_num
                    x1 = medium_obj_value(j,1);
                    y1 = medium_obj_value(j,2);
                    dset(j) = sqrt((x0-x1)^2+(y0-y1)^2);
                end
                [~,index] = min(dset);
                F(front).p = [F(front).p index];
            elseif mod(i,2) == 0
                x0 = leftpoint(i/2,1);
                y0 = leftpoint(i/2,2);
                dset = zeros(medium_obj_num,1);
                for j = 1:medium_obj_num
                    x1 = medium_obj_value(j,1);
                    y1 = medium_obj_value(j,2);
                    dset(j) = sqrt((x0-x1)^2+(y0-y1)^2);
                end
                [~,index] = min(dset);
                F(front).p = [F(front).p index];
            elseif mod(i,2) == 1
                x0 = toppoint((i-1)/2,1);
                y0 = toppoint((i-1)/2,2);
                dset = zeros(medium_obj_num,1);
                for j = 1:medium_obj_num
                    x1 = medium_obj_value(j,1);
                    y1 = medium_obj_value(j,2);
                    dset(j) = sqrt((x0-x1)^2+(y0-y1)^2);
                end
                [~,index] = min(dset);
                F(front).p = [F(front).p index];
            end
        end
        F(front).p = unique(F(front).p,'stable');
        f = length(F(front).p);
        %返回最好个体数
        if(front == 1)
            if(f<=mediumpopnum/2)
                g = f;
            else
                g = mediumpopnum/2;
            end
        end
        if(T+f<=(mediumpopnum/2))
            pop(T+1:T+f,:) = mediumpop(F(front).p,:);
            obj_value(T+1:T+f,:) = medium_obj_value(F(front).p,:);
            for k = F(front).p
                medium_obj_value(k,1) = 1;
                medium_obj_value(k,2) = 0;
            end
            T = T+f;  
        else
            pop(T+1:mediumpopnum/2,:) = mediumpop(F(front).p(1:mediumpopnum/2-T),:);
            obj_value(T+1:mediumpopnum/2,:) = medium_obj_value(F(front).p(1:mediumpopnum/2-T),:);
            T = mediumpopnum/2;
        end
        front = front+1;
        F(front).p = [];
    end
end

