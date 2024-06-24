function [y1 y2] = Crossover(x1, x2)
%%模拟二进制表示的单点交叉
    n=1;%分布指数的常数。当η值较大时，后代将更倾向于与其父母相似。 η的常用值为10或20。
    Mu = rand(size(x1));
    alpha=zeros(size(x1));
    Nub=size(x1);%变量个数
    for j=1:Nub(2)
        if  Mu(j)<=0.5
            alpha(j)=(2*Mu(j))^(1/(n+1));
        else
            alpha(j)=(1/(2*(1-Mu(j))))^(1/(n+1));
        end
    end
    
    y1 = ((1+alpha).*x1+(1-alpha).*x2)./2;
    y2 = ((1-alpha).*x1+(1+alpha).*x2)./2;
    
end

