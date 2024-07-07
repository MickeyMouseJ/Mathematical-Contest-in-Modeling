%% 此程序为matlab编程实现的BP神经网络
% 清空环境变量
clear
close all
clc

%%第一步 读取数据
input=[1000	1020	1040	1060	1080	1100	1120	1140	1160	1180	1200	1220	1240	1260	1280	1300	1320	1340	1360	1380	1400	1420	1440	1460	1480	1500	1520	1540	1560	1580	1600	1620	1640	1660	1680	1700	1720	1740	1760	1780	1800	1820	1840	1860	1880	1900	1920	1940	1960	1980	2000	2020	2040	2060	2080	2100	2120	2140	2160	2180	2200	2220	2240	2260	2280	2300	2320	2340	2360	2380	2400	2420	2440	2460	2480	2500	2520	2540	2560	2580	2600	2620	2640	2660	2680	2700	2720	2740	2760	2780	2800	2820	2840	2860	2880	2900	2920	2940	2960	2980	3000	3020	3040	3060	3080	3100	3120	3140	3160	3180	3200	3220	3240	3260	3280	3300	3320	3340	3360	3380	3400	3420	3440	3460	3480	3500	3520	3540	3560	3580	3600	3620	3640	3660	3680	3700	3720	3740	3760	3780	3800	3820	3840	3860	3880	3900	3920	3940	3960	3980	4000	4020	4040	4060	4080	4100	4120	4140	4160	4180	4200	4220	4240	4260	4280	4300	4320	4340	4360	4380	4400	4420	4440	4460	4480	4500	4520	4540	4560	4580	4600	4620	4640	4660	4680	4700	4720	4740	4760	4780	4800	4820	4840	4860	4880	4900	4920	4940	4960	4980
]';  %载入输出数据
output=[0.668	11.2729	21.8282
0.673	11.0744	21.6127
0.678	10.8813	21.3949
0.684	10.6564	21.9226
0.689	10.4743	21.7051
0.694	10.297	21.4853
0.699	10.1242	21.2631
0.704	9.9558	21.0385
0.709	9.79161	20.8115
0.715	9.59993	21.3535
0.72	9.44448	21.1267
0.725	9.29279	20.8975
0.73	9.14471	20.6657
0.735	9.00012	20.4314
0.741	8.83105	20.9856
0.746	8.69372	20.7515
0.751	8.55952	20.5148
0.756	8.42834	20.2754
0.761	8.30008	20.0334
0.767	8.14989	20.6002
0.772	8.02772	20.3583
0.777	7.90819	20.1137
0.782	7.7912	19.8663
0.787	7.67668	19.6161
0.793	7.54241	20.1961
0.798	7.43306	19.946
0.803	7.32593	19.693
0.808	7.22098	19.4371
0.813	7.11813	19.1783
0.818	7.01732	18.9164
0.824	6.89895	19.5132
0.829	6.80242	19.2513
0.834	6.70775	18.9864
0.839	6.61488	18.7183
0.845	6.50576	19.3263
0.85	6.41669	19.0583
0.855	6.32926	18.787
0.86	6.24345	18.5124
0.866	6.14253	19.1321
0.872	6.04378	19.7538
0.876	5.97912	18.5796
0.881	5.89959	18.2983
0.886	5.82145	18.0135
0.892	5.72947	18.6487
0.897	5.65428	18.3639
0.902	5.58036	18.0754
0.907	5.5077	17.7834
0.912	5.43626	17.4877
0.918	5.3521	18.1391
0.923	5.28324	17.8433
0.928	5.2155	17.5436
0.933	5.14887	17.2402
0.938	5.0833	16.9329
0.944	5.00601	17.6012
0.949	4.94271	17.2936
0.954	4.88042	16.982
0.959	4.81909	16.6664
0.964	4.75871	16.3466
0.969	4.69926	16.0227
0.975	4.62911	16.7125
0.98	4.57163	16.3882
0.985	4.515	16.0595
0.99	4.45922	15.7264
0.996	4.39337	16.431
1.001	4.33938	16.0974
1.006	4.28617	15.7593
1.011	4.23373	15.4166
1.016	4.18204	15.0693
1.022	4.12099	15.7932
1.027	4.0709	15.4452
1.032	4.02151	15.0924
1.037	3.97281	14.7347
1.042	3.92479	14.3721
1.048	3.86802	15.1162
1.053	3.82143	14.7527
1.058	3.77547	14.3841
1.063	3.73012	14.0103
1.069	3.67651	14.7713
1.074	3.63248	14.3965
1.079	3.58903	14.0163
1.084	3.54615	13.6307
1.089	3.50382	13.2396
1.095	3.45376	14.0225
1.1	3.41262	13.6301
1.105	3.37201	13.232
1.11	3.33191	12.828
1.115	3.29232	12.4182
1.121	3.24546	13.224
1.126	3.20694	12.8126
1.131	3.1689	12.3951
1.136	3.13132	11.9714
1.142	3.08683	12.7967
1.147	3.05025	12.3712
1.152	3.01411	11.9392
1.157	2.9784	11.5008
1.163	2.93611	12.3463
1.168	2.90133	11.9058
1.173	2.86695	11.4585
1.178	2.83298	11.0044
1.183	2.79939	10.5432
1.189	2.75961	11.4146
1.194	2.72687	10.951
1.199	2.6945	10.4801
1.204	2.6625	10.0019
1.21	2.62457	10.8955
1.215	2.59336	10.4144
1.22	2.56249	9.92575
1.225	2.53196	9.42925
1.23	2.50177	8.92485
1.236	2.46598	9.84638
1.241	2.43651	9.33864
1.246	2.40735	8.82265
1.251	2.37851	8.29829
1.257	2.34431	9.24407
1.262	2.31615	8.71596
1.267	2.28828	8.17912
1.272	2.2607	7.63342
1.277	2.23341	7.07875
1.283	2.20104	8.05454
1.288	2.17437	7.49535
1.294	2.14273	8.48787
1.298	2.12186	6.34871
1.304	2.09086	7.35085
1.309	2.06531	6.76768
1.314	2.04003	6.17457
1.319	2.015	5.57139
1.325	1.98529	6.60092
1.33	1.9608	5.99199
1.335	1.93655	5.3725
1.34	1.91254	4.74234
1.346	1.88404	5.80034
1.351	1.86055	5.16367
1.356	1.83728	4.51581
1.361	1.81423	3.85662
1.366	1.79141	3.18598
1.372	1.76431	4.27757
1.377	1.74196	3.59912
1.382	1.71982	2.90866
1.387	1.69789	2.20607
1.393	1.67184	3.3279
1.398	1.65036	2.61646
1.403	1.62907	1.89227
1.408	1.60798	1.15522
1.414	1.58293	2.30814
1.419	1.56226	1.56105
1.424	1.54178	0.800445
1.429	1.52149	0.0262308
1.435	1.49738	1.21096
1.44	1.47748	0.425328
1.445	1.45776	0
1.45	1.43822	0
1.456	1.41499	0
1.461	1.39583	0
1.466	1.37683	0
1.471	1.35799	0
1.477	1.33561	0
1.482	1.31713	0
1.487	1.29881	0
1.492	1.28065	0
1.498	1.25906	0
1.503	1.24123	0
1.509	1.22004	0
1.514	1.20255	0
1.519	1.1852	0
1.524	1.16799	0
1.529	1.15093	0
1.534	1.13401	0
1.539	1.11722	0
1.545	1.09727	0
1.55	1.08078	0
1.555	1.06443	0
1.56	1.04822	0
1.566	1.02893	0
1.571	1.013	0
1.576	0.997195	0
1.581	0.981517	0
1.587	0.962866	0
1.592	0.947459	0
1.597	0.932173	0
1.602	0.917006	0
1.608	0.898962	0
1.613	0.884054	0
1.618	0.86926	0
1.623	0.854581	0
1.628	0.840014	0
1.634	0.82268	0
1.639	0.808356	0
1.644	0.794141	0
1.649	0.780032	0
1.655	0.763242	0
1.66	0.749366	0
1.665	0.735593	0
1.67	0.721922	0
1.675	0.708352	0
1.681	0.692201	0
1.686	0.67885	0
1.691	0.665597	0
1.696	0.65244	0
1.702	0.636778	0
1.707	0.62383	0
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