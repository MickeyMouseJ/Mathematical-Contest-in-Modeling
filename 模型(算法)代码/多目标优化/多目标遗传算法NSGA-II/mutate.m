
function y = mutate(x, mu, var)
    
    n = numel(x);
    r = rand(1, n);
    index = find(r <= mu);
    new = create_x(var);
    x(index) = new(index);
    y = x;  

end