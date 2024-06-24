function D=Distanse(a)
load("lianjie.mat")
X=lianjie
row=size(a,1);
D=zeros(row,row);
X_row=size(X,1)
for i=1:X_row
    if  X(i,1)<=92 && X(i,2)<=92
    D(X(i,1),X(i,2))=((a(X(i,1),1)-a(X(i,2),1))^2+(a(X(i,1),2)-a(X(i,2),2))^2)^0.5;
    D(X(i,2),X(i,1))=D(X(i,1),X(i,2))
    end
end

D(D==0)=inf
D=D-diag(diag(D));