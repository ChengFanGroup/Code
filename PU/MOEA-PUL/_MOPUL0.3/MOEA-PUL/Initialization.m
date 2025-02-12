%PU Similarity Initialization 相似初始化
function population = Initialization(dataPos,dataUN,pop_size)
      fullData = [dataPos,dataUN];
      fullData = fullData';
      DistMat =pdist(fullData);
      DistMat = squareform(DistMat);
      %计算u到p的距离，第一步%
      
      Udis = zeros(size(dataUN,2),1);         % 每个未标记数据到P的距离之和  
      posNum = size(dataPos,2);
      for i = 1:size(dataUN,2)
          Udis(i) = sum(DistMat(posNum+i,1:posNum));
      end
      for i=1:size(dataUN,2)
          Udis(i)=Udis(i)/max(Udis);
      end
      init  = zeros(pop_size,size(dataUN,2));
      k    = randi(floor(size(dataUN,2)/2),1,pop_size);
     
      % 随机选择两个比较距离使其为1
      for i = 1:pop_size
          for j = 1:k(i)
                k1 = randi(size(dataUN,2),1,2);
                if (Udis(k1(1))<Udis(k1(2))) 
                    init(i,k1(1)) = 1;
                elseif(Udis(k1(1))>Udis(k1(2)))
                    init(i,k1(2)) = 1;
                    elseif(Udis(k1(1))==Udis(k1(2)))
                         if (rand()<0.5 ) 
                             init(i,k1(1)) = 1;
                         else
                            init(i,k1(2)) = 1;
                        end
                end
          end
      end
      population = init;
end