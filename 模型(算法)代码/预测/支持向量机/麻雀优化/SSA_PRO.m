%改进1，对待初始化进行改进：使用logistic混沌映射进行初始化
%改进2，对边界处理
%改进3，对位置更新的处理

function [c,g]=SSA_PRO(inputs,outputs)

dim=2; %自变量个数
dmaxgenatrix=200;   % 进化次数  
dsizepopx=100;   %种群规模
dSTpx=0.8;       %安全值
P_percent = 0.2;    % %发现者的麻雀所占比重
SD=0.2;% %危险者的麻雀所占比重
popmax=[100,1000];
dpopmin=[0.00000001,0.000000001];

pNum = round( dsizepopx *  P_percent );    % The population size of the producers   
sNum = round(dsizepopx  *  SD);%危险者数量


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化
dppopdfsgh(1,:)=rand(1,dim);%.*(popmax-dpopmin);
miu=4;%3.75<miu<4.00
for i=1:dsizepopx-1
    dppopdfsgh(i+1,:)=miu*dppopdfsgh(i,:).*(1-dppopdfsgh(i,:));
end

for i=1:dim
    dppopdfsgh(:,i)=dpopmin(i)+dppopdfsgh(:,i).*(popmax(i)-dpopmin(i));
end
for i=1:dsizepopx
    tTfitnessdgf(i)=fun(dppopdfsgh(i,:),inputs,outputs); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算麻雀种群最优位置
pFit = tTfitnessdgf;                      
[ fMin, bestI ] = min( tTfitnessdgf );      % fMin denotes the global optimum tTfitnessdgf value
bestX = dppopdfsgh( bestI, : );             % 最优值位置
ppop=dppopdfsgh;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%麻雀搜索算法 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for tTTgh = 1 : dmaxgenatrix 
  [ ans, sortIndex ] = sort( pFit );% Sort.
  [fmax,B]=max( pFit );
   worse= dppopdfsgh(B,:);      
   r2=rand(1);
%发现者
if(r2<dSTpx)
    for i = 1 : pNum                                                   % Equation (3)
        r1=rand(1);
        dppopdfsgh( sortIndex( i ), : ) = dppopdfsgh( sortIndex( i ), : )*exp(-(i)/(r1*dmaxgenatrix));
        %边界判断
        for nn=1:dim
            max_flag=dppopdfsgh(sortIndex( i ), nn )>popmax(nn);
            min_flag=dppopdfsgh(sortIndex( i ), nn )<dpopmin(nn);
            if(max_flag || min_flag)
                 dppopdfsgh( sortIndex( i ), nn )=popmax(nn)-(popmax(nn)-dpopmin(nn))*rand;
            end
        end
        %计算更新位置后的麻雀适应度
        tTfitnessdgf(sortIndex( i ))=fun(dppopdfsgh(sortIndex( i ),:),inputs,outputs); 
    end
  else
  for i = 1 : pNum         
        dppopdfsgh( sortIndex( i ), : ) = dppopdfsgh( sortIndex( i ), : )+randn(1)*ones(1,dim);
        for nn=1:dim
            max_flag=dppopdfsgh(sortIndex( i ), nn )>popmax(nn);
            min_flag=dppopdfsgh(sortIndex( i ), nn )<dpopmin(nn);
            if(max_flag || min_flag)
                 dppopdfsgh( sortIndex( i ), nn )=popmax(nn)-(popmax(nn)-dpopmin(nn))*rand;
            end
        end
        %计算更新位置后的麻雀适应度
        tTfitnessdgf(sortIndex( i ))=fun(dppopdfsgh(sortIndex( i ),:),inputs,outputs);   
  end      
end


[ fMMin, bestII ] = min( tTfitnessdgf );      
bestXX = dppopdfsgh( bestII, : ); 

