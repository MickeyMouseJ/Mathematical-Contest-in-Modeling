
%% 清空环境变量
warning off             % 用于关闭报警信息
close all               % 用于关闭开启的图窗
clear                   % 用于清空变量
clc                    % 用于清空命令行
%%导入libsvm路径
cd;
path (path,'libsvm');
matrix=xlsread('第三问.xlsx','表单2','F2:S68');%导入第三问.xlsx','表单2','F2:S68中数据
label=xlsread('第三问.xlsx','表单2','D2:D68');%导入第三问.xlsx','表单2','D2:D68中数据
% 随机产生训练集和测试集
n = randperm(size(matrix,1));%随机生成测试集
% 训练集——80个样本
XXjk = matrix(n(1:53),:);
Xhhjk = label(n(1:53),:);
% 测试集——26个样本
fhjtihb = matrix(n(54:end),:);
dhyd = label(n(54:end),:);

%% 数据归一化
[dTrain_mdgatrix,PS] = mapminmax(XXjk');
dTrain_mdgatrix = dTrain_mdgatrix';
fIdgwb = mapminmax('apply',fhjtihb',PS);
fIdgwb = fIdgwb';

[bestc,bestg]=SSA_PRO(Xhhjk,dTrain_mdgatrix);

cmd = [' -t 2',' -c ',num2str(bestc),' -g ',num2str(bestg)];
% 创建/训练SVM模型
model = libsvmtrain(Xhhjk,dTrain_mdgatrix,cmd);

%% SVM仿真测试
[predict_label_1,accuracy_1,prebict_label_1] = libsvmpredict(Xhhjk,dTrain_mdgatrix,model);
[predict_label_2,accuracy_2,prebict_label_2] = libsvmpredict(dhyd,fIdgwb,model);
result_1 = [Xhhjk predict_label_1];
result_2 = [dhyd predict_label_2];

%% 绘图
figure
plot(1:length(dhyd),dhyd,'r-*')%设定折线图的标点大小形状及线宽
hold on%保留作图痕迹并接收后面新绘制出的图片
plot(1:length(dhyd),predict_label_2,'b:o')%设定折线图的标点大小形状及线宽
grid on%保留作图痕迹并接收后面新绘制出的图片
legend('真实类别','预测类别')%设定折线图标签
xlabel('测试集样本编号')%设定折线图的x轴横坐标名称
ylabel('测试集样本类别')%设定折线图的y轴纵坐标名称
string = {'测试集SVM预测结果对比(RBF核函数)';
          ['accuracy = ' num2str(accuracy_2(1)) '%']};
title(string)

%%
%预测
Test_input=xlsread('第三问.xlsx','表单3','C2:P9');%读取文件第三问.xlsx','表单3','C2:P9数据
Test_output=[0;0;0;0;0;0;0;0];
Test_input = mapminmax('apply',Test_input',PS);
Test_input=Test_input';
[predict_label_test,accuracy_test,prebict_label_test] = libsvmpredict(Test_output,Test_input,model);


%%
%灵敏度分析1
Test_input_LMD=xlsread('第三问.xlsx','表单3','C2:P9');%读取文件第三问.xlsx','表单3','C2:P9中数据
Test_output_LMD=[0;0;0;0;0;0;0;0];
DD=1.05;
ZU=[];
for i=1:14
    Test_output_LMD = Test_input_LMD(:,i)*DD;
    Test_input_LMD = mapminmax('apply',Test_input_LMD',PS);
    Test_input_LMD=Test_input_LMD';
    [predict_label_test_LMD,accuracy_test_LMD,prebict_label_test_LMD] = libsvmpredict(Test_output_LMD,Test_input_LMD,model);
    ZU(i,:)=predict_label_test_LMD;
end

%%
%灵敏度分析2
Test_input_LMD2=xlsread('第三问.xlsx','表单3','C2:P9');
Test_output_LMD2=[0;0;0;0;0;0;0;0];
DD2=0.95;
ZU2=[];
for i=1:14
    Test_output_LMD2 = Test_input_LMD2(:,i)*DD2;
    Test_input_LMD2 = mapminmax('apply',Test_input_LMD2',PS);
    Test_input_LMD2=Test_input_LMD2';
    [predict_label_test_LMD2,accuracy_test_LMD2,prebict_label_test_LMD2] = libsvmpredict(Test_output_LMD2,Test_input_LMD2,model);
    ZU2(i,:)=predict_label_test_LMD2;
end
