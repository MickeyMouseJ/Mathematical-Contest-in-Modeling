function ttlDistance=Evaluation(route,Distance)
%% 计算各个体的路径长度 适应度函数  
% 输入：
% route         种群矩阵
% Distance      两两城市之间的距离
% 输出：
% ttlDistance	种群个体路径距离组成的向量

col=size(Distance,2); %col=配送中心+需求点数
differen_Distance=Distance(1:col,route)';
[minDistance,minInd]=min(differen_Distance);
ttlDistance=[sum(minDistance),minInd]; %矩阵中这些每两点间距离之和
% Distance(55)指在Distance矩阵中，从左数第一列往下数，再从左数第二列往下数，...，再从最右列往下数的累积第55个数（此处读者可能较难理解）
% Distance([55,56,57])指按上一行方法得到的第55 56 57个数组成的行向量