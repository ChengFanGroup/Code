function [NewChrom] = CXoperate(parent_chromosome,px,pm,chromosome_f,g1,g2,g3)
%CXOPERATE 此处显示有关此函数的摘要
%   此处显示详细说明

CXcode = 1;

switch CXcode
    case 0
        NewChrom = uniformX(parent_chromosome,px,pm); % 旧版本交叉变异

    case 1
        NewChrom = uniformX_new(parent_chromosome,px,pm,chromosome_f,g1,g2,g3);
        
    case 2
        NewChrom = xovmp( parent_chromosome, px, 2, 1 );
        NewChrom = mut(NewChrom, pm);
        
    otherwise
        error("参数错误");
            
end

