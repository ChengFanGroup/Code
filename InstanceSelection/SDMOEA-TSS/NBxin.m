function y=NBxin(gg)
switch gg
    case 1
         y=importdata('australian.txt');
         y(y(:,end)==0,end)=-1;
    case 2
         y=importdata('bands.txt');
    case 3
        y=importdata('haberman.txt');
    case 4
        y=importdata('heart.txt');
         y(y(:,end)==2,end)=-1;
    case 5
        y=importdata('mammogra.txt');
        y(y(:,end)==0,end)=-1;
    case 6
        y=importdata('pima.txt');
    case 7
        y=importdata('sonar.txt');
    case 8
        y=importdata('wdbc.txt');
    case 9
        y=importdata('wisconsin.txt');
         y(y(:,end)==2,end)=-1;
         y(y(:,end)==4,end)=1;
    case 10
         y=importdata('cleveland.txt');
         y(y(:,end)==0,end)=5;
    case 11
          y=importdata('spectfheart.txt');
          y(y(:,end)==0,end)=-1;
    case 12
         y=importdata('saheart.txt');
    case 13
          y=importdata('geman.txt');
    case 14
          y=importdata('phoneme.txt');
    case 15
         y=importdata('vowel.txt');
         y(y(:,end)==0,end)=11;
    case 16     
         y=importdata('newthyroid.txt');
    case 17 
         y=importdata('movement_libras.txt');
     
end