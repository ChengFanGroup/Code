function y=datasetImport(gg)
%�������ݼ�
switch gg
    case 1
         y=importdata('dataset/wine.dat');
    case 2
         y=importdata('dataset/led7digit.txt');
    case 3
         y=importdata('dataset/vowel.dat');
    case 4
        y=importdata('dataset/contraceptive.txt');
    case 5
        y=importdata('dataset/car.dat');
    case 6
        y=importdata('dataset/splice.dat');
    case 7
        y=importdata('dataset/texture.dat');
    case 8
        y=importdata('dataset/satimage.dat');
    case 9
        y=importdata('dataset/thyroid.dat');
    case 10
        y=importdata('dataset\penbased.dat');
    case 11
        y=importdata('dataset\nursery.dat');
    case 12
        y=importdata("dataset\letter.dat");
    case 13
        y = importdata("dataset\vehicle.dat");
    case 14
        y = importdata("dataset\dermatology.txt");
end
        
        
        