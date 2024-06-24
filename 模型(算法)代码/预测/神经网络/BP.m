%% 此程序为matlab编程实现的BP神经网络
% 清空环境变量
clear
close all
clc

%%第一步 读取数据
input=[40	800
40	900
40	1000
40	1100
40	1200
35	800
35	900
35	1000
35	1100
35	1200
30	800
30	900
30	1000
30	1100
30	1200
25	800
25	900
25	1000
25	1100
25	1200
20	800
20	900
20	1000
20	1100
20	1200];  %载入输出数据

output=[2.7592	96.0163	84.7938
3.0492	96.6609	85.3204
3.2790	96.9097	85.5564
3.4224	96.7573	85.0333
3.5169	96.7212	83.6683
2.4027	95.9596	86.7192
2.6961	96.4053	87.2614
2.9215	96.5166	87.2977
3.0660	96.3912	87.0839
3.1587	96.6911	85.7136
2.1160	95.1474	87.5965
2.3970	95.6280	88.2532
2.6174	96.3005	88.4133
2.7746	96.3657	87.3585
2.8552	96.4265	86.3749
1.8799	94.3680	87.4861
2.1594	95.0814	87.9384
2.3747	95.4678	88.3176
2.5152	96.2049	87.5170
2.6100	95.9750	86.2230
1.7004	93.8902	86.1789
1.9827	94.7659	86.9146
2.1829	95.1854	86.7523
2.3306	95.2931	86.2531
2.4092	95.8496	85.1721
   ]
[m1,n1]=size(input)
[m2,n2]=size(output)
%% 第二步 设置训练数据和预测数据
input_train = input';
output_train =output';
input_test = input';
output_test =output';
%节点个数
inputnum=n1; % 输入层节点数量
c=5%常数
hiddennum=round(sqrt(n1+n2))+c;% 隐含层节点数量
outputnum=n2; % 输出层节点数量
%% 第三本 训练样本数据归一化
[inputn,inputps]=mapminmax(input_train);%归一化到[-1,1]之间，inputps用来作下一次同样的归一化
[outputn,outputps]=mapminmax(output_train);
%% 第四步 构建BP神经网络
net=newff(inputn,outputn,hiddennum,{'tansig','purelin'},'trainlm');% 建立模型，传递函数使用purelin，采用梯度下降法训练

W1= net. iw{1, 1};%输入层到中间层的权值
B1 = net.b{1};%中间各层神经元阈值

W2 = net.lw{2,1};%中间层到输出层的权值
B2 = net. b{2};%输出层各神经元阈值
net.trainParam.epochs=1000;         % 训练次数，这里设置为1000次
net.trainParam.lr=0.00001;             % 学习速率，这里设置为0.01
net.trainParam.goal=0.000001;             % 训练目标最小误差，这里设置为0.00001
net.trainParam.max_fail=10000
%% 第五步 网络参数配置（ 训练次数，学习速率，训练目标最小误差等）
%net.trainParam.epochs=1000;         % 训练次数，这里设置为1000次
%net.trainParam.lr=0.00000001;                   % 学习速率，这里设置为0.01
%net.trainParam.goal=1;                    % 训练目标最小误差，这里设置为0.00001

%% 第六步 BP神经网络训练
net=train(net,inputn,outputn);%开始训练，其中inputn,outputn分别为输入输出样本

%% 第七步 测试样本归一化
inputn_test=mapminmax('apply',input_test,inputps);% 对样本数据进行归一化

%% 第八步 BP神经网络预测
an=sim(net,inputn_test); %用训练好的模型进行仿真

%% 第九步 预测结果反归一化与误差计算     
test_simu=mapminmax('reverse',an,outputps); %把仿真得到的数据还原为原始的数量级
error=test_simu-output_test;      %预测值和真实值的误差

[c,l]=size(output_test);
%%第十步 真实值与预测值误差比较
%对第一个的预测值
figure('units','normalized','position',[0.119 0.2 0.38 0.5])
for i=1:c
    %subplot(c,1,i)
    figure()
    plot(output_test(i,:),'-','LineWidth',1.2)
    hold on
    plot(test_simu(i,:),'-','LineWidth',1.2)
    hold on
    plot(error(i,:),'.','MarkerSize',8,'Color',[84/255,134/255,135/255])
    legend('期望值','预测值','误差')
    xlabel('数据组数')
    ylabel('样本值')
title(sprintf("对第%d个指标的预测值BP神经网络测试集的预测值与实际值对比图", i))
end
for i=1:c
MAE1(i)=sum(abs(error(i,:)))/l;
end

for i=1:c
MSE1(i)=error(i,:)*error(i,:)'/l;
end

for i=1:c
RMSE1(i)=MSE1(i)^(1/2);
end
disp(['-----------------------误差计算--------------------------'])
disp(['隐含层节点数为',num2str(hiddennum),'时的误差结果如下：'])
disp(['平均绝对误差MAE为：',num2str(MAE1)])
disp(['均方误差MSE为：       ',num2str(MSE1)])
disp(['均方根误差RMSE为：  ',num2str(RMSE1)])

int_test1=[2000:0.5:8000];
inputn_test1=mapminmax('apply',int_test1,inputps)
an1=sim(net,inputn_test1)
test_simu1=mapminmax('reverse',an1,outputps)
figure
plot(int_test1, test_simu1,'LineWidth',1.2)
legend("浮标在海水中的深度","倾斜角度","锚链在锚点与海床的夹角")