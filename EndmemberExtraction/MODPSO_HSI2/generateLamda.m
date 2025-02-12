function lamdaM = generateLamda(N,M) 
% 产生N个权重向量 
% lamdaM 为 N*M矩阵

    array = (0:N)/N;
    for i= 1:N+1
    	lamdaM(i,1)=array(i);
        lamdaM(i,2)=1-array(i);
    end
    len = size(lamdaM,1);
    index = randperm(len);
    index = sort(index(1:N));
    lamdaM = lamdaM(index,:);   
end
