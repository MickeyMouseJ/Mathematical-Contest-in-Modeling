clc,clear;
close all;
%求最小值

dim=1; %自变量个数
maxgen=500;   % 进化次数  
sizepop=10;   %种群规模
ST=0.8;       %安全值
P_percent = 0.2;    % %发现者的麻雀所占比重
SD=0.2;              % %危险者的麻雀所占比重
popmax=[100];%变量上届
popmin=[0.0001];%变量下届


pNum = round( sizepop *  P_percent );    % The population size of the producers   
sNum = round(sizepop  *  SD);%危险者数量


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化
pop=popmin+rand(sizepop,dim).*(popmax-popmin);

for i=1:sizepop
    fitness(i)=fun(pop(i,:)); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算麻雀种群最优位置
pFit = fitness;                      
[ fMin, bestI ] = min( fitness );      % fMin denotes the global optimum fitness value
bestX = pop( bestI, : );             % 最优值位置
ppop=pop;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%麻雀搜索算法 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 1 : maxgen 
  [ ans, sortIndex ] = sort( pFit );% Sort.
  [fmax,B]=max( pFit );
   worse= pop(B,:);      
   r2=rand(1);
if(r2<ST)
    for i = 1 : pNum                                                   % Equation (3)
        r1=rand(1);
        pop( sortIndex( i ), : ) = pop( sortIndex( i ), : )*exp(-(i)/(r1*maxgen));
        %边界判断
        for nn=1:dim
            max_flag=pop(sortIndex( i ), nn )>popmax(nn);
            min_flag=pop(sortIndex( i ), nn )<popmin(nn);
            pop(sortIndex( i ), nn )=(pop(sortIndex( i ), nn ).*(~(max_flag+min_flag)))+popmax(nn).*max_flag+popmin(nn).*min_flag;
        end
        %计算更新位置后的麻雀适应度
        fitness(sortIndex( i ))=fun(pop(sortIndex( i ),:)); 
    end
  else
  for i = 1 : pNum         
        pop( sortIndex( i ), : ) = pop( sortIndex( i ), : )+randn(1)*ones(1,dim);
        for nn=1:dim
        %边界判断
            max_flag=pop(sortIndex( i ), nn )>popmax(nn);
            min_flag=pop(sortIndex( i ), nn )<popmin(nn);
            pop(sortIndex( i ), nn )=(pop(sortIndex( i ), nn ).*(~(max_flag+min_flag)))+popmax(nn).*max_flag+popmin(nn).*min_flag;
        end
        %计算更新位置后的麻雀适应度
        fitness(sortIndex( i ))=fun(pop(sortIndex( i ),:));   
  end      
end


[ fMMin, bestII ] = min( fitness );      
bestXX = pop( bestII, : ); 

for i = ( pNum + 1 ) : sizepop% Equation (4)
    A=floor(rand(1,dim)*2)*2-1;
    if( i>(sizepop/2))
        pop( sortIndex(i ), : )=randn(1)*exp((worse-pop( sortIndex( i ), : ))/(i)^2);
    else
        pop( sortIndex( i ), : )=bestXX+(abs(( pop( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);  
    end  
        %边界判断
        for nn=1:dim
            max_flag=pop(sortIndex( i ), nn )>popmax(nn);
            min_flag=pop(sortIndex( i ), nn )<popmin(nn);
            pop(sortIndex( i ), : )=(pop(sortIndex( i ), nn ).*(~(max_flag+min_flag)))+popmax(nn).*max_flag+popmin(nn).*min_flag;
        end
        %计算更新位置后的麻雀适应度
        fitness(sortIndex( i ))=fun(pop(sortIndex( i ),:));      
end
  
    c=randperm(numel(sortIndex));
    b=sortIndex(c(1:sNum));
   
for j =  1  : length(b)% Equation (5)
    if( pFit( sortIndex( b(j) ) )>(fMin) )
        pop( sortIndex( b(j) ), : )=bestX+(randn(1,dim)).*(abs(( pop( sortIndex( b(j) ), : ) -bestX)));
    else
         pop( sortIndex( b(j) ), : ) =pop( sortIndex( b(j) ), : )+(2*rand(1)-1)*(abs(pop( sortIndex( b(j) ), : )-worse))/ ( pFit( sortIndex( b(j) ) )-fmax+1e-50);
    end 
        %边界判断
        for nn=1:dim
            max_flag=pop(sortIndex( b(j) ), nn )>popmax(nn);
            min_flag=pop(sortIndex( b(j) ), nn )<popmin(nn);
            pop(sortIndex( b(j) ), nn )=(pop(sortIndex( b(j) ), nn ).*(~(max_flag+min_flag)))+popmax(nn).*max_flag+popmin(nn).*min_flag;
        end
        %计算更新位置后的麻雀适应度
       fitness(sortIndex( b(j) ))=fun(pop(sortIndex( b(j) ),:));
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i = 1 : sizepop 
        if ( fitness( i ) < pFit( i ) )
            pFit( i ) = fitness( i );
            ppop(i,:) = pop(i,:);
        end
        if( pFit( i ) < fMin )
           fMin= pFit( i );
            bestX =pop( i, : );
        end
   end
   pop=ppop;
   yy(t)=fMin;
   %figure('Name','适应度变化')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 迭代寻优
   figure(1)
   plot(yy,'LineWidth',1);
x=bestX
fMin