% D = ["colon","lung","Leukemia1","DLBCL", "Brain1", "Prostate_GE","Leukemia","Leukemia2","Brain2","Leukemia3","11Tumor","Lung_Cancer",...
%   "ORL","SRBCT","lymphoma","GLIOMA","9Tumor","Carcinom","Prostate","CLL_SUB_111","SMK_CAN_187"];
% D = ["SRBCT","colon","Lung","GLIOMA", "Brain1", "Leukemia","Brain2","DLBCL","Leukemia1","Leukemia3","Lung_Cancer","11Tumor"];
D = ["wine"];
runtimes = 1;
DAEA = zeros(length(D), 6);
for a = 1:length(D)
dataset = D(a);

time_DAEA = zeros(runtimes, 1);
e1 = zeros(runtimes, 1);
e1_tr = zeros(runtimes, 1);
s1 = zeros(runtimes, 1);

for h = 1:runtimes
disp(['K Fold ' , int2str(h)]);
%% DAEA
t1 = clock;
[Dpop, Dobj, traindata, trainlabel, testdata, testlabel] = DAEA_test(dataset);
t2 = clock;
time_DAEA(h) = etime(t2,t1);

[PF, ~] = nondominated_sort(Dobj, size(Dobj,1));
Dpop = Dpop(PF == 1,:);
Dobj = Dobj(PF == 1,:);

[e1_tr(h),testIDX] = min(Dobj(:,2));

t = zeros(size(Dobj,1),1);
for i = 1:size(Dobj,1)
    t(i) = testAcc(traindata,trainlabel,testdata,testlabel,logical(Dpop(i,:)));
end
[e1(h),loc] = max(t);
s1(h) = sum(Dpop(loc,:));

tobj = [Dobj(:,1),1 - t];

end

end


