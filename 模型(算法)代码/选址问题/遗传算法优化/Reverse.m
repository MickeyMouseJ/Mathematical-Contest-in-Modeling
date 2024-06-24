%% 进化逆转函数
%输入
%SelCh 被选择的个体
%D     个城市的距离矩阵
%输出
%SelCh  进化逆转后的个体
function SelCh=Reverse(SelCh,D)
[row,col]=size(SelCh);
for i=1:row
    ObjV(i,:)=objective_function(SelCh(i,:));  %计算路径长度
end
SelCh1=SelCh;
for i=1:row
    r1=randsrc(1,1,[1:col]);
    r2=randsrc(1,1,[1:col]);
    mininverse=min([r1 r2]);
    maxinverse=max([r1 r2]);
    SelCh1(i,mininverse:maxinverse)=SelCh1(i,maxinverse:-1:mininverse);
end
for i=1:row
    ObjV1(i,:)=objective_function(SelCh1(i,:));  %计算路径长度
end
index=ObjV1<ObjV;
SelCh(index,:)=SelCh1(index,:);