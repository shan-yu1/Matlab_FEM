function Noeud_dir=noeud_bords(S,T,BR,list)

BR_Log = zeros(size(T));

for i=1:length(list)
    
    Aux1 = BR==list(i);
    Aux2 = [Aux1(:,3) Aux1(:,1:2)];
    BR_Log(:,1:3)=Aux1|BR_Log(:,1:3);
    BR_Log(:,1:3)=Aux2|BR_Log(:,1:3);
end

% Noeud_dir=sort(T(find(T.*BR_Log~=0)));
BR_Log=sort(T(find(T.*BR_Log~=0)));

Noeud_dir=zeros(size(S,1),1);
Noeud_dir(BR_Log)=1;

end
