function S2=NewSolution(S1,CityNum)
% 输入
% S1:当前解
% 输出
% S2：新解
%nn:扰动范围
nn=3;
Length=length(S1); %获得原解元素个数
limit=0;
while limit==0
    s=randi([-nn,nn],1,Length);
    S_limit=S1-s;
    maxn=max(S_limit);
    minn=min(S_limit);
    uniq=length(S_limit)-length(unique(S_limit));
    if  maxn<=CityNum && minn>=1 && ~uniq
            limit=1;
            S2=S_limit;
    end
end