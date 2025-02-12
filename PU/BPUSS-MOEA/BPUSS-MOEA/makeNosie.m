function [Train_Dataset,Train_Label] = makeNosie(data,label)

      
      beta=0.10;
      posdata=data(label==1,:);
      nagdata=data(label==-1,:);
      
      Pos_num=size(posdata,1);
      Neg_num=size(nagdata,1);
      
      poslabel=label(label==-1);
      nealabel=label(label==-1);
      
      
      NoiseNum=round(beta*Neg_num);
      NoiseInd=randperm(Neg_num,ceil(NoiseNum));
      NoisePdata=nagdata(NoiseInd,:);
      
      posdata=[NoisePdata;posdata];
      poslabel=ones(NoiseNum+Pos_num,1);
      
      nagdata(NoiseInd,:)=[];
      neglabel=zeros(Neg_num-NoiseNum,1);
      
      neglabel(neglabel==0)=-1;
      
      Train_Dataset=[posdata;nagdata];
      Train_Label=[poslabel;neglabel];
      
      
      
      
      

     

end

