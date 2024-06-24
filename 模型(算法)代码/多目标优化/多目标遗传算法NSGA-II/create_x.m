function x = create_x(var)

    n = size(var, 2);
    x = zeros(1, n);
    for i = 1 : n
        x(i) = var(1, i) + randi([0, var(4, i)], 1) * var(2, i);
    end
    
end