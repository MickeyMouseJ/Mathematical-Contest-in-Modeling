function z = dominate(p, q)

    c1 = [p.cost];
    c2 = [q.cost];
    
    z = all(c1 <= c2) && any(c1 < c2);

end
