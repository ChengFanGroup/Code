function y=NB(gg)

switch gg
    case 1
         y=importdata('australian.txt');
         y(y(:,end)==0,end)=-1;
    case 2
         y=importdata('bands.txt');
    case 3
         y=importdata('bupa.txt');
          y(y(:,end)==2,end)=-1;
    case 4
        y=importdata('haberman.txt');
    case 5
        y=importdata('heart.txt');
         y(y(:,end)==2,end)=-1;
    case 6
        y=importdata('monk-2.txt');
        y(y(:,end)==0,end)=-1;
    case 7
        y=importdata('mammogra.txt');
        y(y(:,end)==0,end)=-1;
    case 8
        y=importdata('pima.txt');
    case 9
        y=importdata('sonar.txt');
    case 10
        y=importdata('wdbc.txt');
    case 11
        y=importdata('wisconsin.txt');
         y(y(:,end)==2,end)=-1;
         y(y(:,end)==4,end)=1;
    case 12
          y=importdata('geman.txt');
    case 13
          y=importdata('phoneme.txt');
    case 14
          y=importdata('ecoli.txt');
    case 15
         y=importdata('cleveland.txt');
         y(y(:,end)==0,end)=5;
    case 16
          y=importdata('zoo.txt'); 
    case 17
        y=importdata('vehicle.txt');
    case 18
        y=importdata('glass.dat');
    case 19
        y=importdata('led7digit.dat');
    case 20
        y=importdata('vowel.dat');
    case 21
        y=importdata('winequality-white.txt');
          
end
        
        
        