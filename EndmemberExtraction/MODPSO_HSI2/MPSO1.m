
    
    while iter < maxiter 
        iter = iter+1;    
       gbest = FindGlobalBest(GBA,f_GBA,pop,f_x);
        %5.update velocity and position更新速度和位置      
        %5.1 update velocity更新速度
        popc=mod(pop,col);
        popr=ceil(pop/col);
        off = pop;      
        for j =1:pop_num 
            index_1=ceil(rand*size(GBA,1));
            par = GBA(index_1,:);
            point1 = randi(p,1);
            parc=mod(par(:,point1),col);
            parr=ceil(par(:,point1)/col);
            minrand = n^2;
            for k1 = 1:p
                if(minrand>(popr(j,k1)-parr)^2+(popc(j,k1)-parc)^2)
                    minrand=(popr(j,k1)-parr)^2+(popc(j,k1)-parc)^2;
                    point2 = k1;
                end         
            end            
                %5.2 update position 更新粒子位置
            if rand < 0.7               
                off(j,point2) = par(:,point1);
            else
                off(j,point2) = randi(n,1);
            end
%                 % particle_position_history{j} = [particle_position_history{j};x(j,:)];

            for k2 = 1:p
                if rand < 0.3
                    offc = mod(off(j,k2),col);
                    offr =ceil(off(j,k2)/col);
                    while(offr> row || offr <=0 || offc> col || offc <= 0)
                        offr = offr+ randi([-rang,rang],1);
                        offc = offc+ randi([-rang,rang],1);
                    end
                    off(j,k2) = (offr-1)*col + offc;
                end
            end            
        end
        pop = off;
        
    end

   


