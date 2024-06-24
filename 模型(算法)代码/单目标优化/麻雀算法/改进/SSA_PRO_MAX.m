%改进1，对待初始化进行改进：使用logistic混沌映射进行初始化
%改进2，对边界处理
%改进3，对位置更新的处理

clc,clear;
%求最小值


dim=2; %自变量个数
maxgen=500;   % 进化次数  
sizepop=200;   %种群规模
ST=0.8;       %安全值
P_percent = 0.2;    % %发现者的麻雀所占比重
SD=0.2;% %危险者的麻雀所占比重
popmax=[500 500];
popmin=[-500 -500];

pNum = round( sizepop *  P_percent );    % The population size of the producers   
sNum = round(sizepop  *  SD);%危险者数量


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化
pop(1,:)=rand(1,dim);%.*(popmax-popmin);
miu=4;%3.75<miu<4.00
for i=1:sizepop-1
    pop(i+1,:)=miu*pop(i,:).*(1-pop(i,:));
end

for i=1:dim
    pop(:,i)=popmin(i)+pop(:,i).*(popmax(i)-popmin(i));
end
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
%发现者
if(r2<ST)
    for i = 1 : pNum                                                   % Equation (3)
        r1=rand(1);
        pop( sortIndex( i ), : ) = pop( sortIndex( i ), : )*exp(-(i)/(r1*maxgen));
        %边界判断
        for nn=1:dim
            max_flag=pop(sortIndex( i ), nn )>popmax(nn);
            min_flag=pop(sortIndex( i ), nn )<popmin(nn);
            if(max_flag || min_flag)
                 pop( sortIndex( i ), nn )=popmax(nn)-(popmax(nn)-popmin(nn))*rand;
            end
        end
        %计算更新位置后的麻雀适应度
        fitness(sortIndex( i ))=fun(pop(sortIndex( i ),:)); 
    end
  else
  for i = 1 : pNum         
        pop( sortIndex( i ), : ) = pop( sortIndex( i ), : )+randn(1)*ones(1,dim);
        for nn=1:dim
            max_flag=pop(sortIndex( i ), nn )>popmax(nn);
            min_flag=pop(sortIndex( i ), nn )<popmin(nn);
            if(max_flag || min_flag)
                 pop( sortIndex( i ), nn )=popmax(nn)-(popmax(nn)-popmin(nn))*rand;
            end
        end
        %计算更新位置后的麻雀适应度
        fitness(sortIndex( i ))=fun(pop(sortIndex( i ),:));   
  end      
end


[ fMMin, bestII ] = min( fitness );      
bestXX = pop( bestII, : ); 

%跟随者
for i = ( pNum + 1 ) : sizepop% Equation (4)
    A=floor(rand(1,dim)*2)*2-1;
    pop_old=pop( sortIndex(i ), : );
    if( i>(sizepop/2))
        pop( sortIndex(i ), : )=randn(1)*exp((worse-pop( sortIndex( i ), : ))/(i)^2);
    else
        pop( sortIndex( i ), : )=bestXX+(abs(( pop( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);  
    end  
        %边界判断
        for nn=1:dim
            max_flag=pop(sortIndex( i ), nn )>popmax(nn);
            min_flag=pop(sortIndex( i ), nn )<popmin(nn);
            if(max_flag)
                pop(sortIndex( i ), nn )=bestXX(nn)+abs(bestXX(nn)-popmax(nn))*abs(pop_old(nn)-popmax(nn))/abs(pop(sortIndex( i ), nn )-pop_old(nn));
            else 
                if(min_flag)
                    pop(sortIndex( i ), nn )=bestXX(nn)-abs(bestXX(nn)-popmin(nn)).*abs(pop_old(nn)-popmin(nn))/abs(pop(sortIndex( i ), nn )-pop_old(nn));
                end
            end
        end
        %计算更新位置后的麻雀适应度
        fitness(sortIndex( i ))=fun(pop(sortIndex( i ),:));      
end
%警戒者  
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
            if(max_flag || min_flag)
                 pop( sortIndex( b(j) ), nn )=popmin(nn)+(popmax(nn)-popmin(nn))*rand;
            end
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
       
   end 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   LaimTa_1=1-t/maxgen;
   LaimTa_2=t/maxgen;
   if min(pFit)<min(fitness)
        SigMa=1;
   else
        SigMa=exp((min(pFit)-min(fitness))/abs(min(pFit)));
   end
   %柯西高斯扰乱
   [ ans_R, sortIndex_R ] = sort( pFit );
   a=0; b=SigMa^2;
   for nub=1:round(sizepop/10)
        %柯西分布
        Cauchy=a+b*tan(pi*(rand(1,dim)-0.5))./80;
        Goas=normrnd(0,SigMa^2,1,dim)./80;
        AAAA=(1+LaimTa_1.*Cauchy+LaimTa_2.*Goas);
        %经过柯西-高斯扰乱后
        Nbest=ppop(sortIndex_R(nub)).*(1+LaimTa_1.*Cauchy+LaimTa_2.*Goas);
        for nn=1:dim
        max_flag=Nbest(nn)>popmax(nn);
        min_flag=Nbest(nn)<popmin(nn);
        if(max_flag || min_flag)
            Nbest(nn)=ppop(sortIndex_R(i),nn)+0.05*ppop(sortIndex_R(i),nn)*(1-2*rand);
            if Nbest(nn)>popmax(nn) || Nbest(nn)<popmin(nn)
                Nbest(nn)=ppop(sortIndex_R(i),nn);
            end
        end
        end
        newFitness=fun(Nbest);
        %更新位置
        if newFitness<pFit(sortIndex_R(nub))
            ppop(sortIndex_R(nub),:)=Nbest;
            pFit(sortIndex_R(nub))=newFitness;
        end
   end
   [fMin,Ind]=min(pFit);
   bestX=ppop(Ind,:);
   yy(t)=fMin;
   pop=ppop;
   %figure('Name','适应度变化')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 迭代寻优   
figure(1)
plot(yy,'LineWidth',1);
x=bestX
fMin