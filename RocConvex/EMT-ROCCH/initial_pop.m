function population = initial_pop(popnum,poplength)
%INITIAL_POP 此处显示有关此函数的摘要
%   此处显示详细说明
        minvalue = repmat(ones(1,poplength),popnum,1)*(-1);
        maxvalue = repmat(ones(1,poplength),popnum,1);
        population = rand(popnum,poplength).*(maxvalue-minvalue) + minvalue;
end

