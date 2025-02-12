function [W] = reliefF(train_data,train_target,iterations,k)
%   计算每个特征的权重
%
    
[samples,features] = size(train_data);


    %划分两类
    p = 0;
    for num = 1:samples
        if train_target(num) == 1
            p = p+1;
        end
    end
    P_data = train_data(1:p,:);
    N_data = train_data(p+1:end,:);
%     P_target = train_target(1:p,:);
%     N_target = train_target(p+1:end,:);
    
    W = zeros(1,features);
    for i = 1 : iterations
        r = randperm(samples,1);
        R = train_data(r,:);
        dis_P = zeros(p,1);
        dis_N = zeros(samples-p,1);
        for j = 1:p
            dis_P(j) = norm(R-P_data(j,:)); 
        end
        for j = 1:samples-p
            dis_N(j) = norm(R-N_data(j,:)); 
        end
        %同类最近k个样本记为H，异类记为M
        [~,index_P] = sort(dis_P);
        [~,index_N] = sort(dis_N);
        if r>p
            H = N_data(index_N(2:k+1),:);
            M = P_data(index_P(1:k),:);
        else
            H = P_data(index_P(2:k+1),:);
            M = N_data(index_N(1:k),:);
        end
        %计算R样本与H/M样本在特征a上的差值
        DH = zeros(k,features);
        DM = zeros(k,features);
        for j = 1:k
            for t = 1:features
                DH(j,t) = abs(R(1,t)-H(j,t));
                DM(j,t) = abs(R(1,t)-M(j,t));
            end
        end
        %更新W
        for j = 1:features
            W(j) = W(j) - sum(DH(:,j))/(i*k) + sum(DM(:,j))/(i*k);
        end
    end
end

