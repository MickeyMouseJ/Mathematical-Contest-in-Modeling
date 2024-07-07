
h=1.87775
gangqiu=3902
maolian_l=143
maolian_g=28.12
maolian_L=0.18
a=0.1047  %游动距离
b=0.2583  %角度
c=0.6370  %h

hh=20
esp=1
v=36
vv=1.5
Pai=3.141592653
g=9.794
n=maolian_l+7 %总数量
FuBiao=1000
GangTong=100
GangGuan=10
Rou=1025
Rou_Gang=7850

Volume=@(M)  M/Rou_Gang
FuLi=@(V)  Rou*g*V
FengLi=@(S,V) 0.625 * S * V * V;

%L为每个物体的长度
for i=1:n
    if(i<=6)
        L(i)=1
    elseif(i==7)
            L(i)=0 
    else 
        L(i)=maolian_L
    end
end

for i=1:n
        if i==1
            M(i)=FuBiao
            G(i)=M(i)*g
            V(i)=h*Pai
            F(i)=FuLi(V(i))
        elseif i>=2 && i<=5
             M(i)=GangGuan
             G(i)=M(i)*g
             V(i)=0.025*0.025*Pai
             F(i)=FuLi(V(i))
        elseif i==6
            M(i)=GangTong
            G(i)=M(i)*g
            V(i)=0.15*0.15*Pai
            F(i)=FuLi(V(i))
        elseif i==7
             M(i)=gangqiu
             G(i)=M(i)*g
             V(i)=Volume(M(i))
             F(i)=FuLi(V(i))
        else   
            M(i)=maolian_L*maolian_g
            G(i)=M(i)*g
            V(i)=Volume(M(i))
            F(i)=FuLi(V(i))
        end
end

mianji=(2-h)*2
fengli=FengLi(mianji,v)
Sita(1)=atan((F(1)-G(1))/(fengli+374*vv*vv*2*h))
T(1)=(F(1)-G(1))/sin(Sita(1))
Sita(2)=Sita(1)
T(2)=T(1)

for j=2:5
    Sita(j + 1) = atan((T(j) * sin(Sita(j)) - G(j) + F(j)) / (T(j) * cos(Sita(j))+374*vv*vv*0.05));
	T(j + 1) = (T(j) * sin(Sita(j))+F(j)-G(j)) / sin(Sita(j + 1));
 	Fai(j) = atan((2 * T(j)*sin(Sita(j))-G(j)+F(j))/(2*T(j)*cos(Sita(j))));
 	if Fai(j)<0
        Fai(j)=0;
    end
    j=j+1
end

Sita(7) = atan((T(6) * sin(Sita(6))-G(7)-G(6)+F(7)+F(6))/(T(6)*cos(Sita(6))+374*vv*vv*0.3));
T(7) = (T(6) * cos(Sita(6))-G(7)-G(6)+F(7)+F(6)) / sin(Sita(7));
Fai(6) = atan((2 * T(6) * sin(Sita(6))-G(6)+F(6)) / (2 * T(6) * cos(Sita(6))));
if Fai(6)<0 
    Fai(6)=0;
end
Sita(8)=Sita(7);
T(8)=T(7);
		
for j=8:n
	Sita(j + 1) = atan((T(j) * sin(Sita(j)) - G(j) + F(j)) / (T(j) * cos(Sita(j))));
	T(j + 1) = (T(j) * cos(Sita(j))) / cos(Sita(j + 1));
	Fai(j) = atan((2 * T(j)*sin(Sita(j))-G(j)+F(j))/(2*T(j)*cos(Sita(j))));
% 	if Fai(j)<0
%         Fai(j)=0;
%     end
    j=j+1
end

H=L*sin(Fai')+h
D=L*cos(Fai')
if ((H-hh<=esp) && (H-hh>-esp)) && Fai(n)<=0.28 && (Pai/2-Fai(6))<0.078
    y=a*D+b*(Pai/2-Fai(6))+c*h
else
    y=inf
end