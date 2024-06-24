%此NSGA-III用于求出多目标的最小值结集
%需要改进地点：上下界判断

clc;
clear;
close all;

%% Problem Definition

nVar = 5;    % 变量个数

VarSize = [1 nVar]; % Size of Decision Variables Matrix


VarMin = [-1,1,-1,-1,-1];   % 下界
VarMax = [1,3,1,1,1];   % 上届
Max_Min = [VarMax;VarMin]; % 突变的步长(相当于进化速度)

% 目标函数个数
nObj = numel(CostFunction(unifrnd(VarMin, VarMax, VarSize)));


%% NSGA-III Parameters

% 生成参考点
nDivision = 10; %参考点的个数
Zr = GenerateReferencePoints(nObj, nDivision);  %生成参考点

MaxIt = 50;  % 最大迭代次数

nPop = 100;  % 种群数量

pCrossover = 0.8;       % 交叉概率
nCrossover = 2*round(pCrossover*nPop/2); % 子代的数量

pMutation = 0.2;       % 变异个体数量
nMutation = round(pMutation*nPop);  % 变异体数量

mu = 0.05;     % 变异概率


%% Colect Parameters

params.nPop = nPop;
params.Zr = Zr;
params.nZr = size(Zr, 2);
params.zmin = [];
params.zmax = [];
params.smin = [];

%% Initialization

disp('Staring NSGA-III ...');

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.NormalizedCost = [];
empty_individual.AssociatedRef = [];
empty_individual.DistanceToAssociatedRef = [];

pop = repmat(empty_individual, nPop, 1);%生成种群数量的空结构体
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);%首先采用均匀分布生成种群
    pop(i).Cost = CostFunction(pop(i).Position);%计算适应度，即所求函数集的各个函数的值
end

% %选择和排序个体
[pop, F, params] = SortAndSelectPopulation(pop, params);


%% NSGA-III 主函数

for it = 1:MaxIt
 
    % 子代
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2

        i1 = randi([1 nPop]);
        p1 = pop(i1);

        i2 = randi([1 nPop]);
        p2 = pop(i2);

        [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);
        
        for jj=1:2
            for nn=1:nVar   %%越界处理
                MaxFlag=popc(k,jj).Position(nn)>VarMax(nn);
                MinFlag=popc(k,jj).Position(nn)<VarMin(nn);
                if(MaxFlag || MinFlag)
                    popc(k,jj).Position(nn)=VarMax(nn)-(VarMax(nn)-VarMin(nn))*rand;
                end
            end
        end
        popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Position);

    end
    popc = popc(:);

    % 变异操作
    popm = repmat(empty_individual, nMutation, 1);%生成变异个体空结构体
    for k = 1:nMutation

        i = randi([1 nPop]);
        p = pop(i);
        popm(k).Position = Mutate(p.Position, mu, Max_Min,it);%进行变异操作

        for nn=1:nVar%%越界处理
            MaxFlag=popm(k).Position(nn)>VarMax(nn);
            MinFlag=popm(k).Position(nn)<VarMin(nn);
            if(MaxFlag || MinFlag)
                popm(k).Position(nn)=VarMax(nn)-(VarMax(nn)-VarMin(nn))*rand;
            end
        end

        popm(k).Cost = CostFunction(popm(k).Position);%计算变异操作后的目标函数集合内个函数的值

    end

    % 将母代、子代、变异个体集合，以便接下来进行处理
    pop = [pop
           popc
           popm]; %#ok
    
    % Sort Population and Perform Selection
    [pop, F, params] = SortAndSelectPopulation(pop, params);
    
    % 选择出最优的个体(即等级为1的个体)
    F1 = pop(F{1});

    % 展示现在存在的最好个体数目
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);

    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
    pause(0.01);
 
end

%% Results

disp(['Final Iteration: Number of F1 Members = ' num2str(numel(F1))]);
disp('Optimization Terminated.');
