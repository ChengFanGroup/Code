function [acc1,acc2,featsize1,hv] =  newEA(g1,g2,g3, pop, times)
%   此处提供详细说明
    global trData trLabel teData teLabel;
    global  featNum ;
    global Zout Zout2 Zout3 ;
    
    global archievepop1;

    [chromes,chromeend] =nsga_2_mating_strategy(pop,times,g1,g2,g3); % 前沿面
    
%     itidx = find(chromes(:,end-1) ==1) ;
%     frontchrome = abs(chromes(itidx,1:featNum+2));

    itidx = find(chromeend(:,end-1) ==1) ;
    frontchrome = abs(chromeend(itidx,1:featNum+2));


    [num,featlength] = size(frontchrome);
    for i = 1:num
        featidx = frontchrome(i,1:featNum);
        feat = find(featidx~=0);
        featnum = sum(featidx~=0);
        predLabel=testKNN(trData(:,feat), trLabel,teData(:,feat),5);
        acc = 1-sum(predLabel==teLabel)/length(teLabel);
        frontchrome(i,end-1)=acc;
        frontchrome(i,end)=featnum;
        
    end
    

    fits1 = 0.9.*abs(frontchrome(:,end-1))+...
        0.1.*(frontchrome(:,end)./featNum);
    selected1 = find(fits1==min(fits1));
    idx1 = selected1(1,:);
    acc1 = frontchrome(idx1,end-1);
    acc2 = frontchrome(idx1,end-1);

    featsize1 = frontchrome(idx1,end);
    PF = frontchrome(:,end-1:end);
    PF(:,end) = PF(:,end)./featNum;
    hv = HV_1(PF);
end