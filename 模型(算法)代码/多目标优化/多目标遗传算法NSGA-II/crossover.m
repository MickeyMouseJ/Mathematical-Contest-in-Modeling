
function [y1, y2] = crossover(x1, x2)

    n = numel(x1);
    r = randi([1, n - 1], 1);
    index = randperm(r, r);

    y1 = x1;
    y1(index) = x2(index);

    y2 = x2;
    y2(index) = x1(index);
    
end