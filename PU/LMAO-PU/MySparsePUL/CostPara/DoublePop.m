function [G,F1]=DoublePop(i,G,F1, ll)
        load('Train');
        NVar=size(dataPositive,2);
        findclassifierPU([F1.Val]');
        [UserInput,GAParameters,ProblemParameters]=ParametersSetforMask(NVar);
        [G,F1]=NSGA2forMask(UserInput,ProblemParameters,GAParameters,i,G, ll);
end

