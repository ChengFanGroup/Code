function y=NB2019122(gg)
switch gg
    case 1
        y=importdata('tae.txt');%151   
    case 2
           y=importdata('hayes-roth.txt');%160
    case 3
        y=importdata('wine.txt');  %178
    case 4
        y=importdata('heart.txt'); %270
         y(y(:,end)==2,end)=-1;
    case 5
         y=importdata('cleveland.txt');%297
         y(y(:,end)==0,end)=5;     
    case 6
        y=importdata('haberman.txt'); %306
    case 7
         y=importdata('bupa.txt'); %345
         y(y(:,end)==2,end)=-1;     
    case 8
         y=importdata('bands.txt'); %365
    case 9
         y=importdata('saheart.txt'); %462
    case 10
        y=importdata('wdbc.txt');% 569     
    case 11
         y=importdata('australian.txt'); %690
         y(y(:,end)==0,end)=-1;     
    case 12
        y=importdata('pima.txt'); %768
    case 13
          y=importdata('geman.txt'); %1000
    case 14
          y=importdata('yeast.txt');  %1484
    case 15
           y=importdata('winequality-red.txt');%1599
    case 16
           y=importdata('titanic.txt');%2201
    case 17
           y=importdata('segment.txt');%2310       
    case 18
           y=importdata('winequality-white.txt');%4898
    case 19
          y=importdata('phoneme.txt'); %5404
          y(y(:,end)==0,end)=-1;                    
    case 20
        y=importdata('penbased.txt');      
     
end