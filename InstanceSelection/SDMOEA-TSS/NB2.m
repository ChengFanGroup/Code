function y=NB(gg)

switch gg
%     case 1
%          y=importdata('appendicitis.txt');
%          y(y(:,end)==0,end)=-1;
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
%     case 6
%         y=importdata('hepatitis.txt');
%         y(y(:,end)==2,end)=-1;
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
        y=importdata('balance.txt');
    case 14
         y=importdata('glass.txt');
    case 16
         y=importdata('vowel.txt');
         y(y(:,end)==0,end)=11;
    case 17
        y=importdata('wine.txt');
    case 18
        y=importdata('vehicle.txt');
    case 19
        y=importdata('dermatology.txt');
    case 20
        y=importdata('cleveland.txt');
        y(y(:,end)==0,end)=5;
    case 21
         y=importdata('zoo.txt'); 
    case 22
          y=importdata('banana.txt');
    case 23
          y=importdata('phoneme.txt');
          y(y(:,end)==0,end)=-1;
    case 24
          y=importdata('yeast.txt');
    case 25
          y=importdata('iris.txt');
    case 26
          y=importdata('tae.txt');
    case 27
          y=importdata('ecoli.txt');
    case 28
          y=importdata('hayes-roth.txt');
    case 29
          y=importdata('ionosphere.txt');
    case 30
          y=importdata('spectfheart.txt');
    case 31
          y=importdata('zoo.txt');     
     case 32
          y=importdata('wine.txt');
     case 33
          y=importdata('geman.txt');
          
end
        
        
        