#include<bits/stdc++.h>
#include<cmath>
using namespace std;
const double Pai = 3.141592653;
const double g = 9.794;
const double n = 219;
const double Rou = 1025;
const double RouGang = 7850;

double Volume(double M)
{
	return M / RouGang;
}

double FuLi(double V)
{
	return Rou * g *  V;
}

double FengLi(double S, double V)
{
	return 0.625 * S * V * V;
}

double area(double L, double D)
{
	return L * D;
}

double Gravity(double m)
{
	return m * g;
}

double T[300];
double Sita[300];
double G[300];
double F[300];
double Fai[300];
double M[300];
double L[300];
double V[300];
double FAI[300];
double H[3000];
double D[20000]; 
double x[300];
double y[300];
double h = 1;
double fengli;
double HH[100]={0,1.456,	1.461,	1.466,	1.471,	1.477,	1.482,	1.487,	1.492,	1.498,	1.503,	1.509,	1.514,	1.519,	1.524,	1.529,	1.534,	1.539,	1.545,	1.55,	1.555,	1.56,	1.566,	1.571,	1.576,	1.581,	1.587,	1.592,	1.597,	1.602,	1.608,	1.613,	1.618,	1.623,	1.628,	1.634,	1.639,	1.644,	1.649,	1.655,	1.66,	1.665,	1.67,	1.675,	1.681,	1.686,	1.691,	1.696,	1.702,	1.707,	1.712};
int main()
{
	
	double v = 36;
	double FuBiao = 1000;//浮标的质量
	double GangGuan = 10;//钢管的质量
	double GangTong = 100;//钢桶的质量
	double MaoLian = 7 * 0.105; //锚链的质量 

	for(int i=1;i<n;i++)
	{
		if(i>=1&&i<=6)
		{
			L[i]=1;
		}
		else if(i==7)
		{
			L[i]=0;
		}
		else{
			L[i]=0.105;
		}
	} 
	int o=1;
	for(int ww=4020;ww<=5000;ww=ww+20)
	
	{
	double Qiu = ww;//钢球的质量
	for (int i = 1; i < n; i++)//赋值质量
	{
		if (i == 1)
			M[i] = FuBiao;
		else if (i >= 2 && i <= 5)
		{
			M[i] = GangGuan;
		}
		else if (i == 6)
		{
			M[i] = GangTong;
		}
		else if (i == 7)
		{
			M[i] = Qiu;
		}
		else
		{
			M[i] = MaoLian;
		}
	}

	for (int i = 1; i < n; i++)//计算重力
	{
		G[i] = Gravity(M[i]);
	}

	for (int i = 2; i < n; i++) //计算体积和浮力
	{
		if (i >= 2 && i <= 5)
		{
			V[i] = 0.025*0.025*Pai;
			F[i] = FuLi(V[i]);
		}
		else if (i == 6)
		{
			V[i] = 0.15*0.15*Pai;
			F[i] = FuLi(V[i]);
		}
		else if (i == 7)
		{
			V[i] = Volume(M[i]);
			F[i] = FuLi(V[i]);
		}
		else
		{
			V[i] = Volume(M[i]);
			F[i] = FuLi(V[i]);
		}
	}
	int W=1;
	//for (double i = 0.3; i <= 2; i += 0.001) 
//	{
		double i=HH[o];
		V[1] = i * Pai;
		F[1] = FuLi(V[1]);
		double mianji = (2 - i) * 2;
		fengli = FengLi(mianji, v);
		double r=(F[1] - G[1]) / fengli;
		Sita[1] =atan((F[1] - G[1]) / fengli);
		T[1] = fengli / cos(Sita[1]);
		Sita[2]=Sita[1];
		T[2]=T[1];
		
		for (int j = 2; j <= 5; j++)
		{
			Sita[j + 1] = atan((T[j] * sin(Sita[j]) - G[j] + F[j]) / (T[j] * cos(Sita[j])));
			T[j + 1] = (T[j] * cos(Sita[j])) / cos(Sita[j + 1]);
 			Fai[j] = atan((2 * T[j]*sin(Sita[j])-G[j]+F[j])/(2*T[j]*cos(Sita[j])));
 			if(Fai[j]<0) Fai[j]=0; 
		}
		
		Sita[7] = atan((T[6] * sin(Sita[6])-G[7]-G[6]+F[7]+F[6])/(T[6]*cos(Sita[6])));
		T[7] = (T[6] * cos(Sita[6])) / cos(Sita[7]);
		Fai[6] = atan((2 * T[6] * sin(Sita[6])-G[6]+F[6]) / (2 * T[6] * cos(Sita[6])));
		if(Fai[6]<0) Fai[6]=0; 
		Sita[8]=Sita[7];
		T[8]=T[7];
		
		for (int j = 8; j <= 217; j++)
		{
			Sita[j + 1] = atan((T[j] * sin(Sita[j]) - G[j] + F[j]) / (T[j] * cos(Sita[j])));
			T[j + 1] = (T[j] * cos(Sita[j])) / cos(Sita[j + 1]);
			Fai[j] = atan((2 * T[j]*sin(Sita[j])-G[j]+F[j])/(2*T[j]*cos(Sita[j])));
			if(Fai[j]<0) Fai[j]=0; 
		}
		
		double X=0;
		for(int j=217;j>1;j--)
		{
			if(j==7) X=X; 
			else X+=sin(Fai[j])*L[j];
		}
		X=X+i;
		H[W]=X;
		W++; 
		o++;
//	}
/*	
	for (double i = 0.697; i <0.6971; i += 0.0001) 
	{
		V[1] = i * Pai;
		F[1] = FuLi(V[1]);
		double mianji = (2 - i) * 2;
		fengli = FengLi(mianji, v);
		double r=(F[1] - G[1]) / fengli;
		Sita[1] =atan((F[1] - G[1]) / fengli);
		T[1] = fengli / cos(Sita[1]);
		Sita[2]=Sita[1];
		T[2]=T[1];
		
		for (int j = 2; j <= 5; j++)
		{
			Sita[j + 1] = atan((T[j] * sin(Sita[j]) - G[j] + F[j]) / (T[j] * cos(Sita[j])));
			T[j + 1] = (T[j] * cos(Sita[j])) / cos(Sita[j + 1]);
 			Fai[j] = atan((2 * T[j]*sin(Sita[j])-G[j]+F[j])/(2*T[j]*cos(Sita[j])));
 			if(Fai[j]<0) Fai[j]=0;
		}
		
		Sita[7] = atan((T[6] * sin(Sita[6])-G[7]-G[6]+F[7]+F[6])/(T[6]*cos(Sita[6])));
		T[7] = (T[6] * cos(Sita[6])) / cos(Sita[7]);
		Fai[6] = atan((2 * T[6] * sin(Sita[6])-G[6]+F[6]) / (2 * T[6] * cos(Sita[6])));
		if(Fai[6]<0) Fai[6]=0;
		Sita[8]=Sita[7];
		T[8]=T[7];
		
		for (int j = 8; j <= 217; j++)
		{
			Sita[j + 1] = atan((T[j] * sin(Sita[j]) - G[j] + F[j]) / (T[j] * cos(Sita[j])));
			T[j + 1] = (T[j] * cos(Sita[j])) / cos(Sita[j + 1]);
			Fai[j] = atan((2 * T[j]*sin(Sita[j])-G[j]+F[j])/(2*T[j]*cos(Sita[j])));
			if(Fai[j]<0) Fai[j]=0;
		}
		
		double X=0;
		for(int j=217,k=1;j>1;j--,k++)
		{
			if(j!=7)
			{
				double X,Y;
				X=x[k-1];
				Y=y[k-1];
				X+=L[j]*cos(Fai[j]);
				Y+=L[j]*sin(Fai[j]);
				x[k]=X;
				y[k]=Y;
			}
			else {
				x[k]=x[k-1];
				y[k]=y[k-1];
			};
			
		}
	}
	*/
	//cout<<"海水高度随浮标浸没高度变化：";
//	for(int i=1;i<W;i++)
//		cout<<H[i]<<" ";
//	cout<<endl;
//	cout<<endl;
//	cout<<"Fai：";
//	for(int i=1;i<n;i++)
		cout<<90-Fai[6]*180/Pai<<" "<<Fai[217]*180/Pai;
/*	cout<<endl;
	cout<<endl;
	cout<<"X:";
	for(int i=1;i<=217;i++)
		cout<<x[i]<<" ";
	cout<<endl;
	cout<<endl;
	cout<<"Y:";
	for(int i=1;i<=217;i++)
		cout<<y[i]<<" ";*/
	cout<<endl;
	cout<<endl;
}
int mmm;
cin>>mmm; 
}
