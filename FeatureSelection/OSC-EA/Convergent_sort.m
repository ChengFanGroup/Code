function CF = Convergent_sort(obj, allerr, gen)
    % Modified and commented by Fanrong Kong
    %% sperate

    obj2 = unique(obj(:,2),'rows');
    resx = sort(obj2);

    % 错误率参考
    x = allerr;
    
    % 特征数参考
    y = resx(ceil(length(resx)*(1/3)));
    
    % Convergence front(CF)
    CF = zeros(1, size(obj, 1));
    sumF = zeros(1, 4);
    for i = 1:size(obj, 1)
        if (obj(i,1) < x) && (obj(i,2) < y)
            % 错误率和特征数都好
            CF(i) = 1;
            sumF(1) = sumF(1) + 1;
        elseif (obj(i,1) <= x) && (obj(i,2) >= y)
            % 错误率好，但特征数差
            CF(i) = 2;
            sumF(2) = sumF(2) + 1;
        elseif (obj(i,1) >= x) && (obj(i,2) <= y)
            % 错误率差，但特征数好
            CF(i) = 3;
            sumF(3) = sumF(3) + 1;
        else
            % 错误率和特征数都差
            CF(i) = 4;
            sumF(4) = sumF(4) + 1;
        end
    end

    
    
    
end