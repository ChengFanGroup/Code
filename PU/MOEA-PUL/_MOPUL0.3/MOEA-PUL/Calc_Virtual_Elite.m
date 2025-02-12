% 
% Created by Shenzhi Yuan, BIMK, 2019
%
% Parameters:
%               Population:        Current Population
%               FunctionValue:     Two aims of population
%               Generation:        Current generation number
%               StartGene:         Elite Strategy Start Generation
% Outputs:
%               VirtualElite:      Current virtual elite
%               VirtualEliteSet:   Full virtual elite set
% Use:
%               calculate the virtual elite

function [VirtualElite,VirtualEliteSet] = Calc_Virtual_Elite(Population,FunctionValue,Generation,StartGene)

if(Generation >= StartGene && mod (Generation,10) == 0)
    % Find virtual elite set
    FrontNo = F_NDSort(FunctionValue,'first');
    Dominated = FrontNo == 1;
    VirtualEliteSet  = Population(Dominated,:);
    
    % if all virtual elite individual believe one position should be 1 or 0
    % then virtual elite's this position be 1 or 0, otherwise be -1
    N = size(VirtualEliteSet,1);
    VirtualElite = sum(VirtualEliteSet,1);
    VirtualElite(VirtualElite ~= 0 & VirtualElite ~= N) = -1;
    VirtualElite(VirtualElite == N) = 1;
else
    VirtualElite = nan;
    VirtualEliteSet = nan;
    
end