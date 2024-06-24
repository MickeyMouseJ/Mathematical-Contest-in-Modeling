clc
clear
close all
%% 定义自变量范围
nvar = 5;   %变量个数
nobj = 2;   %求解函数个数
npop = 50;  %种群数量
maxit = 200;%迭代次数
pc = 0.8;   %交叉概率
nc = round(pc * npop / 2) * 2;
mu = 0.05;  %变异概率
varmin = [1,0,3,0.6,6]; %各变量下届
varmax = [13,2.8,21,1.6,41];    %各变量上届
step = [1, 0.1, 0.5, 0.05, 1];  %步长(若变量要求为整数则为1)
len = (varmax - varmin) ./ step;
var = [varmin;step;varmax;round(len, 0)];
%% 定义结果存放模板
empty.position = [];
empty.cost = [];
empty.rank = [];
empty.domination = [];
empty.dominated = 0;
empty.crowdingdistance = [];
pop = repmat(empty, npop, 1);
%% 初始化种群
for i = 1 : npop
    pop(i).position = create_x(var);
    pop(i).cost = costfunction(pop(i).position);
end

%% 非支配排序
[pop,F] = nondominatedsort(pop);

%% 拥挤度计算
pop = calcrowdingdistance(pop,F);

%% 主程序
for it = 1 : maxit
    
    popc = repmat(empty, nc/2,2);
    
    for j = 1 : nc / 2
       p1 = tournamentsel(pop);
       p2 = tournamentsel(pop);
       [popc(j, 1).position, popc(j, 2).position] = crossover(p1.position, p2.position);
    end
    
    popc = popc(:);
    
    for k = 1 : nc
        popc(k).position = mutate(popc(k).position, mu, var);
        popc(k).cost = costfunction(popc(k).position);%%%主意注意
    end
   
    newpop = [pop; popc];
    
    [pop,F] = nondominatedsort(newpop);

    pop = calcrowdingdistance(pop,F);
    
    % 排序
    pop = Sortpop(pop);
    
    % 淘汰
    pop = pop(1: npop);

    [pop,F] = nondominatedsort(pop);

    pop = calcrowdingdistance(pop,F);
    
    pop = Sortpop(pop);
    
    % 更新第1等级
    F1 = pop(F{1});
    
    % 显示迭代信息
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % 绘图
    figure(1);
    plotcosts(F1);%绘图代码
    pause(0.01);
end

