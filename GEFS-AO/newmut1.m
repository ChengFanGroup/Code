function [NewChrom] = newmut1(NewChrom,ipnewmut,g1,g2,g3)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
     [m,n] = size(NewChrom);
  for i =1 : length(ipnewmut)
      a = NewChrom(ipnewmut(i),:);
      randindx = randi(3);
      switch randindx
      case 1
        gg = g1;

      case 2
        gg = g2;
        
      case 3
        gg = g3;
        
      otherwise
        error("参数错误");
            
      end
      allf = [1:1:n];
      base = find(a >0);
      linju = [];
       if length(base) == 0 
          randinde1 = randi(n);
          a(1,randinde1) = 1;

       else
           for j = 1:length(base)
               b = find(gg(base(j),:)> 0 );
               linju =[linju b];
           end 
           linju = unique(linju);
           ai = union(base,linju);%%自己和邻居
           feilinju = setdiff(allf,ai);
           if length(feilinju)==0
              shan = randi(length(base));
              shang= randi(length(linju));
               
              a(1,base(shan)) = 0;
              a(1,linju(shang)) =1;
           else
               shan = randi(length(base));
               shang= randi(length(feilinju));
               a(1,base(shan)) = 0;
               a(1,feilinju(shang)) =1;
           end
       end
       NewChrom(ipnewmut(i),:) = a;


  end   
end