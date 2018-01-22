function [U,W,V,E]=spikie_faktorka(spektra)
%--------------------------------------------------------------------------
% Faktorova analyza serie spekter
%--------------------------------------------------------------------------
% Syntaxe funkce: [U,W,V,E]=faktorka(spektra)
%--------------------------------------------------------------------------
% Vstupni parametry:
% spektra -> sloupce teto matice odpovidaji exp. spektrum (bez x-oveho
% sloupce)
%--------------------------------------------------------------------------
% Vystupni parametry:
% U -> matice, jejiz sloupce jsou subspektra 
% V -> matice, jejiz sloupce jsou koeficienty
% W -> sloupec singularnich hodnot
% E -> sloupec rezidualnich chyb
%--------------------------------------------------------------------------

% Singular Value Decomposition (SVD). Urceni subspekter U, koeficientu V a
% singularnich hodnot W:
[U,W,V] = svd(spektra,'econ'); 
W=diag(W); % vektor singularnich hodnot

% vypocet rezidualni chyby E v zavislosti na faktorove dimenzi: 
spektra_pocet=size(spektra,2); % pocet spekter  
pocet=size(spektra,1); % pocet spektralnich bodu v jednom spektru
SK=W.^2;% Kvadrat residualni chyby
if spektra_pocet==1 
 E=0; % Pro jedno spektrum nelze definovat rezidualni chybu. E je v tomto
 % pripade definovano jako 0.
else 
 pocet_subspekter=size(U,2); % V pripade, ze pocet spektrálnich bodu >=pocet  
 % spekter, odpovida pocet spekter poctu subspekter. Potom funkce
 % svd(spektra,'econ') je ekvivalentni svd(spektra,0). V opacnem pripade 
 % svd(spektra,'econ') poskytuje mensi pocet subspekter. Pocet subspekter je
 % roven mensimu z parametru (pocet spekter, pocet spektralnich bodu)
 for m=1:(pocet_subspekter-1)
  vyraz_1=sum(SK((m+1):(pocet_subspekter)));
  vyraz_2=pocet*((pocet_subspekter)-m);
  E(m)=sqrt(vyraz_1/vyraz_2); % hodnota rezidualni chyby
 end
  E=E'; % Residualni chyba jako sloupcovy vektor 
end