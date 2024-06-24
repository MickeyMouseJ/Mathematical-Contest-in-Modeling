clc
clear
close all

%训练
input_train_0ld=xlsread('相同插层率不同工艺.xlsx','a2:b70');%输入
output_train_old=xlsread('相同插层率不同工艺.xlsx','e2:e70')%输出

%测试
input_test_old=xlsread('相同插层率不同工艺.xlsx','a71:b76');%输入
output_test_old=xlsread('相同插层率不同工艺.xlsx','e71:e76')%输出

%归一化
[input_train_new,inputps_rule]=mapminmax(input_train_0ld');%归一化
[output_train_new,outputs_rule]=mapminmax(output_train_old');%归一化
input_test_new=mapminmax('apply',input_test_old',inputps_rule);
output_test_new=mapminmax('apply',output_test_old',outputs_rule);

input_train_new=input_train_new';
output_train_new=output_train_new';
input_test_new=input_test_new';
output_test_new=output_test_new';

%训练集
train_x=input_train_new;
train_y=output_train_new;
train_data=[train_x train_y];

%观察集合
valid_x=input_train_new;
valid_y=output_train_new;
valid_data=[valid_x valid_y];

%测试集
test_x=input_test_new;
test_y=output_test_new;
test_data=[test_x test_y];

%从数据生成模糊推理系统对象
%网格分区、减法聚类或模糊 c 均值 （FCM） 聚类来生成模糊系统。
%默认为网格分区
initialfis=genfis2(train_x,train_y,0.5); %减法聚类 
%initialfis=genfis(train_x,train_y);%网格分区

%命令的选项集anfis；'InitialFIS'，生成模糊系统，'EpochNumber'，迭代次数，'InitialStepSize'初始步长，'ValidationData'，验证数据
opt = anfisOptions('InitialFIS',initialfis,'EpochNumber',300,'InitialStepSize',0.01,'ValidationData',valid_data);

%outfit,经过训练的模糊推理系统，
%error,训练均方根误差
%stepsize,训练步长
%chkfis,验证误差最小的模糊推理系统
%chkerror,均方根验证误差
[outfis,error,stepsize,chkfis,chkerror]=anfis(train_data,opt);

fisRMSE=min(error);

%输出
anfis_Output_train = evalfis(train_x,outfis);%对训练集
anfis_Output_test = evalfis(test_x,outfis);%对测试集

%反归一化
output_train_Anfis=mapminmax('reverse',anfis_Output_train,outputs_rule);
output_test_Anfis=mapminmax('reverse',anfis_Output_test,outputs_rule);

%对比
%训练集合
figure()
plot(output_train_old);
hold ON
plot(output_train_Anfis);
legend('真实值','拟合值');
title('训练集合');
%测试集合
figure()
plot(output_test_old);
hold ON
plot(output_test_Anfis);
legend('真实值','拟合值');
title('测试集合');

%步长
figure()
plot(stepsize);
xlabel('迭代次数');
ylabel('步长');

%第二个输入参数的隶属度
[x,mf] = plotmf(initialfis,'input',1);
subplot(3,1,1)
plot(x,mf)
xlabel('Membership Functions for Input 1')
[x,mf] = plotmf(initialfis,'input',2);
subplot(3,1,2)
plot(x,mf)
xlabel('Membership Functions for Input 2')

subplot(3,1,3)
gensurf(initialfis)
%% 
%误差
%训练集
train_length=length(output_train_Anfis);
train_Error=abs(output_train_Anfis-output_train_old);
train_mse=mse(train_Error);
train_rmse=sqrt(train_mse);
train_mae=sum(abs(train_Error))/train_length;
train_sse=sum(train_Error.^2);
disp(sprintf('训练集：mse:%f; rmse:%f; mae:%f; sse:%f',train_mse,train_rmse,train_mae,train_sse));
%测试集
test_length=length(output_test_Anfis);
test_Error=abs(output_test_Anfis-output_test_old);
test_mse=mse(test_Error);
test_rmse=sqrt(test_mse);
test_mae=sum(abs(test_Error))/test_length;
test_sse=sum(test_Error.^2);
disp(sprintf('测试集：mse:%f; rmse:%f; mae:%f; sse:%f',test_mse,test_rmse,test_mae,test_sse));
