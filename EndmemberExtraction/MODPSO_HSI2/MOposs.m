

clear
clc
%Input image输入图像数据
%load('D:\Data\Urban\Urban_162.mat')
% load('D:\Data\Urban\end6_groundTruth.mat')  真实图像，比较端元的时候使用
% reference = M; %reference of endmembers   端元的参考

load Urban_data.mat

X = Y./1000;  %2-dimensional input image  输入的2维图像 ?为什么除以1000

[L,n] = size(X); %N为像元数，L为波段数
row = 307;
col = 307;
image_3d = zeros(row,col,L);
for i = 1:L
    image_3d(:,:,i) = reshape(X(i,:),row,col);
end
k = 6;   % Number of endmembers   端元数量

%********************************************************************************************************************************************************%

    population=zeros(1,n);
    %popSize: record the number of solutions in the population.
    popSize=1;
    %fitness: record the two objective values of a solution.
    fitness=zeros(1,2);
    %the first objective is f; for the special solution 00...00 (i.e., it does not select any variable) and the solutions with the number of selected variables not smaller than 2*k, set its first objective value as inf.  
    fitness(1)=inf;
    %the second objective is the number of selected variables, i.e., the sum of all the bits.
    fitness(2)= sum(population); 

    %repeat to improve the population; the number of iterations is set as 2*e*k^2*n suggested by our theoretical analysis.
    T=500;
    for i=1:T
        %randomly select a solution from the population and mutate it to generate a new solution.
        offspring=abs(population(randi([1,popSize],1,1),:)-randsrc(1,n,[1,0; 1/n,1-1/n]));
        %compute the fitness of the new solution.
        offspringFit=zeros(1,2);
        offspringFit(2)= sum(offspring);        
        if offspringFit(2)==0 || offspringFit(2)>=2*k
            offspringFit(1)=inf;
        else
            offspringFit(1)=unmixed(X,X(:,offspring(1,:)==1),1);
        end

        %use the new solution to update the current population.            
        if sum((fitness(1:popSize,1)<offspringFit(1)).*(fitness(1:popSize,2)<=offspringFit(2)))+sum((fitness(1:popSize,1)<=offspringFit(1)).*(fitness(1:popSize,2)<offspringFit(2)))>0
            continue;
        else
            deleteIndex=((fitness(1:popSize,1)>=offspringFit(1)).*(fitness(1:popSize,2)>=offspringFit(2)))'; 
        end
        
        %ndelete: record the index of the solutions to be kept.
        ndelete=find(deleteIndex==0);
        population=[population(ndelete,:)',offspring']';
        fitness=[fitness(ndelete,:)',offspringFit']';
        fprintf('第%d代已完成\n',i);
        scatter(fitness(:,2),fitness(:,1));
        drawnow;
        popSize=length(ndelete)+1;
    end
    fitness
    %select the final solution according to the constraint k on the number of selected variables. 
    temp=find(fitness(:,2)<=k);
    j=max(fitness(temp,2));
    seq=find(fitness(:,2)==j);    
    selectedVariables=population(seq,:);

    
    

    
   % 匹配光谱矩阵
   % for i = 1:n
   %     endmember = X(:,GBA(i,:)==1);
   %     SAM = SAMpipei(reference,endmember);
   %     record_SAM = [record_SAM;SAM(1:3,:)];
   % end










