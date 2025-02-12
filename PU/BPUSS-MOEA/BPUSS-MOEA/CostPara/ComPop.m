function [P] = ComPop(P)
  load('FeatSub');
  value=[P.Val]'; 
  [Pnum,Dom]=size(value);
  for i=1:Pnum
      if rand(1)*3<=1
          new1(:,FeatSub1>0.5)=1;
          new1(:,FeatSub1<=0.5)=0;
          NewVal=new1.*value(i,1:(Dom-1));
      elseif  rand(1)*3<=2
          new2(:,FeatSub2>0.5)=1;
          new2(:,FeatSub2<=0.5)=0;
          NewVal=new2.*value(i,1:(Dom-1));
      elseif  rand(1)*3<=3
          new3(:,FeatSub3>0.5)=1;
          new3(:,FeatSub3<=0.5)=0;
          NewVal=new3.*value(i,1:(Dom-1));
      end
      P(i).Val=[NewVal,value(i,end)]';
  end
  
end

