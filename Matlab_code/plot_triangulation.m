function plot_triangulation(S,T,BR,RT,num)
% Fabricacion de una lista de colores por defecto (11 colores).
couleur=[1 1 1; 0 0 1; 0 1 0; 1 0 0; 1 1 0; 0 1 1; 1 0 1;
         0.5 0.5 0.5; 0.5 0.5 0; 0 0.5 0.5; 0.5 0 0.5];    
% Definicion de los colores.
reft=unique(RT);n=length(reft);refc=11*ones(1,n);c=0;m=min(reft)+1;
for i=1:min(n,11) c=c+1;refc(reft(i)+m)=c;end;
%dessin du maillage
movegui(figure(1),[120 120]);
hold on;rmax=0;
for l=1:size(T,1)
    X=[S(T(l,1),1) S(T(l,2),1) S(T(l,3),1)];
    Y=[S(T(l,1),2) S(T(l,2),2) S(T(l,3),2)];
    i=refc(RT(l)+m);c=couleur(i,:);    patch(X,Y,c);
    % Color para los bordes.
     for k=1:3,
         ks=mod(k,3)+1;
         r=BR(l,k);if(r>rmax) rmax=r;end,
         if(r>0 && r<11)
            line([X(k) X(ks)],[Y(k) Y(ks)],'LineWidth',...
                 2,'Color',couleur(r+1,:));
         end,
     end,    
    if(num>0) % Representamos la numeracion.
        if(num>=10) % Representamos la numeracion de triangulos.
            G=[X;Y]*[1;1;1]/3;   % Baricentro del triangulo.
            text(G(1),G(2),int2str(l),'FontSize',8);
        end,
        if(num~=10) % Representacion de los nodos P1
                for k=1:3,
                    text(X(k),Y(k),int2str(T(l,k)),...
                         'FontSize',8,'BackgroundColor',[1 1 1]);
                end,
        end,
        
    end,
    hold on
    line([S(1,1) S(2,1)],[S(1,2) S(2,2)],'LineWidth',3,'Color','blue')
    hold on
    line([S(2,1) S(4,1)],[S(2,2) S(4,2)],'LineWidth',3,'Color','green')
    hold on
    line([S(4,1) S(3,1)],[S(4,2) S(3,2)],'LineWidth',3,'Color','red')
    hold on
    line([S(3,1) S(1,1)],[S(3,2) S(1,2)],'LineWidth',3,'Color','yellow')
end
