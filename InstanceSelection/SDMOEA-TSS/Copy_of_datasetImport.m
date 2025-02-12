function y=datasetImport(gg)
%导入数据集
switch gg
    case 1
         y=importdata('led7digit.txt');
    case 2
         y=importdata('dermatology.txt');
    case 3
         y=importdata('ecoli.txt');
    case 4
         y=importdata('glass.txt');
    case 5
        y=importdata('vehicle.dat');
    case 6
        y=importdata('wine.txt');
    case 7
        y=importdata('cleveland.txt');
    case 8
        y=importdata('segmentimb.txt');
    case 9
        y=importdata('winequality-red.txt');
    case 10
        y=importdata('winequality-white.txt');
    case 11
        y=importdata('yeast.txt');
    case 12
        y=importdata('satimage.txt');
    case 13
        y=importdata('splice.dat');
    case 14
        y=importdata('texture.dat');
    case 15
        y=importdata('COLL20.txt');
    case 16
        y=importdata('winequality-red.txt');
end
        
        
        