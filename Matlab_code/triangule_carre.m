function [S,T,BR,RT]=triangule_carre(m,n,ref_mat,ref_bord)

% Inicializacion
dx=1./m;dy=1./n;x=0:dx:1.;y=0:dy:1.;
ns=(m+1)*(n+1);nt=2*m*n;
BR=zeros(nt,3);
if(nargin==2) ref_mat=0;ref_bord=[1 2 3 4];end,
if(nargin==3) ref_bord=[1 2 3 4];end,
RT=ref_mat*ones(1,nt);
% Definicion de los vertices.
[X,Y]=meshgrid(x,y);
S=[reshape(X',ns,1) reshape(Y',ns,1)];
% Definicion de la numeracion de triangulos.
N1=[];N2=[];mp=m+1;
% Linea de division de tipo 1.
for i=1:m
    if(mod(i,2)==1)  %i impar
        N1=[N1 i i+1 mp+i i+1+mp i+mp i+1];
    else             %i par
        N1=[N1 i+1 i+1+mp i i+mp i i+1+mp];
    end,
end,
N1=reshape(N1,3,2*m)';
% Linea de division de tipo 2.
for i=1:m
    if(mod(i,2)==1)  %i impar
        N2=[N2 i+1 i+1+mp i i+mp i i+1+mp];
    else             %i par
        N2=[N2 i i+1 mp+i i+1+mp i+mp i+1];
    end,
end,
N2=reshape(N2,3,2*m)';
% Mallado alternando las lineas 1 y 2 (translacion y numeracion).
T=[];
for j=1:n
    if(mod(j,2)==1) T=[T;N1+(j-1)*mp];
    else T=[T;N2+(j-1)*mp];
    end,
end,
% Numeracion de los bordes.
% Bordes de arriba y abajo (1 3)
p=2*(n-1)*m+1;
p1=ref_bord(3);p2=0;if(mod(n,2)==0) p2=ref_bord(3);p1=0;end,
for i=1:4:2*m,
    BR(i,:)=[ref_bord(1) 0 0];
    if(i+2<=2*m) BR(i+2,:)=[0 0 ref_bord(1)]; end,
    BR(p+i,:)=[p1 0 p2];
    if(p+i+2<=nt) BR(p+i+2,:)=[p2 0 p1];end,
end,
% Bordes de izquierda y derecha (4 2)
t=2*m+1;r=2*(n-1)*m+2;
s=2*(m-mod(m,2))+1;q=2*m-2+mod(m,2);
q1=ref_bord(2);q2=0;if(mod(m,2)==0) q2=ref_bord(2);q1=0;end,
for i=1:4*m:2*(n-1)*m+1,
    BR(i,:)=BR(i,:)+[0 0 ref_bord(4)];
    if(i+t<=r) BR(i+t,:)=BR(i+t,:)+[ref_bord(4) 0 0];end,
    BR(q+i,:)=BR(q+i,:)+[q2 0 q1];
    if(q+i+s<=nt) BR(q+i+s,:)=BR(q+i+s,:)+[q1 0 q2];end,
end,
