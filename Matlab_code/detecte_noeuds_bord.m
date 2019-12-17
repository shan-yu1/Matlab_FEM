function L=detecte_noeuds_bord(A)
[r,c,v]=find(A==1);    % Indice de las aristas no compartidas.
L=unique(r);


