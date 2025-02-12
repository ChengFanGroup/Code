% function RLIS
% aa means the order of dataset e.g.:aa=1 means that we use the first
% dataset

% the dataset was divided into five folds, e.g.:the dataset 'wdbc' was
% divided into  five folds, in the first fold, the training set is '1n1ftr',the
% test set is '1n1fte',in the second fold, the training set is '1n2ftr',the
% test set is '1n2fte',
%
r = 3;

Gmax = 100;
% tic;
% r=2;
rr = zeros(r, 1);
rr1 = zeros(r, 1);
for i = 1:r
    rr(i, 1) = i*ceil(Gmax/(r+1));
    rr1(i, 1) = rr(i, 1)+ceil(rr(1, 1)/2);
end
% addpath(genpath('C:\Program Files\MATLAB\R2018b\bin\libsvm-3.22\matlab'));
% n=24;%种群大小
% p=5;%子集的个数
n = 100;

poptrain = {};
poptest = {};
popconverge = {};
time = {};

d=input("数据集：");
duli = input("执行次数：");
t=5;%K折
result = zeros(duli,5);
result2 = zeros(duli,6);
TR = zeros(t*100, 2);
TE = zeros(1, t*100);
PF = zeros(1, t*100);
TIME = zeros(1, t);
MAX_TE = zeros(1, t);
MAX_TR = zeros(t, 2);
MAX_GM = zeros(1,t);
MAX_HV = zeros(1,t);
GM = zeros(1, t*100);
Test_Red = zeros(1, t);

avg_TE = zeros(1, t);
avg_TR = zeros(t, 2);
avg_GM = zeros(1,t);
test_HV = zeros(1,t);

