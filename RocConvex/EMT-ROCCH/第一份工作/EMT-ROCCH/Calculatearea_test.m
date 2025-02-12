function [CH_solutions_test,sum] = Calculatearea_test(population,testdataset,whethertest)
    results = Cal_objV(population,testdataset,whethertest);
    CH_solutions_test = GetConvexHull(results);
    sum=Calculatearea(CH_solutions_test);
end