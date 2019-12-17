function [S,T,BR,RT]=triangule_rectangle(rect,m,n,ref_mat,ref_bord)
if(nargin==3) ref_mat=0;ref_bord=[1 2 3 4];end,
if(nargin==4) ref_bord=[1 2 3 4];end,
[S,T,BR,RT]=triangule_carre(m,n,ref_mat,ref_bord);
%transf des coordonnées S
l=rect(2)-rect(1);S(:,1)=rect(1)+l*S(:,1);
l=rect(4)-rect(3);S(:,2)=rect(3)+l*S(:,2);
