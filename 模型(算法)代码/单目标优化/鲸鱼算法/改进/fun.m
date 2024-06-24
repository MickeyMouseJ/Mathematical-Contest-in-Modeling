function f=fun(in)
z = zeros(size(in,1),1);
for i=1:size(in,1)
    x = in(i,:);
    for j=1:size(in,2)
        temp = x(j) * sin(sqrt(abs(x(j))));
        z(i,1) = z(i,1) + temp;
    end
end
f = z;
