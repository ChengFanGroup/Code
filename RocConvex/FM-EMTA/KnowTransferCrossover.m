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
        
%         %ģ������ƽ���
%         Offspring = zeros(N,D);
%         for i = 1 : 2 : N
%             x1 = MatingPool((i+1)/2,:);
%             r = randi([1,size(guidingSolutions,1)]);%���������
%             x2 = guidingSolutions(r,:);
%             beta = zeros(1,D);
%             miu  = rand(1,D);
%             beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
%             beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
%             beta = beta.*(-1).^randi([0,1],1,D);
%             beta(rand(1,D)>ProC) = 1;
%             Offspring(i,:)   = (x1 + x2)/2+beta.*(x1 - x2)/2;
%             Offspring(i+1,:) = (x1 + x2)/2-beta.*(x1 - x2)/2;
%         end

        %����ʽ����
        MaxValue = repmat(Boundary(1,:),N,1);
        MinValue = repmat(Boundary(2,:),N,1);
%         k    = rand(N,D);
%         miu  = rand(N,D);
%         Temp = k<=ProM & miu<0.5;
%         Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
%         Temp = k<=ProM & miu>=0.5; 
%         Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));

        %Խ�紦��
        Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
        Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
            
            
end