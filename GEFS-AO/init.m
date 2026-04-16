function [swarm] = init(nodelength,popSize,Vmin,Vmax)
%INIT 此处显示有关此函数的摘要
%   此处显示详细说明
   global trData trLabel teData teLabel;
   global  featNum kNeigh;
    swarm.threshold = 0.6;
    
    swarm.maxRenewExemplar = 5;
    
    swarm.lambda = 0.9;
    swarm.pc = zeros(1,popSize);
    swarm.exemReNewCount = zeros(1,popSize);
    
    swarm.popSize =  100;
    swarm.fitness = zeros(swarm.popSize,1);
    
    swarm.particle{swarm.popSize} = {};
    
    
    swarm.renewExemplar = false(1,swarm.popSize);
    swarm.gBest.pos = []; 
    swarm.gBest.fitness = 0; 
    swarm.gBest.er=[];
    swarm.gBest.fm=[];
    swarm.gBest.featsub = zeros(1,featNum);
    swarm.gBest.notChange = 0;
    for j = 1:swarm.popSize
        
            swarm.particle{j}.position = rand(1,nodelength);     
            swarm.particle{j}.velocity = Vmin + rand(1,nodelength)*(Vmax-Vmin);
            swarm.particle{j}.er = [];
            swarm.particle{j}.fm = [];
            swarm.particle{j}.featsub = zeros(1,featNum);
            swarm.particle{j}.exemplar = zeros(1,nodelength);
            swarm.particle{j}.pBest.pos = swarm.particle{j}.position; 
            swarm.particle{j}.pBest.fitness = 0;
            swarm.particle{j}.pBest.er =[];
            swarm.particle{j}.pBest.fm =[];
            swarm.particle{j}.pBest.featsub = zeros(1,featNum);
            swarm.particle{j}.fitness = 0;
            swarm.particle{j}.pBestNotImprove = 0; 
        
    end
end

