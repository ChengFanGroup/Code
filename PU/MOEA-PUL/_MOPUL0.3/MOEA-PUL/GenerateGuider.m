% 
% Created by Shenzhi Yuan, BIMK, 2019
%
% Parameters:
%               Offspring:         Current Offspring
%               FunctionValue:     Two aims of Offspring
%               VirtualElite:      The Elite to guide the offspring
% Outputs:
%               NewOffspring:      Offspring after guided
% Use:
%               use virtual elite to guide the population generate
function NewOffspring = GenerateGuider(Offspring,FunctionValue,VirtualElite)

N = size(Offspring,1);

% Do sampling with replacement, we randomly choose two individual to
% compare, let the worse one into update set.
k = randi(N,2,N/2);
UpdateIndex = zeros(1,size(k,2));
FrontNo = F_NDSort(FunctionValue,'all');
CrowdDistance   = F_distance(FunctionValue,FrontNo);

for i = 1:size(k,2)
    if(FrontNo(k(1,i)) > FrontNo(k(2,i)))
        UpdateIndex(i) = k(1,i);
    elseif (FrontNo(k(1,i)) < FrontNo(k(2,i)))
        UpdateIndex(i) = k(2,i);
    elseif (CrowdDistance(k(1,i)) < CrowdDistance(k(2,i)))
        UpdateIndex(i) = k(1,i);
    else
        UpdateIndex(i) = k(2,i);
    end
end

UpdateIndex = unique(UpdateIndex);
UpdateSet = Offspring(UpdateIndex,:);

for i = 1:size(UpdateSet,1)
    temp  = UpdateSet(i,:);
    temp(VirtualElite == 1) = 1;
    temp(VirtualElite == 0) = 0;
    UpdateSet(i,:) = temp;
end

Offspring(UpdateIndex,:) = UpdateSet;
NewOffspring = Offspring;



end

