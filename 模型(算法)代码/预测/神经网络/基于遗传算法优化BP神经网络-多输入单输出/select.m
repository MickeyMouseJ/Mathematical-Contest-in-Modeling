function ret=select(individuals,sizepop)
% 本函数对每一代种群中的染色体进行选择，以进行后面的交叉和变异
% individuals input  : 种群信息
% sizepop     input  : 种群规模
% ret         output : 经过选择后的种群

%求适应度值倒数
fitness1=10./individuals.fitness;   %individuals.fitness为个体适应度值
%个体选择概率
sumfitness=sum(fitness1,2);
sumf=fitness1./sumfitness;
[m,n]=size(sumf)

%采用轮盘赌法选择新个体
index=[]; 
for k=1:m
    w=1
    for i=1:sizepop   %转sizepop次轮盘
      pick=rand;
      while pick==0    
          pick=rand;        
       end
      for j=1:sizepop    
         pick=pick-sumf(k,j);        
            if pick<0   
                if w==1
                    index(k,w)=j
                    w=w+1
                    break
                else
                     index(k,w)=j;            
                     w=w+1
                     break;  %寻找落入的区间，此次转轮盘选中了染色体i，注意：在转sizepop次轮盘的过程中，有可能会重复选择某些染色体
                end
            end
        end
    end
end
%新种群
individuals.chrom=individuals.chrom(index,:);

for i=1:m
    for j=1:n
    individuals.fitness(i,j)=individuals.fitness(i,index(i,j));
    end
end
ret=individuals;
