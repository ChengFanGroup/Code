function [index] = wheelSelection(score)
%WHEELSELECTION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
	data=score;           % ԭʼ��������
	a=data./sum(data);        % ��һ��
	b=cumsum(a);              % ��������
	select=find(b>=rand);     % �±�����
    index = select(1);
end

