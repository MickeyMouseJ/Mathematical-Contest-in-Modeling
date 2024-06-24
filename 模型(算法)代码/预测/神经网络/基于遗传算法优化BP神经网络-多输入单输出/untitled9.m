clc
clear
% 
%% 网络结构建立
%读取数据
input=[187.2292723	196.2027733
253.3480683	195.385928
263.9555192	194.2925261
265.1745735	193.1960016
263.0189153	188.1602354
227.0427041	186.6467751
208.5613258	185.6657323
208.5613258	185.6657323
247.8808153	185.5100616
225.6711493	184.7883731
220.5587953	184.5230064
220.5587953	184.5230064
261.8091819	184.4165966
249.3897138	183.5010711
238.087099	182.8551316
238.087099	182.8551316
];
output=[79.83
79.37
81.23
79.61
78.29
79.76
79.93
79.59
78.87
78.76
78.55
79.2
78.52
79.38
79.76
79.92];

%节点个数
inputnum=2;
hiddennum=2;
outputnum=1;

%训练数据和预测数据
input_train=input';
input_test=input';
output_train=output';
output_test=output';

%训练样本输入输出数据归一化
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%构建网络
net=newff(inputn,outputn,hiddennum);

%% 遗传算法参数初始化
maxgen=50;                         %进化代数，即迭代次数
sizepop=10;                        %种群规模
pcross=[0.4];                       %交叉概率选择，0和1之间
pmutation=[0.2];                    %变异概率选择，0和1之间

%节点总数
numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

lenchrom=ones(1,numsum);                       %个体长度
bound=[-3*ones(numsum,1) 3*ones(numsum,1)];    %个体范围

individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %将种群信息定义为一个结构体
avgfitness=[];                      %每一代种群的平均适应度
bestfitness=[];                     %每一代种群的最佳适应度
bestchrom=[];                       %适应度最好的染色体
%计算个体适应度值
for j=1:outputnum
    for i=1:sizepop
        %随机产生一个种群
        individuals.chrom(j,i,:)=Code(lenchrom,bound);    %编码（binary和grey的编码结果为一个实数，float的编码结果为一个实数向量）
        x=individuals.chrom(j,i,:);
        %计算适应度
        individuals.fitness(j,:)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn,j);   %染色体的适应度
    end
end
FitRecord=[];
%找最好的染色体
for i=1:outputnum
[bestfitness(i,:),bestindex(i,:)]=min(individuals.fitness(i));
bestchrom(i,:)=individuals.chrom(bestindex(i,:),:);  %最好的染色体
avgfitness(i,:)=sum(individuals.fitness(i,:))/sizepop; %染色体的平均适应度
%记录每一代进化中最好的适应度和平均适应度
trace(i,:)=[avgfitness(i,:) bestfitness(i,:)]; 
end
%% 迭代求解最佳初始阀值和权值
% 进化开始
for i=1:maxgen
  
    % 选择
    individuals=select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %交叉
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % 变异
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    
    % 计算适应度 
    for j=1:sizepop
        x=individuals.chrom(j,:); %个体
        individuals.fitness(j)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   
    end
    
    %找到最小和最大适应度的染色体及它们在种群中的位置
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [worestfitness,worestindex]=max(individuals.fitness);
    
    %最优个体更新
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
    
    %记录每一代进化中最好的适应度和平均适应度
    avgfitness=sum(individuals.fitness)/sizepop;
    trace=[trace;avgfitness bestfitness]; 
    FitRecord=[FitRecord;individuals.fitness];
end

%% 把最优初始阀值权值赋予网络预测
% %用遗传算法优化的BP网络进行值预测
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);

net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2;

%% BP网络训练
%网络进化参数
net.trainParam.epochs=100;
net.trainParam.lr=0.01;
%net.trainParam.goal=0.00001;

%网络训练
[net,per2]=train(net,inputn,outputn);

%% BP网络预测
%数据归一化
inputn_test=mapminmax('apply',input_test,inputps);
an=sim(net,inputn_test);
test_simu=mapminmax('reverse',an,outputps);
error=test_simu-output_test;



%% 遗传算法结果分析 
figure(1)

[r c]=size(trace);
plot([1:r]',trace(:,2),'b--');
title(['适应度曲线  ' '终止代数＝' num2str(maxgen)]);
xlabel('进化代数');ylabel('适应度');
legend('平均适应度','最佳适应度');
% disp('适应度                   变量');

%% GA优化BP网络预测结果分析
figure(2)

plot(test_simu,':og')
hold on
plot(output_test,'-*');
legend('预测输出','期望输出')
title('GA优化BP网络预测输出','fontsize',12)
ylabel('函数输出','fontsize',12)
xlabel('样本','fontsize',12)
%预测误差
error=test_simu-output_test;

figure(3)

plot(error,'-*')
title('GA优化BP神经网络预测误差','fontsize',12)
ylabel('误差','fontsize',12)
xlabel('样本','fontsize',12)

figure(4)

plot((test_simu-output_test)./output_test,'-*');
title('GA优化BP神经网络预测误差百分比')

errorsum=sum(abs(error));
disp(errorsum/(length(output_test)));
Footer
