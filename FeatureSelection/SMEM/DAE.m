% 加载数据集
dataName = {'Brain2'};
load(['D:/dataset/FS_DATASET/FS_DATASET_MAT/', dataName{1}]);  % 请替换为您的数据集的文件名

% 设定自动编码器的参数
input_size = size(data, 2);  % 输入数据的特征维度（列数）
hidden_size = 2;  % 设定隐藏层大小为2，即将输入数据降维为2维
learning_rate = 0.01;  % 学习率
num_epochs = 100;  % 训练轮数

% 初始化自动编码器的权重参数
W1 = randn(hidden_size, input_size);  % 编码器的权重
W2 = randn(input_size, hidden_size);  % 解码器的权重

% 训练自动编码器
for epoch = 1:num_epochs
    % 前向传播
    z = 1./(1 + exp(-W1 * data'));  % 编码，注意转置
    reconstruction = 1./(1 + exp(-W2 * z));  % 解码
    
    % 反向传播
    delta = (reconstruction - data') .* (reconstruction .* (1 - reconstruction));  % 计算误差
    dW2 = delta * z';  % 解码器权重的梯度
    delta = (W2' * delta) .* (z .* (1 - z));  % 反向传播到编码器
    dW1 = delta * data;  % 编码器权重的梯度
    
    % 更新权重
    W1 = W1 - learning_rate * dW1;
    W2 = W2 - learning_rate * dW2;
end

% 将输入数据降维为二维
encoded_data = 1./(1 + exp(-W1 * data'));  % 注意转置
% 转置结果以满足要求
encoded_data = encoded_data';
% 可视化降维结果
scatter(encoded_data(1, :), encoded_data(2, :));
xlabel('Feature 1');
ylabel('Feature 2');
title('2D Representation of Input Data');