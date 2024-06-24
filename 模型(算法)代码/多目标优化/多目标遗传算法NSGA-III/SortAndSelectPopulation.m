function [pop, F, params] = SortAndSelectPopulation(pop, params)
%选择和排序个体
    [pop, params] = NormalizePopulation(pop, params);%求标准化目标值

    [pop, F] = NonDominatedSorting(pop);
    
    nPop = params.nPop;
    if numel(pop) == nPop
        return;
    end
    
    [pop, d, rho] = AssociateToReferencePoint(pop, params);
    %rho各个参考点拥有的点数；d每个个体到各个参考点的距离

    newpop = [];
    for l = 1:numel(F)%F每个等级包含的个体
        if numel(newpop) + numel(F{l}) > nPop
            LastFront = F{l};
            break;
        end
        
        newpop = [newpop; pop(F{l})];   %#ok
    end
    
    while true
        
        [~, j] = min(rho);
        
        AssocitedFromLastFront = [];
        for i = LastFront
            if pop(i).AssociatedRef == j
                AssocitedFromLastFront = [AssocitedFromLastFront i]; %#ok
            end
        end
        
        if isempty(AssocitedFromLastFront)
            rho(j) = inf;
            continue;
        end
        
        if rho(j) == 0
            ddj = d(AssocitedFromLastFront, j);
            [~, new_member_ind] = min(ddj);
        else
            new_member_ind = randi(numel(AssocitedFromLastFront));
        end
        
        MemberToAdd = AssocitedFromLastFront(new_member_ind);
        
        LastFront(LastFront == MemberToAdd) = [];
        
        newpop = [newpop; pop(MemberToAdd)]; %#ok
        
        rho(j) = rho(j) + 1;
        
        if numel(newpop) >= nPop
            break;
        end
        
    end
    
    [pop, F] = NonDominatedSorting(newpop);
    
end