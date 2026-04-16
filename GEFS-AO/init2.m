function [population] = init2(nodelength,popSize,Vmin,Vmax)
%INIT 此处显示有关此函数的摘要
%   此处显示详细说明
   global trData trLabel teData teLabel;
   global  featNum kNeigh;
    population.threshold = 0.6;
    
    population.maxRenewExemplar = 5;
    
    population.lambda = 0.8;
    population.pc = zeros(1,popSize);
    population.exemReNewCount = zeros(1,popSize);
    
    population.popSize =  100;
    population.fitness = zeros(population.popSize,1);
    
    population.particle{population.popSize} = {};
    
    
    population.renewExemplar = false(1,population.popSize);
    population.gBest.pos = []; 
    population.gBest.fitness = 0; 
    population.gBest.er=[];
    population.gBest.fm=[];
    population.gBest.featsub = zeros(1,featNum);
    population.gBest.notChange = 0;
    for j = 1:population.popSize
        
            population.particle{j}.position = rand(1,nodelength);     
            population.particle{j}.velocity = Vmin + rand(1,nodelength)*(Vmax-Vmin);
            population.particle{j}.er = [];
            population.particle{j}.fm = [];
            population.particle{j}.featsub = zeros(1,featNum);
            population.particle{j}.exemplar = zeros(1,nodelength);
            population.particle{j}.pBest.pos = population.particle{j}.position; 
            population.particle{j}.pBest.fitness = 0;
            population.particle{j}.pBest.er =[];
            population.particle{j}.pBest.fm =[];
            population.particle{j}.pBest.featsub = zeros(1,featNum);
            population.particle{j}.fitness = 0;
            population.particle{j}.pBestNotImprove = 0; 
        
    end
end

