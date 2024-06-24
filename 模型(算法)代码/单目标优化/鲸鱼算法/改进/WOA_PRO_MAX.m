%改进1，Tent混沌映射初始化
%改进2，收敛因子a，采用非线性
clear;clc;
baita=1.5;
BestFitness_N=1;

dim=2;              %维度  
SearchAgents_no=50;     %群体个数
Max_iter=500;           %最大迭代次数
Limit=round(Max_iter/100);

Positions_max=[500 500];%上限
Positions_min=[-500 -500];%下限
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize position vector and score for the leader
Leader_pos=zeros(1,dim);
Leader_score=inf; %最优值
Convergence_curve=zeros(1,Max_iter);%记录每代的最优值
fitness=zeros(1,SearchAgents_no);
fitness_x=zeros(1,SearchAgents_no);
Positions=zeros(SearchAgents_no,dim);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化位置
%Tent 混沌映射
Positions=initialization(dim,SearchAgents_no);
Positions=Positions_min+Positions.*(Positions_max-Positions_min);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%鲸鱼算法主程序
t=0;% 迭代次数
% Main loop
while t<Max_iter
    %计算适用度
    for i=1:size(Positions,1)
        % 判断边界
        for nn=1:dim
            Flag_max=Positions(i,nn)>Positions_max(nn);
            Flag_min=Positions(i,nn)<Positions_min(nn);
            if  Flag_max
                Positions(i,nn)=unifrnd(0.95,1)*(Positions_max(nn)-Positions_min(nn))+Positions_min(nn);
            elseif  Flag_min
                Positions(i,nn)=unifrnd(0,0.05)*(Positions_max(nn)-Positions_min(nn))+Positions_min(nn);
            end
        end
        % 计算适用度
        fitness(i)=fun(Positions(i,:));
        % 更新最优位置和适用度
%         if fitness(i)<Leader_score % Change this to > for maximization problem
%             Leader_score=fitness(i);       %最优适用度
%             Leader_pos=Positions(i,:);  %最优位置
%         end
    end

    %高斯扰动
    for i=1:size(Positions,1)
        x(i,:)=Positions(i,:)+Positions(i,:).*Nf();
        for nn=1:dim
            Flag_max=x(i,nn)>Positions_max(nn);
            Flag_min=x(i,nn)<Positions_min(nn);
            if  Flag_max
                x(i,nn)=unifrnd(0.95,1)*(Positions_max(nn)-Positions_min(nn))+Positions_min(nn);
            elseif  Flag_min
                x(i,nn)=unifrnd(0,0.05)*(Positions_max(nn)-Positions_min(nn))+Positions_min(nn);
            end
        end
        fitness_x(i)=fun(x(i,:));
        % 更新更优位置和适用度
        if fitness_x(i)<fitness(i) % Change this to > for maximization problem
            fitness(i)=fitness_x(i);       %最优适用度
            Positions(i,:)=x(i,:);  %最优位置
        end
    end

    %更新最优位置和适用度
    for mm=1:size(Positions,1)
        if(Leader_score>fitness(mm))
            Leader_score=fitness(mm);
            Leader_pos=Positions(mm,:);
        end
    end

    %(设置和迭代次数相关的算法参数。)
    a=2*(1-sqrt(t/Max_iter));  % 改进，非线性递归收敛因子从2递减到0
    %a2从-1线性下降至-2，计算l时会用到
    a2=-1-sqrt(t/Max_iter);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%更新位置（包围、攻击、搜索）
if BestFitness_N<Limit
    for i=1:size(Positions,1)
        r1=rand(); % r1  a [0,1] random number 
        r2=rand(); % r2  a [0,1] random number 
        %计算向量A、C
        A=2*a*r1-a;  
        C=2*r2;

        l=(a2-1)*rand+1;   %  l为[-1,1]内均匀分布的随机数
        
        for j=1:size(Positions,2)
                if abs(A)>=1    %随机选择（具有全局优化能力）
                    rand_leader_index = floor(SearchAgents_no*rand()+1);
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8) 
                elseif abs(A)<1 %包围猎物进行更新
                        D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); 
                        Y=Leader_pos(j)-A*D_Leader;
                    if(fitness(i)==Leader_score)
                        Positions(i,j)=Y; 
                    else
                        SiGeMa=((gamma(1+baita)*sin(pi*baita/2)/(gamma((1+baita)/2)*baita*2^((baita-1)/2))))^(1/baita);
                        LF=0.01*(rand*SiGeMa)/(rand)^(1/baita);
                        Positions(i,j)=Y+(rand/10)*LF;
                    end
                end
        end
    end
else   %气泡螺旋攻击
    b=1;               %  螺旋形状常数
    for i=1:size(Positions,1)         
        for j=1:size(Positions,2)    
            distance2Leader=abs(Leader_pos(j)-Positions(i,j));
            Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);   
        end
    end
end

    t=t+1;
    Convergence_curve(t)=Leader_score;
    if t>1
        if  Convergence_curve(t)==Convergence_curve(t-1)
            BestFitness_N=BestFitness_N+1;
        else
            BestFitness_N=1;
        end
    end
end
plot(Convergence_curve,'LineWidth',1);
Leader_score
Leader_pos