for dulix = 1 : duli
    fprintf("\n%d:",dulix);
    tic
    data1 = datasetImport(d);
    [m, ~] = size(data1);
    [data, ~] = mapminmax(data1(:, 1:end-1)');
    dataset = [data', data1(:, end)];
    indices = crossvalind('Kfold', m, t);
    for kk = 1:t         %5折交叉
        fprintf("%d ",kk);
        tic;
        shoulian = []; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------------------------------------收敛度量
        test_index = (indices == kk);
        train_index = ~test_index;




        dataset_tr = dataset(train_index, :);
        label_tr = dataset_tr(:,end);
        inst_tr = dataset_tr(:,1:end-1);


        dataset_te = dataset(test_index, :);
        label_te = dataset_te(:,end);
        inst_te = dataset_te(:,1:end-1);
        label_class = unique(label_tr(:, end));


%         trainsetf = ['..\datasets\5-fold\', name, '-5-fold\', name, '-5-', int2str(kk), 'tra.dat'];
%         testsetf = ['..\datasets\5-fold\', name, '-5-fold\', name, '-5-', int2str(kk), 'tst.dat'];
%         %trainsetf=['dataset\',name,'\',int2str(aa),'n',int2str(kk),'f','tr.txt'];% read the data set,in this line,we read the kk-th flod training set in aa-th dataset
%         %testsetf=['dataset\',name,'\',int2str(aa),'n',int2str(kk),'f','te.txt'];% read the data set,in this line,we read the kk-th flod test set in aa-th dataset
%         disp(trainsetf);
%         trainset = importdata(trainsetf, ',');
%         testset = importdata(testsetf, ',');
        trainset = dataset_tr;
        testset = dataset_te;
        testlabal = testset(:, end);
        testset(:, end) = [];
        [tsize, m] = size(trainset);
        distance = pdist2(trainset(:, 1:end-1), trainset(:, 1:end-1));
        distance(logical(eye(size(distance)))) = inf;
        kdd = exishou(trainset, distance, ones(1, tsize), tsize);
        population = zeros(n, tsize);
        setcode = ones(n, tsize);
        % for k=1:n
        %     d=normrnd(0,0.3);
        %     for j=1:tsize
        %
        %             if rand()<0.5*abs(d)
        %                 population(k,j)=1;
        %             else
        %                 population(k,j)=0;
        %             end
        %      end
        %
        % end
        %
        %      [functionvalue1,~]=qifaeva(population,trainset);
        %      [FrontNo,~] = F_NDSort(functionvalue1);                             %非支配排序
        %
        %      CrowdDis = CrowdingDistance(functionvalue1,FrontNo);
        functionvalue1 = zeros(n, 2);
        FrontNo = ones(1, n);
        CrowdDis = ones(1, n);

        functionvalue1(:, 1) = 0;
        functionvalue1(:, 2) = 1;


        for tt = 1:Gmax %------------------------------------------------------------------------------------start
%             disp(tt);
            newpopulation = zeros(n, tsize); %子代种群
            newsetcode = zeros(n, tsize);
            MatingPool = TournamentSelection(2, 2*n, FrontNo(1, :), -CrowdDis(1,:));

            pm1 = 0.1;
            pm0 = 0.1;
            for i = 1:n/2                  %交叉产生子代
                p1 = MatingPool(i);
                p2 = MatingPool(n+i);
                newpopulation(i*2-1, :) = population(p1, :);
                newpopulation(i*2, :) = population(p2, :);

                newpopulation(i*2, setcode(p2, :) == 0) = 0;
                newpopulation(i*2-1, setcode(p1, :) == 0) = 0;
                r1 = rand(1, tsize)<1;
                ex1 = newpopulation(i*2-1, r1);
                ex2 = newpopulation(i*2, r1);
                newpopulation(i*2, r1) = ex1;
                newpopulation(i*2-1, r1) = ex2;

                l1 = newpopulation(i*2, :) == 1;
                l2 = newpopulation(i*2, :) == 0;
                r1 = rand(1, length(l1))<pm1;
                newpopulation(i*2, r1&l1) = 0;
                r1 = rand(1, length(l1))<pm0;
                newpopulation(i*2, r1&l2) = 1;


                l1 = newpopulation(i*2-1, :) == 1;
                l2 = newpopulation(i*2-1, :) == 0;
                r1 = rand(1, length(l1))<pm1;
                newpopulation(i*2-1, r1&l1) = 0;
                r1 = rand(1, length(l1))<pm0;
                newpopulation(i*2, r1&l2) = 1;

                newsetcode(i*2-1, :) = setcode(p1, :);
                newsetcode(i*2, :) = setcode(p2, :);


            end
            p1 = newpopulation&newsetcode;
            [functionvalue2, ~] = qifaeva(p1, trainset);
            newpopulationl = [population; newpopulation]; %合并父子种群
                    functionvalue = [functionvalue1; functionvalue2];

                    [FrontNo1, MaxFNo] = F_NDSort(functionvalue); %非支配排序
                    Next = FrontNo1 < MaxFNo;
                                    CrowdDis1 = CrowdingDistance(functionvalue, FrontNo1);
                                    Last = find(FrontNo1 == MaxFNo);
                                    [~, Rank] = sort(CrowdDis1(Last), 'descend');
                                    Next(Last(Rank(1:n-sum(Next)))) = true;
                                    Next = Next';
                                    population = newpopulationl(Next, :);
                                    setcode1 = [setcode; newsetcode];
                                    setcode = setcode1(Next, :);
                                    functionvalue1 = functionvalue(Next, :);
                                    CrowdDis(1, :) = CrowdDis1(Next');
                                    FrontNo(1, :) = FrontNo1(Next');

                                    %----------------------------------------------------------------------
                                    if size(find(rr == tt), 1) ~= 0 %reduce
                                        p = population&setcode;

                                        tongji = zeros(tsize, 1); %统计
                                        for k = 1:tsize
                                            tongji(k, 1) = sum(p(:, k))/n;
                                        end
                                        %kdd=exishou(trainset,distance,setcode(i,:),tsize);
                                        a = 0.5;
                                        kdd1 = zeros(1, tsize);
                                        for j = 1:tsize

                                            kdd1(j) = (1-a)*kdd(j)+a*(tongji(j, 1));
                                            %kdd1(j)=kdd(j)*tongji(j,1);

                                        end
                                        s = kdd1;
                                        [~, p] = sort(functionvalue1(:, 1), 'descend');

                                        for i = 1:n

                                            dr = unifrnd (0, 1)*(i/n-1/n);

                                            %                 dr=0.5;
                                            l = sum(setcode(p(i), :));

                                            for del = 1:floor(l*0.5) %删点
                                                rs = randperm(sum(setcode(p(i), :)));
                                                dele = find(setcode(p(i), :));
                                                dele1 = dele(rs(1));
                                                dele2 = dele(rs(2));
                                                if s(dele1)>s(dele2)
                                                    setcode(p(i), dele2) = 0;
                                                else
                                                    setcode(p(i), dele1) = 0;
                                                end
                                            end
                                            populationeva = population(p(i), :)&setcode(p(i), :);
                                            %                 pp=functionvalue1(p(i+n/2),:)
                                            [functionvalue1(p(i), :), ~] = qifaeva(populationeva, trainset);
                                            %                 pp=functionvalue1(p(i+n/2),:)
                                        end

                                    end
                                    %----------------------------------------------------------------------
                                    if size(find(rr1 == tt), 1) ~= 0 %repair

                                        p = accselection(functionvalue1(:, 1));
                                        for i = 1:n/2
                                            p1 = p(i);
                                            p2 = p(i+n/2);

                                            for j = 1:tsize
                                                if setcode(p2, j) == 0 && setcode(p1, j) == 1
                                                    setcode(p2, j) = 1;
                                                    population(p2, j) = 0;

                                                end
                                            end
                                        end

                                    end
                                    %----------------------------------------------------------------------
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          popconverge{dulix, kk, tt} = functionvalue1;
        Last = functionvalue1;
        index = ones(1, n);
        for i = 1:n
            individual = population(i, :);
            class = unique(dataset_tr(:,end));
            class_s = unique(dataset_tr((logical(individual)),end));
            if length(class) ~= length(class_s)
                index(i) = 0;

            end
        end
        index = logical(index);
%         Last = 1-Last;
        clf;
%         plot(Last(index, 1), Last(index, 2), 'o');
%         hold on;
%         plot(Last(FrontNo == 1, 1), Last(FrontNo == 1, 2), 'o');
%                     axis([0 1 0 1]);
%         hold on;
%         plot(Last(~index, 1), Last(~index, 2), '.');
%         set(get(gca, 'XLabel'), 'String', int2str(tt));
%         drawnow;
        end
        poptrain{dulix, kk} = functionvalue1; %.*(FrontNo(1,:)'==1);
        poprank{dulix, kk} = FrontNo(1, :);
        ptest = zeros(n, 2);
        onefold_gm = zeros(1, n);
        for ii = 1 : n
            [~, model] = qifaeva(population(ii, :), trainset);
            [predict_label, acc, ~] = svmpredict(testlabal, sparse(testset), model{1}, '-q');
            [onefold_gm(ii),temp] = calGM(label_class,label_te,predict_label);
            ptest(ii, 1) = acc(1)/100;
            ptest(ii, 2) = functionvalue1(ii, 2);
        end
%         [max_test, max_index] = max((0.9*Last(:,1)).*(0.1*Last(:, 2)).*(FrontNo==1)');
        [max_test, max_index] = max(Last(:,1));
        time = toc;
        poptest{dulix, kk} = ptest;
        Test = ptest;
        TR((kk-1)*100+1:kk*100, :) = Last;
        TE((kk-1)*100+1:kk*100) = Test(:,1);
        PF((kk-1)*100+1:kk*100) = FrontNo;
        TIME(kk) = time;
        MAX_TR(kk, :) = Last(max_index, :);
        MAX_TE(kk) = Test(max_index,1);
        GM((kk-1)*100+1:kk*100) = onefold_gm;
        MAX_GM(kk) = onefold_gm(max_index);
        MAX_HV(kk) = NHV(1-Last,[1,1]);
        index = (FrontNo == 1);
        PF_size = sum(index);
        avg_TE(kk) = sum(Test(index,1))/PF_size;
        avg_TR(kk, :) = sum(Last(index,:))/PF_size;
        avg_GM(kk) = sum(onefold_gm(index))/PF_size;
        Test1 = Test(index,:);
%        Test1 = Test1(onefold_gm(index)>0,:);
        test_HV(kk) = NHV(1-Test1,[1, 1]);
        Test_Red(kk) = max(Test(index, 1) .* Last(index, 2));
%         mkdir(['..\PF\LRIS\' num2str(d)]);
        GM_values = onefold_gm';
        ACI(kk) = avg_TE(kk) * Test_Red(kk);
%         save(['..\PF\LRIS\' num2str(d) '\' num2str(kk) '.mat'], "Test", "Last", "GM_values");
    end

%     toc
%     time{dulix} = toc;
%     A = TR(PF == 1, :);
%     B = TE(PF == 1);
%     [A, index] = unique(A, "rows");
%     B = B(index);
%     f = size(B, 2);                       
%     fprintf("平均时间：%f\n", sum(TIME)/t);
%     disp("选择前沿面");
%     disp("训练集：")
%     disp(sum(A)/f);
%     fprintf("测试集：%f\n", sum(B)/f);

    result(dulix,1) = sum(MAX_GM)/t;
    result(dulix,2) = sum(MAX_TE)/t;
    result(dulix,3) = sum(MAX_TR(:,2))/t;
    result(dulix,4) = sum(MAX_HV)/t;
    result(dulix,5) = sum(Test_Red)/t;

    result2(dulix,1) = sum(avg_GM)/t;
    result2(dulix,2) = sum(avg_TE)/t;
    result2(dulix,3) = sum(avg_TR(:,2))/t;
    result2(dulix,4) = sum(test_HV)/t;
    result2(dulix,5) = sum(TIME)/t;
    result2(dulix,6) = mean(ACI);
    
    standard_error(dulix,1) = std(avg_TE);
    standard_error(dulix,2) = std(Test_Red);
    standard_error(dulix,3) = std(test_HV);

        datasetName = ['Dataset' num2str(d)]; 
        saveFileName = [ 'LRIS_' datasetName '.mat'];
        save(saveFileName);
end
disp(sum(result2)/duli);
% for i = 1 : 60
%     sound(sin(2*pi*25*(1:4000)/100));
%     pause(2);
% end

% figure;
% mappedX = tsne(inst_tr, "Distance", "euclidean");
% gscatter(mappedX(:, 1), mappedX(:, 2), label_tr);
% 
% individual = logical(population(max_index, :));
% figure;
% gscatter(mappedX(individual, 1), mappedX(individual, 2), label_tr(individual));

% end

% save the results, popconverge is the populations in each iteration ,poptest is the final popolation funcation values on test set
%poptrain  is the final popolation funcation values on traning set

% disp((sum(poptrain{1,1}(:,1))+sum(poptrain{1,2}(:,1))+sum(poptrain{1,3}(:,1))+sum(poptrain{1,4}(:,1))+sum(poptrain{1,5}(:,1)))/500);
% disp((sum(poptrain{1,1}(:,2))+sum(poptrain{1,2}(:,2))+sum(poptrain{1,3}(:,2))+sum(poptrain{1,4}(:,2))+sum(poptrain{1,5}(:,2)))/500);
% functionvalue1=unique(functionvalue1,'rows');

