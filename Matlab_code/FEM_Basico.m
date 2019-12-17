clear all
close all
clc
% % % Creacion del mallado.
% % plot_triangulation(S,T,BR,RT,0);
% % % Matrices y vectores de elementos finitos.
% % [K,M]=calcul_EF_2D(S,T,RT);                       % Matrices de EF.
% % % Test con solucion exacta.
% % X=S(:,1);Y=S(:,2);
% % Uex=sin(pi.*X./Lx).*sin(pi.*Y./Ly);               % Sol. exacta
% % B=M*(Uex.*(1+(pi^2)*(1/Lx^2+1/Ly^2)));            % Segundo miembro.
% % % Condiciones de contorno Dirichlet.
% % Noeud_dir                                         % Lista de nodos Dirichlet.
% % G=Noeud_dir.*Uex;                                 % Datos Dirichlet.
% % [Ae,Be]=cd_Dirichlet(K,B,Noeud_dir,G);            % Pseudo-elimination 

Lx=1;Ly=1;                                            % Limites de la malla
% Lectura del mallado generado por Gmesh.
% Malla 20 x 20
S = textread('S.txt');                                % Nodos
S=S(:,2:3);
T = textread('T.txt');                                % Elementos (triangulos)
T=T(:,6:15);
X=S(:,1);Y=S(:,2);                                    % Coordenadas de los nodos
BR=zeros(size(T));
RT=ones(1,length(T));                                 % Identidad fisica

plot_triangulation(S,T,BR,RT,0);                      % Grafica de la malla

% Matrices de elementos finitos.
[K,M]=calcul_EF_2D(S,T,RT);                           % Matrices EF.
A=M+K;                                                % Matriz del sistema

FR=textread('FR.txt');                                % Nodos de frontera
FR=FR(:,end-4:end);
Noeud_dir=zeros(size(S,1),1);                         % Lista de nodos Dirichlet
% En este caso toda la frontera es Dirichlet (1 2 3 4)
for i=1:size(FR,1)
   if FR(i,1)==1 || FR(i,1)==2 || FR(i,1)==3 || FR(i,1)==4
      Noeud_dir(FR(i,end-3:end))=1;                   % Lista de nodos Dirichlet
   end
end

Uex=sin(pi.*X./Lx).*sin(pi.*Y./Ly);                   % Solucion exacta.
B=M*(Uex.*(1+(pi^2)*(1/Lx^2+1/Ly^2)));                % Segundo miembro.

% Tenemos en cuenta las condiciones de contorno Dirichlet.
G=Noeud_dir.*Uex;                                     % Datos Dirichlet.
[Ae,Be]=cd_Dirichlet(A,B,Noeud_dir,G);                % Pseudo-elimination.

% Resolution y calculo del error en norma L2 y H1.
U=Ae\Be;                                              % Resolucion del sistema.
E=U-Uex;                                              % Diferencia.
el2=sqrt(E'*M*E);eh1=sqrt(E'*K*E);                    % Error l2 y h1.
eH1=sqrt(E'*(M+K)*E);                                 % Error H1
% Representacion grafica.
movegui(figure(2),[684 120])
trisurf(T(:,1:3),S(:,1),S(:,2),U);shading interp;axis equal;
xlabel('x');ylabel('y');zlabel('u(x,y)');
title('Solución aproximada'); colorbar('east')
