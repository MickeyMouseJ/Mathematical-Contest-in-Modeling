function [d,r]=floyd(a)
n=size(a,1);%测出a矩阵的行数
d=a;% 初始化距离矩阵
for i=1:n % 初始化路由矩阵
    for j=1:n
        r(i,j)=j;%使路由矩阵r形成初始矩阵（每一列上的数为该列的列序数，例：第3列上的数全为3）（上面有提到）
    end 
end 
r;


for k=1:n % 开始Floyd算法（用if语句来比较中转前后的大小）
    for i=1:n
        for j=1:n
            if d(i,k)+d(k,j)<d(i,j)%需要更新的条件（也就是中转后比原来要小）
                d(i,j)=d(i,k)+d(k,j);
                r(i,j)=r(i,k);
            end 
        end 
    end
   
end
k;
    d;
    r;