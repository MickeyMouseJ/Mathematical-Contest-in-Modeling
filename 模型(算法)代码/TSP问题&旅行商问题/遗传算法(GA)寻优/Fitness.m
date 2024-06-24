%% 适配值函数     
%输入：
%个体的长度（TSP的距离）
%输出：
%个体的适应度值
%适应度越大越好
function FitnV=Fitness(len)
FitnV=1./len;