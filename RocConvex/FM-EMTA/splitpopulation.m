function [Ured] = splitpopulation(Q)

% redundancy=[];%´¢´æÈßÓàµãµÄÐòºÅ
% for i=1:size(Q,1)
%     for j=i+1:size(Q,1)
%         if(Q(i,:)==Q(j,:))
%             redundancy = [redundancy j];
%         end
%     end
% end
% redundancy=unique(redundancy);
% Ured = setdiff(1:size(Q,1),redundancy);
[~, Ured,~] = unique(Q,'rows');

end