%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Probleme
%
%       Selectionne problem
%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = Probleme(idProbleme,x)

switch idProbleme
    case 1
        f = PnClassifier(x); 
    case 2
        f = PuClassifier(x);
    case 3
        f = PnClassifierFS(x);
    case 4
        f = PnClassifierAUCFS(x);
    case 5
        f = PuClassifierAUCFS(x);
    case 6
        f = PuClassifierAUCRP(x);
    case 7
        f = PuClassifierRP(x);
    case 8
        f = PuClassifierTPRFPR(x);
    case 9
        f = MaskEvalution(x);
    case 10
        f = DoubPopEvalution(x);
    case 11
        f = MaskEvalutionPU(x);
    case 12
        f = IndexCluster(x);
    case 13 
        f = CostSensitivePU(x);
    case 14
        f = CostSensitiveFS(x);
        
end