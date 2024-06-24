function p = tournamentsel(pop)
    
    n = numel(pop);
    s = randperm(n,2);
    p1 = pop(s(1));
    p2 = pop(s(2));
    if p1.rank < p2.rank
        p = p1;
    elseif p1.rank == p2.rank
        if p1.crowdingdistance > p2.crowdingdistance
            p = p1;
        else
            p = p2;
        end
    else
        p = p2;
    end
end
