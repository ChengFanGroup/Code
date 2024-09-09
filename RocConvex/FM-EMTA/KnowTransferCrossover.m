function Offspring = KnowTransferCrossover(MatingPool,guidingSolutions,Boundary,MaxOffspring,Index_F)
% 
% ����: MatingPool,   �����, ����ÿ��i���͵�i+1�����彻����������Ӵ�, iΪ����
%       Boundary,     ���߿ռ�, ���һ��Ϊ�ռ���ÿά���Ͻ�, �ڶ���Ϊ�½�
%       Coding,       ���뷽ʽ, ��ͬ�ı��뷽ʽ���ò�ͬ�Ľ�����췽��
%       MaxOffspring, ���ص��Ӵ���Ŀ, ��ȱʡ�򷵻����в������Ӵ�, ���ͽ���صĴ�С��ͬ
% ���: Offspring, �������Ӵ�����Ⱥ
    
        N = MaxOffspring;
        D = size(MatingPool,2);
        %ʵֵ���桢����
        %�Ŵ���������
        Index_C = find(Index_F==1);

        %ģ������ƽ���-ÿ�ν�������һ����
        Offspring = zeros(N,D);
        for i = 1 : N
            Index_k = Index_C(randi([1,length(Index_C)],1,1));
            Offspring(i,:) = MatingPool(i,:);
            ProC = rand(1)*0.3 + 0.2;       %�������
            r = randi([1,size(guidingSolutions,1)]);%���������
            x2 = guidingSolutions(r,:);
            for j = Index_C
                if (j == Index_k || rand(1) < ProC)
                    Offspring(i,j)   = x2(1,j);
                end
            end
        end
        


        %����ʽ����
        MaxValue = repmat(Boundary(1,:),N,1);
        MinValue = repmat(Boundary(2,:),N,1);

        %Խ�紦��
        Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
        Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
            
            
end