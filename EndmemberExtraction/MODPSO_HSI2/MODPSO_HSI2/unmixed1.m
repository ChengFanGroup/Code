function [rmse1]=unmixed1(X,endmember)
Data=reshape(X,162,307,307);
 
duanyuan=endmember;

O=zeros(307,307,6);
for i=1:307
    for j=1:307
        abundance= lsqnonneg(duanyuan,Data(:,i,j));%非负矩阵分解
        for k=1:6
            %if(abundance(k)>=0)
            O(i,j,k) = abundance(k);
          %  else if(abundance<=0)
              %      O(i,j,k)=0;
             %   end
           % end
        end
    end
end
%归一化
nnfengdu=reshape(O,94249,6);
 total=sum(nnfengdu,2);
  for j=1:94249
     nnfengdu(j,:)=nnfengdu(j,:)./total(j,1); 
  end
%   fengdu_1=reshape(nnfengdu,307,307,6);
  %计算RMSE
  fengdu_1=nnfengdu';
  re_mixed = endmember*fengdu_1;
  residual_error =abs( X-re_mixed);


  rmse1 = sum(sqrt(sum(residual_error.^2)/162))/94249;

end