function z = CostFunction(x)%z1、z2为两个目标函数

    n = numel(x);
    
    z1 = 1-exp(-sum((x-1/sqrt(n)).^2));
    
    z2 = 1-exp(-sum((x+1/sqrt(n)).^2));
    
    z = [z1 z2]';

end