function [T_s,S_s]=renume(T,S)
% Tamanos diversos.
nt=size(T,1);ns=size(S,1);q=size(T,2); 
% Matriz del grafo de conexiones.
G=sparse(ns,ns);
for t=1:nt,
    for i=1:q,
        I=T(t,i);
        for j=1:q,
            J=T(t,j);
            G(I,J)=1;
        end,
    end, 
end,
% Optimizacion de la numeracion (reverse Cuthill-Mackee)
R = symrcm(G);
% Renumeracion de los nodos.
S_s=S(R,:);
T_s=zeros(size(T));
Rm=zeros(ns,1);
% Permutacion inversa de R.
for n=1:ns,
    Rm(R(n))=n;
end,
% Renumeracion de los triangulos.
for t=1:nt,
    for i=1:q,
        T_s(t,i)=Rm(T(t,i));
    end,
end,
