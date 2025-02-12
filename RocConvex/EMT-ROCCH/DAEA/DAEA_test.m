function [DAEA_pop, DAEA_obj,traindata, trainlabel, testdata, testlabel] = DAEA_test(dataset)
[traindata, trainlabel, testdata, testlabel] = data_process(dataset);
[DAEA_pop, DAEA_obj] = DAEA_main(traindata, trainlabel, dataset);
end