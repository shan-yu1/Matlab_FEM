function [M]=calcul_EF_1D(S,T,BR,ref_bord)
 pts_quadS=[0 1/2 1];                               % Cuadratura en 1D.
 pds_quadS=[1/6 4/6 1/6]; 
 nt=size(T,1);ns=size(S,1);q=size(T,2);             % Inicializacion.
 nbq=length(pds_quadS);     
 M=sparse(ns,ns);                                                          
 % Bucle sobre las aristas de los triangulos. 
 for t=1:nt,                                        % Bucle en triangulos.
     for a=1:3,                                     % Bucle en aristas.
         as=mod(a,3)+1;I=T(t,a);J=T(t,as);          % Num. arista.
         if(ismember(BR(t,a),ref_bord))             % Arista en el borde.
            L=norm(S(I,:)-S(J,:));                  % Longueur de la arista.
            in=[I J];                               % Numerotation global.
            for k=1:nbq,                            % Bucle en puntos de cuadr.
                x=pts_quadS(k);c=L*pds_quadS(k); 
                w=[1-x x];                          % Funciones de base locales.
                M(in,in)=M(in,in)+c*w'*w;           % Ensamblado.
            end, 
         end, 
     end,
 end,
 