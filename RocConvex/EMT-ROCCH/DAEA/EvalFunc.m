% function Obj = EvalFunc(Pop)
%     global Global
%     args = Global.knnArgs;
%     
%     [N, D] = size(Pop);
%     Obj = zeros(N, 2);
%     X = zeros(1,D);
%     for i = 1:N
%         % calculate the ratio of selected features
%         Obj(i, 1) = sum(Pop(i, :)) / D;
%         if Obj(i, 1) == 0
%             Obj(i, 2) = 1;
%         else
%             tempSamples = Global.samples(:, [Pop(:,) == 1, true]);
%             if nargin < 2 % error of train dataset
%                 err = KCrossValidate(tempSamples, @knn, args.CVs, args.knearest); % k-fold cross validation
%                 err = KNNLOOCV();
%             else % error of test dataset
%                 trainInx = randperm(size(tempSamples, 1), ceil(args.trainR * size(tempSamples, 1)));
%                 testInx = setdiff([1:size(tempSamples, 1)], trainInx);
%                 trainData = tempSamples(trainInx, :);
%                 testData = tempSamples(testInx, :);
%                 err = knn(trainData(:, 1:end-1), testData(:, 1:end-1), trainData(:, end), testData(:, end), args.knearest);
%             end
%             Obj(i, 2) = err;
%         end
%     end
% end



% k-fold cross validation
% function err_rate = KCrossValidate(data, func, k, funcArg)
%     n = size(data, 1);
%     inx = randperm(n);
%     Gnum = floor(n/k);
%     Err = zeros(1,k);
%     for ii = 1:k
%         ub = min(ii*Gnum - 1, n);
%         testInx = inx((ii-1)*Gnum+1:ub);
%         trainInx = setdiff(inx, testInx);
%         trainData = data(trainInx, :);
%         testData = data(testInx, :);
%         Err(ii) = func(trainData(:, 1:end-1), testData(:, 1:end-1), trainData(:, end), testData(:, end), funcArg);
%     end
%     err_rate = mean(Err);
% end
% 
% function err_rate = knn(train_data, test_data, train_target, test_target, k)
%     classification_accuracy = 0;
%     for i = 1:size(test_data, 1)
%         %============================================
%         %         Calculating Euclidean Distance
%         %============================================
%         D = test_data(i, :) - train_data(: , :);
%         D = D.^2;
%         dist_mat = sum(D, 2);
%         dist_mat = sqrt(dist_mat);
%         dist = [dist_mat train_target];
%         %============================================
%         %  Sorting Row according to minimum distance
%         %============================================
%         dist = sortrows(dist, 1);
%         %============================================
%         %       If K value is 1 Print Results
%         %============================================
%         if k == 1
%             k_neighbours = dist(k, :);
%             predicted = k_neighbours(1, 2);
%             true = test_target(i, 1);
%             if true == predicted
%                 accuracy = 1;
%                 classification_accuracy = classification_accuracy + accuracy;
%             end
%             % fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f \n', i, predicted, true, accuracy)
%         %===============================================
%         % Else K value is greater then 1 Print Results
%         %===============================================
%         else
%             k_neighbours = dist(1:k, :);            
%             if size(unique(k_neighbours(:, 2))) == 1
%                 predicted = unique(k_neighbours(:, 2));
%             elseif size(unique(k_neighbours(:, 2))) == k
%                 predicted = k_neighbours(1, 2);
%             else
%                 predicted = mode(k_neighbours(:, 2));
%             end
%             true = test_target(i, 1);
%             if true == predicted
%                 accuracy = 1;
%                 classification_accuracy = classification_accuracy + accuracy;
%             end
%             % fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f \n', i, predicted, true, accuracy)
%         end
%     end
%     % fprintf('classification_accuracy=%6.4f \n', classification_accuracy/size(test_target, 1))
%     err_rate = (size(test_target, 1) - classification_accuracy)/size(test_target, 1);
% end



