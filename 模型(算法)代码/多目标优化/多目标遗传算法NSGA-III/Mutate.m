function y = Mutate(x, nMu, Max_Min,t)
%%多项式变异
    Nm=50+t;
    nVar = numel(x);%变量个数
    
    for i=1:nVar
        p=rand;
        if p<=nMu 
            Max=Max_Min(1,i);
            Min=Max_Min(2,i);
            Sigma1=(x(i)-Min)/(Max-Min);
            Sigma2=(Max-x(i))/(Max-Min);
            Sigma=min(Sigma1,Sigma2);
            u=rand;
            Sigma=Final_sigma(u,Sigma,Nm);
            y(i)=x(i)+Sigma*(Max-Min);
        else
            y(i) = x(i);
        end
    end
end

function Sigma=Final_sigma(u,SIGMA,Nm)
    if u<=0.5
        Sigma=(2*u+(1-2*u)*(1-SIGMA)^(Nm+1))^(1/(Nm+1))-1;
    else
        Sigma=1-(2*(1-u)+2*(u-0.5)*(1-SIGMA)^(Nm+1))^(1/(Nm+1));
    end
end
