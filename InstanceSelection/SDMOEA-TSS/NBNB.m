function y=NBNB(gg)

switch gg
    case 1
        y=importdata('heart.txt');
         y(y(:,end)==2,end)=-1;
    case 2
         y=importdata('cleveland.txt');
         y(y(:,end)==0,end)=5;
    case 3
         y=importdata('bupa.txt');
         y(y(:,end)==2,end)=-1;     
    case 4
         y=importdata('bands.txt');
     case 5
         y=importdata('saheart.txt');
      case 6
         y=importdata('australian.txt');
         y(y(:,end)==0,end)=-1;     
    case 7
        y=importdata('pima.txt');
%     case 6
%         y=importdata('sonar.txt');
    case 8
          y=importdata('geman.txt'); 
    case 9
          y=importdata('yeast.txt');
    case 10
          y=importdata('phoneme.txt');
          y(y(:,end)==0,end)=-1;      
end