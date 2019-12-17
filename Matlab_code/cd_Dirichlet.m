 function [Ae,Be] = cd_Dirichlet(A,B,Noeud_dir,G)
 ns=size(A,1);Ae=A;Be=B;                          % Inicializacion.
 if(nargin==3) 
     G=zeros(ns,1);                               % Condiciones homogeneas.
 else
     Be=B-A*(Noeud_dir.*G);
 end,                                             % Correccion del segundo miembro.
                                                  % por la
                                                  % pseudo-eliminacion.
 for i=1:ns, 
     if(Noeud_dir(i)==1), 
        Ae(i,:)=0;Ae(:,i)=0; 
        Ae(i,i)=A(i,i);Be(i)=A(i,i)*G(i);         % Eliminacion.
     end, 
 end
 