%跟随者
for i = ( pNum + 1 ) : dsizepopx% Equation (4)
    A=floor(rand(1,dim)*2)*2-1;
    pop_old=dppopdfsgh( sortIndex(i ), : );
    if( i>(dsizepopx/2))
        dppopdfsgh( sortIndex(i ), : )=randn(1)*exp((worse-dppopdfsgh( sortIndex( i ), : ))/(i)^2);
    else
        dppopdfsgh( sortIndex( i ), : )=bestXX+(abs(( dppopdfsgh( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);  
    end  
        %边界判断
        for nn=1:dim
            max_flag=dppopdfsgh(sortIndex( i ), nn )>popmax(nn);
            min_flag=dppopdfsgh(sortIndex( i ), nn )<dpopmin(nn);
            if(max_flag)
                dppopdfsgh(sortIndex( i ), nn )=bestXX(nn)+abs(bestXX(nn)-popmax(nn))*abs(pop_old(nn)-popmax(nn))/abs(dppopdfsgh(sortIndex( i ), nn )-pop_old(nn));
            else 
                if(min_flag)
                    dppopdfsgh(sortIndex( i ), nn )=bestXX(nn)-abs(bestXX(nn)-dpopmin(nn)).*abs(pop_old(nn)-dpopmin(nn))/abs(dppopdfsgh(sortIndex( i ), nn )-pop_old(nn));
                end
            end
        end
        %计算更新位置后的麻雀适应度
        tTfitnessdgf(sortIndex( i ))=fun(dppopdfsgh(sortIndex( i ),:),inputs,outputs);      
end
%警戒者  
c=randperm(numel(sortIndex));
b=sortIndex(c(1:sNum));   
for j =  1  : length(b)% Equation (5)
    if( pFit( sortIndex( b(j) ) )>(fMin) )
        dppopdfsgh( sortIndex( b(j) ), : )=bestX+(randn(1,dim)).*(abs(( dppopdfsgh( sortIndex( b(j) ), : ) -bestX)));
    else
         dppopdfsgh( sortIndex( b(j) ), : ) =dppopdfsgh( sortIndex( b(j) ), : )+(2*rand(1)-1)*(abs(dppopdfsgh( sortIndex( b(j) ), : )-worse))/ ( pFit( sortIndex( b(j) ) )-fmax+1e-50);
    end 
        %边界判断
        for nn=1:dim
            max_flag=dppopdfsgh(sortIndex( b(j) ), nn )>popmax(nn);
            min_flag=dppopdfsgh(sortIndex( b(j) ), nn )<dpopmin(nn);
            if(max_flag || min_flag)
                 dppopdfsgh( sortIndex( b(j) ), nn )=dpopmin(nn)+(popmax(nn)-dpopmin(nn))*rand;
            end
        end
        %计算更新位置后的麻雀适应度
       tTfitnessdgf(sortIndex( b(j) ))=fun(dppopdfsgh(sortIndex( b(j) ),:),inputs,outputs);
 end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i = 1 : dsizepopx 
        if ( tTfitnessdgf( i ) < pFit( i ) )
            pFit( i ) = tTfitnessdgf( i );
            ppop(i,:) = dppopdfsgh(i,:);
        end
       
   end 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   LaimTa_1=1-tTTgh/dmaxgenatrix;
   LaimTa_2=tTTgh/dmaxgenatrix;
   if min(pFit)<min(tTfitnessdgf)
        tTfitSigMaf=1;
   else
        tTfitSigMaf=exp((min(pFit)-min(tTfitnessdgf))/abs(min(pFit)));
   end
   %柯西高斯扰乱
   [ ans_R, sortIndex_R ] = sort( pFit );
   a=0; b=tTfitSigMaf^2;
   for nub=1:round(dsizepopx/10)
        %柯西分布
        Cauchy=a+b*tan(pi*(rand(1,dim)-0.5))./80;
        Goas=normrnd(0,tTfitSigMaf^2,1,dim)./80;
        AAAA=(1+LaimTa_1.*Cauchy+LaimTa_2.*Goas);
        %经过柯西-高斯扰乱后
        Nbest=ppop(sortIndex_R(nub)).*(1+LaimTa_1.*Cauchy+LaimTa_2.*Goas);
        for nn=1:dim
        max_flag=Nbest(nn)>popmax(nn);
        min_flag=Nbest(nn)<dpopmin(nn);
        if(max_flag || min_flag)
            Nbest(nn)=ppop(sortIndex_R(i),nn)+0.05*ppop(sortIndex_R(i),nn)*(1-2*rand);
            if Nbest(nn)>popmax(nn) || Nbest(nn)<dpopmin(nn)
                Nbest(nn)=ppop(sortIndex_R(i),nn);
            end
        end
        end
        newFitness=fun(Nbest,inputs,outputs);
        %更新位置
        if newFitness<pFit(sortIndex_R(nub))
            ppop(sortIndex_R(nub),:)=Nbest;
            pFit(sortIndex_R(nub))=newFitness;
        end
   end
   [fMin,Ind]=min(pFit);
   bestX=ppop(Ind,:);
   yy(tTTgh)=fMin;
   dppopdfsgh=ppop;
   %figure('Name','适应度变化')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 迭代寻优   
figure(1)
plot(yy,'LineWidth',1);
x=bestX
fMin
c=bestX(1);
g=bestX(2);