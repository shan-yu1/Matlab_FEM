function [K,M]=calcul_EF_2D(S,T,RT,fK,fM)
 if(nargin==3) fK=@un;fM=@un;end,               % fK coef. asociados a K
 if(nargin==4) fM=@un;end,                      % fM coef. asociados a M
 % Formula de cuadratura con 15 puntos. 
 % Exacta sobre polinomios de grado 7.
 int7=textread('int7.txt');                     % Lectura de puntos y nodos
 pts_quadT=int7(:,1:2);                         % Puntos de cuadratura
 pds_quadT=int7(:,3)*(0.5)^2;                   % Pesos de cuadratura.
 % Inicializacion
 nt=size(T,1);ns=size(S,1);q=size(T,2);         % Tamanos.
 nbq=length(pds_quadT);
 K=sparse(ns,ns); M=sparse(ns,ns);              % Definicion de matrices.
 % Bucle sobre elementos.
 for t=1:nt,                                    % t indice del triangulo.
     St=[S(T(t,:),:)];                          % Vertices del triangulo.
     S21=St(2,:)-St(1,:);S31=St(3,:)-St(1,:);   % Columnas de dF_l.
     delta=S21(1)*S31(2)-S21(2)*S31(1);         % Jacobiano de F_l.
     Jfmt=[S31(2) -S21(2);-S31(1) S21(1)]/delta;% [dF_l]^{-t}
     Mt=zeros(q,q);Kt=zeros(q,q);               % Matrices elementales.
     for k=1:nbq,                               % Bucle en ptos de cuadr.
        x=pts_quadT(k,1);y=pts_quadT(k,2);      
        lw=[1-x-y x y];
        w=[(9/2)*lw(1).*(lw(1)-1/3).*(lw(1)-2/3)... % Funciones de base P3
           (9/2)*lw(2).*(lw(2)-1/3).*(lw(2)-2/3)...
           (9/2)*lw(3).*(lw(3)-1/3).*(lw(3)-2/3)...
           (27/2)*lw(1).*lw(2).*(lw(1)-1/3)...
           (27/2)*lw(1).*lw(2).*(lw(2)-1/3)...
           (27/2)*lw(2).*lw(3).*(lw(2)-1/3)...
           (27/2)*lw(2).*lw(3).*(lw(3)-1/3)...
           (27/2)*lw(1).*lw(3).*(lw(3)-1/3)...
           (27/2)*lw(1).*lw(3).*(lw(1)-1/3)...
           27*lw(1).*lw(2).*lw(3)];
        gw1=[18*x + 18*y - 27*x*y - (27*x^2)/2 - (27*y^2)/2 - 11/2;...
            18*x + 18*y - 27*x*y - (27*x^2)/2 - (27*y^2)/2 - 11/2];
        gw2=[(27*x^2)/2 - 9*x + 1;...
            0];
        gw3=[0;...
            (27*y^2)/2 - 9*y + 1];
        gw4=[(81*x^2)/2 + 54*x*y - 45*x + (27*y^2)/2 - (45*y)/2 + 9;...
            27*x*y - (45*x)/2 + 27*x^2];
        gw5=[36*x + (9*y)/2 - 27*x*y - (81*x^2)/2 - 9/2;...
            (9*x)/2 - (27*x^2)/2];
        gw6=[27*x*y - (9*y)/2;...
            (27*x^2)/2 - (9*x)/2];
        gw7=[(27*y^2)/2 - (9*y)/2;...
            27*x*y - (9*x)/2];
        gw8=[(9*y)/2 - (27*y^2)/2;...
            (9*x)/2 + 36*y - 27*x*y - (81*y^2)/2 - 9/2];
        gw9=[27*x*y - (45*y)/2 + 27*y^2;...
            (27*x^2)/2 + 54*x*y - (45*x)/2 + (81*y^2)/2 - 45*y + 9];
        gw10=[27*y - 54*x*y - 27*y^2;
              27*x - 54*x*y - 27*x^2];
        gw=[gw1 gw2 gw3 gw4 gw5 gw6 gw7 gw8 gw9 gw10]; %Gradiente funciones base P3
        P=St'*w';                               % P = F_l(x,y) punto en el 
                                                % espacio fisico.
        pk=pds_quadT(k)*abs(delta);             % Peso de cuadratura * jacobiano.
        Mt=Mt+fM(P(1),P(2),RT(t))*pk*w'*w;      % Matriz de masa elemental.
        jg=Jfmt*gw;
        Kt=Kt+fK(P(1),P(2),RT(t))*pk*jg'*jg;    % Matriz de rigidez elemental.
    end,
    % Ensamblado.
    I=T(t,:);
    K(I,I)=K(I,I)+Kt;                           % Ensamblado de K.
    M(I,I)=M(I,I)+Mt;                           % Ensamblado de M.
 end


