clear clc

N = 1000;                         % 初始种群个数  
d = 3;                          % 可行解维数  
ger = 100; % 最大迭代次数     

G=28.12
L=0.18

% 设置位置参数限制
limit_h = [1,2];%浮标浸没在海水中的深度的限制   
limit_g=[1500,6000]%重球的质量限制
limit_l=[80,300]%锚链的段数15/P,35/P

vlimit1 = [-0.001, 0.001];               % 设置速度限制
vlimit2=[-5,5]
vlimit3 = [-2,2]



w = 0.5;                        % 惯性权重  
c1 = 0.6;                       % 自我学习因子  
c2 = 0.3;                       % 群体学习因子   
x=zeros(N,d);
x(:,1) = limit_h(1) + (  limit_h( 2 ) -  limit_h( 1)  ) * rand(N, 1);%初始种群的位置  
x(:,2)= limit_g(1) + (  limit_g( 2 ) -  limit_g( 1)  ) * rand(N, 1);
x(:,3)=ceil(limit_l(1) + (  limit_l( 2 ) -  limit_l( 1)  ) * rand(N, 1))

% 初始种群的速度
v = rand(N, d-1);
v(:,3)=ceil( vlimit3(1) + (  vlimit3( 2 ) -  vlimit3( 1)  ) * rand(N, 1));%锚链的初始速度为1：100

xm = x;                          % 每个个体的历史最佳位置  
ym = zeros(1, d);                % 种群的历史最佳位置  
fxm = ones(N, 1)*inf;               % 每个个体的历史最佳适应度   
fym = inf;                       % 种群历史最佳适应度  

%iter = 1;  
% record = zeros(ger, 1);          % 记录器  
iter = 1;  
% record = zeros(ger, 1);          % 记录器  
while iter <= ger 
    for i=1:N
        fx(i) = f( x(i,1),x(i,2),x(i,3),G,L ) ;% 个体当前适应度   
    end

     for i = 1:N        
        if  fx(i)  <fxm(i) 
            fxm(i) = fx(i);     % 更新个体历史最佳适应度  
            xm(i,:) = x(i,:);   % 更新个体历史最佳位置(取值)  
        end   
     end  
    if   min(fxm)<  fym
        [fym, nmin] = min(fxm);   % 更新群体历史最佳适应度  
        ym = xm(nmin, :);      % 更新群体历史最佳位置  
    end  
    v(:,1) = v(:,1) * w + c1 * rand * (xm(:,1) - x(:,1)) + c2 * rand * (repmat(ym(1), 1, 1) - x(:,1));% 速度更新  
    v(:,2)=v(:,2) * w + c1 * rand * (xm(:,2) - x(:,2)) + c2 * rand * (repmat(ym(2), 1, 1) - x(:,2));% 速度更新
    v(:,2)=ceil(v(:,3) * w + c1 * rand * (xm(:,3) - x(:,3)) + c2 * rand * (repmat(ym(3), 1, 1) - x(:,3)));% 速度更新
    % 边界速度处理  
    v(v(:,1) > vlimit1(2)) = vlimit1(2);  %对h速度的范围限定
    v(v(:,1) < vlimit1(1)) = vlimit1(1);

    v(v(:,2) > vlimit2(2)) = vlimit2(2);  %对g速度的范围限定
    v(v(:,2) < vlimit2(1)) = vlimit2(1);

    v(v(:,3) > vlimit3(2)) = vlimit3(2);  %对g速度的范围限定
    v(v(:,3) < vlimit3(1)) = vlimit3(1);
    x = x + v;% 位置更新  
    % 边界位置处理  
    x(x(:,1) > limit_h(2),1) = limit_h(2)-0.2;  
    x(x(:,1)< limit_h(1),1) = limit_h(1)+0.5;

    x(x(:,2) > limit_g(2),2) = limit_g(2);  
    x(x(:,2)< limit_g(1),2) = limit_g(1);

    x(x(:,3) > limit_l(2),3) = limit_l(2);  
    x(x(:,3)< limit_l(1),3) = limit_l(1);
    
    record(iter) = fym;%最大值记录  
    subplot(2,1,1)
    plot3(ym(1),ym(2),0.18*ym(3),'.','MarkerSize',8)
    xlabel("浸没深度")
    ylabel("重物球质量")
    zlabel("锚链长度")
    title(['状态位置变化','-迭代次数：',num2str(iter)])
    subplot(2,1,2);plot(record);title('最优适应度进化过程')  
    pause(0.01)  
    iter = iter+1; 

end  
