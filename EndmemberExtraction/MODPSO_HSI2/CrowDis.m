function [P_,fit_,cd_] = CrowDis(P,fit,Fnum) 
%   The function CrowDis is used for calculating crowding distance 

global  D M 

popSize = size(P,1);     
Fmax = max(Fnum);        
  
previous_index = 1;
for i = 1:Fmax
   
    for k = previous_index:popSize       
        if Fnum(k,:) ~= i
            break;
        end
    end

    if ( k==popSize ) & ( Fnum(k,:)==i )   
        current_index = k;
    else
        current_index = k-1;
    end
 
    clear pop1  crowdis  cd1
    pop1(1:current_index-previous_index+1,:) = P(previous_index:current_index,:);
    fit1(1:current_index-previous_index+1,:) = fit(previous_index:current_index,:);

        
    for j=1:M   
        len = size(pop1,1);
        obj = []; index = [];
        for k=1:len
            obj(k) = fit1(k,j); 
        end
        
        Vmax = max(obj); Vmin = min(obj);
        [sortObj,sortIndex]=sort(obj);  
           
        crowdis(sortIndex(1),j) = inf ;    
        crowdis(sortIndex(len),j) = inf;
        for k=2:len-1
            crowdis(sortIndex(k),j) = (sortObj(k+1)-sortObj(k-1)) / (Vmax-Vmin);
        end
        
    end
 
    for k = 1:size(pop1,1) 
             cd1(k,:) = sum(crowdis(k,:));         
     end
    
    [~,sortIndex]=sort(cd1,'descend');  
    for k = 1:size(pop1,1) 
        PNew(k,:) = pop1(sortIndex(k),:);
        fitNew(k,:) = fit1(sortIndex(k),:);
        cdNew(k,:) = cd1(sortIndex(k),:);
    end
    
    P_(previous_index:current_index,:) = PNew(1:current_index-previous_index+1,:);   
    fit_(previous_index:current_index,:) = fitNew(1:current_index-previous_index+1,:);    
    cd_(previous_index:current_index,:) = cdNew(1:current_index-previous_index+1,:);   

     
    previous_index=current_index+1;
  
end


