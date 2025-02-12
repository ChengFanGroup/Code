function y=datasetImport(gg)
%导入数据集
a='';
switch gg
    case 1
         a='cleveland.txt';
    case 2
         a='balance.txt';
    case 3
         a='flare.dat';
    case 4
        a='winequality-red.txt';
    case 5
        a='COLL20.txt';
    case 6
        a='morphological.arff';
    case 7
        a='semeion.txt';
    case 8
        a='banana.txt';
    case 9
        a='page-blocks.txt';
    case 10
        a='penbased.txt';
    case 11
        a='satimage.txt';
    case 12
        a='usps.mat';
    case 13
        a='letter.dat';
    case 14
        a='shuttle_seed_2_nrows_2000.txt';
    case 15
        a='cleveland.txt';
    case 16
        a='cardiotocography.txt';
    case 17
        a='usps.mat';
        case 18
        a='JapaneseVowels.mat';
    case 19
        a='Dry_Bean_Dataset.arff';
end
y=importdata(a);
disp(a);