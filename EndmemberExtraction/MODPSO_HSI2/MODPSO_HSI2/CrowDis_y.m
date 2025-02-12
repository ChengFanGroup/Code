function [P_,fit_,cd_] = CrowDis(P,fit,Fnum,X) 
%   The function CrowDis is used for calculating crowding distance 

global  D M 

popSize = size(P,1);     
Fmax = max(Fnum);        
cd1=zeros(1,popSize);  
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

        for z=1:popSize
            x_idx(z,:) = find(P(z,:)==1);
        end        
    for k = 1:size(pop1,1) 
            if cd1(k)==0
                temp0=0;
                for j=1:p-1
                    for t=j+1:p
                        temp=SAM(X(:,x_idx(k,j)),X(:,x_idx(k,t)));
                        if temp>temp0
                            temp0=temp;
                        end
                    end
                end
                cd1(k)=temp0;
            end           
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


