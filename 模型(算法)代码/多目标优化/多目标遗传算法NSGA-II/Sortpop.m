function pop = Sortpop(pop)
    
    [~, CDSO] = sort([pop.crowdingdistance], 'descend'); % 降序排列
    pop = pop(CDSO);
    
    [~, RSO] = sort([pop.rank]); % 升序排列
    pop = pop(RSO);


end
