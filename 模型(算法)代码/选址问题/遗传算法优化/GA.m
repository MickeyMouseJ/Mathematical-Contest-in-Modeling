clear
clc
close all
load('CityPosition.mat');%导入城市坐标位置,可以换成load CityPosition1~3.mat
X=CityPosition;
Number=5;       %选址个数

NIND=100;       %种群大小
MAXGEN=50;     %迭代次数
Pc=0.9;         %交叉概率
Pm=0.1;         %变异概率
GGAP=0.9;       %代沟(Generation gap)
D=Distanse(X);  %生成距离矩阵
N=size(D,1);    %可选地址个数
%% 初始化种群
Chrom=InitPop(NIND,N,Number);%生成NIND个N个地方的路径，即遗传编码
% 在二维图上画出所有坐标点
figure
plot(X(:,1),X(:,2),'o');
%% 优化
gen=1;
for i=1:NIND
    ObjV(i,:)=objective_function(Chrom(i,:));
end
preObjV=min(ObjV);
while gen<MAXGEN
    %% 计算适应度
    for i=1:NIND
        ObjV(i,:)=objective_function(Chrom(i,:));  %计算路线长度
    end
    preObjV(gen)=min(ObjV);
    fprintf('经%d代，最优路径长度为：%1.10f\n',gen,preObjV(gen))
    FitnV=Fitness(ObjV);
    SelCh=Select(Chrom,FitnV,GGAP);% 选择
    SelCh=Recombin(SelCh,Pc);% 交叉操作
    SelCh=Mutate(SelCh,Pm);% 变异
    SelCh=Reverse(SelCh,D);% 逆转操作
    Chrom=Reins(Chrom,SelCh,ObjV);% 重插入子代的新种群
    gen=gen+1; % 更新迭代次数
end

%% 画出最优解的路线图
figure
for i=1:NIND
    ObjV(i,:)=objective_function(Chrom(i,:));  %计算路线长度
end
[minObjV,minInd]=min(ObjV);
minChrom=Chrom(minInd,:);
plot(X(:,1),X(:,2),'o');
hold on
plot(X(Chrom(minInd,:),1),X(minChrom,2),'*')
hold on
for i=1:N
    distance(i,:)=dist(X(i,:),X(minChrom,:)');
end
[a,b]=min(distance');
ww=[X(minChrom(b),1),X(minChrom(b),2)];
for i=1:N
plot([X(i,1),ww(i,1)],[X(i,2),ww(i,2)],'b')
hold on
end
%% 画出迭代曲线
figure
plot(preObjV)
title('优化过程')
xlabel('代数')
ylabel('最优值')
