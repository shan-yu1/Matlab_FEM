function A=graphe_arete(S,T)               % Grafo de aristas.
ns=size(S,1);nt=size(T,1);A=sparse(ns,ns);
for t=1:nt,
    I=T(t,1);J=T(t,2);K=T(t,3);
    A(I,J)=A(I,J)+1;
    A(J,I)=A(J,I)+1;
    A(I,K)=A(I,K)+1;
    A(K,I)=A(K,I)+1;
    A(J,K)=A(J,K)+1;
    A(K,J)=A(K,J)+1;
end,
