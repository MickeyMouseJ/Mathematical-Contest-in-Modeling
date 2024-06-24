function [pop,F] = nondominatedsort(pop)

    npop = numel(pop);
    
    % 初始化支配集和被支配个数
     for i = 1 : npop
         % 支配解集
         pop(i).domination = [];
         % 被支配次数
         pop(i).dominated = 0;  
     end
    
    F{1} = [];
    
    for i = 1 : npop
        p = pop(i);
        for j = i+1 : npop 
            q = pop(j);
            if dominate(p, q)
                p.domination = [p.domination j];
                q.dominated = q.dominated + 1;
            elseif dominate(q, p)
                q.domination = [q.domination i];
                p.dominated = p.dominated + 1;
            end
            
            pop(i) = p;
            pop(j) = q;
        end
        
        if pop(i).dominated == 0
            pop(i).rank = 1;
            F{1} = [F{1} i];
        end
    end
    
    k = 1;
    
    while true
        
        Q = [];
        
        for i = F{k}
            
            p = pop(i);
            
            for j = p.domination
                q = pop(j);
                q.dominated = q.dominated - 1;
                
                if q.dominated == 0 
                    Q = [Q j];
                    q.rank = k + 1;
                end
                
                pop(j) = q;
            end
        end
        
        if isempty(Q)
            break
        else
            F{k+1} = Q;
            k = k + 1;
        end
    end
end
