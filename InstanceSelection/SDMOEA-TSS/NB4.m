function y=NB4(gg)

switch gg
    case 1
         y=importdata('saheart.txt');
    case 2
         y=importdata('wine.txt');
    case 3
         y=importdata('cleveland.txt');
         y(y(:,end)==0,end)=5;
    case 4
        y=importdata('yeast.txt');
    case 5
        y=importdata('ecoli.txt');
    case 6
        y=importdata('ionosphere.txt');
        y(y(:,end)==2,end)=-1;
    case 7
        y=importdata('geman.txt');
        y(y(:,end)==0,end)=-1;
    case 8
        y=importdata('balance.txt');
    case 9
          y=importdata('spectfheart.txt');
          y(y(:,end)==0,end)=-1;
    case 10
          y=importdata('zoo.txt');   
    case 11
          y=importdata('led7digit.txt');
    case 12
          y=importdata('dermatology.txt');

end