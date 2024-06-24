%Tent混沌映射初始化
clear;clc;


SearchAgents_no=50;  %群体个数
Max_iter=500;        %最大迭代次数
dim=2;              %维度

Positions_max=[500 500];%上限
Positions_min=[-500 -500];%下限

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize position vector and score for the leader
Leader_pos=zeros(1,dim);
Leader_score=inf; %最优值
Convergence_curve=zeros(1,Max_iter);%记录每代的最优值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化位置

Positions=rand(SearchAgents_no,dim).*(Positions_max-Positions_min)+Positions_min;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=0;% 迭代次数

% Main loop
while t<Max_iter
    %计算适用度
    for i=1:size(Positions,1)
        % 判断边界
        for nn=1:dim
            Flag_max=Positions(i,nn)>Positions_max(nn);
            Flag_min=Positions(i,nn)<Positions_min(nn);
            Positions(i,nn)=(Positions(i,nn).*(~(Flag_max+Flag_min)))+Positions_max(nn).*Flag_max+Positions_min(nn).*Flag_min;
        end
        % 计算适用度
        fitness=fun(Positions(i,:));
        % 更新最优位置和适用度
        if fitness<Leader_score % Change this to > for maximization problem
            Leader_score=fitness;       %最优适用度
            Leader_pos=Positions(i,:);  %最优位置
        end
    end

    %(设置和迭代次数相关的算法参数。)
    a=2-t*((2)/Max_iter);  % 等式（3）中a随迭代次数从2线性下降至0 
    %a2从-1线性下降至-2，计算l时会用到
    a2=-1+t*((-1)/Max_iter);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%更新位置（包围、攻击、搜索） 
    for i=1:size(Positions,1)
        r1=rand(); % r1  a [0,1] random number 
        r2=rand(); % r2  a [0,1] random number 
        %计算向量A、C
        A=2*a*r1-a;  
        C=2*r2;

        b=1;               %  螺旋形状常数
        l=(a2-1)*rand+1;   %  l为[-1,1]内均匀分布的随机数
        
        p = rand();        %座头鲸在包围猎物的同时可能进行螺旋运动
        for j=1:size(Positions,2)
            %
            if p<0.5   %包围猎物
                if abs(A)>=1    %随机选择（具有全局优化能力）
                    rand_leader_index = floor(SearchAgents_no*rand()+1);
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8) 
                elseif abs(A)<1 %包围猎物进行更新
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      % Eq. (2.2)
                end
                
            elseif p>=0.5   %气泡螺旋攻击
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                % Eq. (2.5)
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);   
            end
        end
    end
    t=t+1;
    Convergence_curve(t)=Leader_score;
end
plot(Convergence_curve,'LineWidth',1);
Leader_score    %目标最小值
Leader_pos      %各变量取值