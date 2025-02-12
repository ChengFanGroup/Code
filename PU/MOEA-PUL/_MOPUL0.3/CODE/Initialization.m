% 
% Created by Guanglong Fu, BIMK, 2019
%
% Parameters:
%               dataPos:    Positive data
%               dataUN:     Unlabeled data
%               pop_size:   The number of individuals in population
% Outputs:
%               population: the initialized population
% Use:
%               Intialize population by distance-based initialization
%               stategy.


function population = Initialization(dataPos,dataUN,pop_size)
      %------------------------Distance Matrix----------------------------%
      fullData = [dataPos,dataUN];
      fullData = fullData';
      DistMat =pdist(fullData);
      DistMat = squareform(DistMat);
      %-----------------Calculate the distance from U to P----------------%
      
      Udis = zeros(size(dataUN,2),1);% each sum of Unlabeled data's distance to P  
      posNum = size(dataPos,2);
      for i = 1:size(dataUN,2)
          Udis(i) = sum(DistMat(posNum+i,1:posNum));
      end
%       disp(Udis);
      init  = zeros(pop_size,size(dataUN,2));%make population zero-matrix
      
      % Do sampling with replacement, k is the times one individual should
      % be compared, k <= individual length / 2
      k    = randi(floor(size(dataUN,2)/2),1,pop_size);
      
      % randomly Select k(i) times two unlabeled data's distance to campare,
      % choose the smaller one as 1
      for i = 1:pop_size
          for j = 1:k(i)
                k1 = randi(size(dataUN,2),1,2);
                if (Udis(k1(1))<=Udis(k1(2)))
                    init(i,k1(1)) = 1;
                else
                    init(i,k1(2)) = 1;
                end
          end
      end
      population = init;
end






