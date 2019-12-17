function [SF,TF,BRF,RTF]=fusion_triangulation(S1,T1,BR1,RT1,S2,T2,BR2,RT2)
% Busqueda de los nodos coincidentes con una precision eps dada por
% el tamano del dominio / 10000.
xmax=max(max(S1(:,1)),max(S2(:,1)));
xmin=min(min(S1(:,1)),min(S2(:,1)));
ymax=max(max(S1(:,2)),max(S2(:,2)));
ymin=min(min(S1(:,2)),min(S2(:,2)));
eps=max(xmax-xmin,ymax-ymin)/10000.;
% Fabricamos el tablero de aristas.
A1=graphe_arete(S1,T1);
L1=detecte_noeuds_bord(A1);
A2=graphe_arete(S2,T2);
L2=detecte_noeuds_bord(A2);
% Nodos que coinciden. Busqueda por fuerza bruta.
ns1=size(S1,1);ns2=size(S2,1);
nt1=size(T1,1);nt2=size(T2,1);
C=zeros(ns2,1);D=zeros(ns1,1);
for i=1:size(L1,1),
    I=L1(i);
    for j=1:size(L2,1),
        J=L2(j);
        if(norm(S1(I,:)-S2(J,:))<eps)   % Coincidencia.
            C(J)=I;   % Numero J de S2 se convierte en I de S1
            D(I)=J;   % Numero J de S2 se convierte en I de S1
            %break;
        end,
    end,
end,
% Fusion de las triangulaciones.
SF=S1;TF=[T1;T2];
BRF=[BR1;BR2];RTF=[RT1 RT2];
% Renumeracion de la segunda malla.
n2=0;
for i=1:ns2,
    if(C(i)==0) 
        n2=n2+1;C(i)=ns1+n2;
        SF=[SF;S2(i,:)];
    end,
end,
% maj numeracion de triangulos (segunda parte)
for t=1:nt2,
    for i=1:3,
        I=T2(t,i);
        TF(nt1+t,i)=C(I);  
    end,
end,
% Suprimimos las arista de los bordes que ahora son internos.
for t=1:nt1;
    for a=1:3,
        if(BRF(t,a)~=0)
            I=T1(t,a);if(a==3) J=T1(t,1); else J=T1(t,a+1);end,
            if(D(I)~=0 && D(J)~=0) BRF(t,a)=0;end,   % Arista común
        end,
    end,
end,
for t=1:nt2;
    for a=1:3,
        if(BRF(nt1+t,a)~=0)
            I=T2(t,a);if(a==3) J=T2(t,1); else J=T2(t,a+1);end,
            if(C(I)<=ns1 && C(J)<=ns1) BRF(nt1+t,a)=0;end,  % Arista común
        end,
    end,
end,
