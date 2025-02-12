function y=NB201912211(gg)
switch gg
    case 1
        y=importdata('tae.txt');%151   
    case 2
           y=importdata('hayes-roth.txt');%160
    case 3
        y=importdata('wine.txt');  %178
    case 4
        y=importdata('haberman.txt'); %306   
    case 5
        y=importdata('wdbc.txt'); %683
    case 6
           y=importdata('winequality-red.txt');%1599
    case 7
           y=importdata('titanic.txt');%2201
    case 8
           y=importdata('segment.txt');%2310               
    case 9
           y=importdata('winequality-white.txt');%4898

    case 10
        y=importdata('penbased.txt');
end