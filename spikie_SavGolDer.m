function [y,indexy]=spikie_SavGolDer(spektrum,k,f,der,equidistant)
% [y,indexy]=SavGolDer(x,k,f,der,w) Spocita derivaci pomocí Savitzky-Golay
% filtru, kde spektrum je matice, ktera ma v prvnim sloupci body a ve
% druhem jejich hodnoty, ktere filtrujeme, k je tupen polynomu, musi byt
% mensi nez f, coz je pocet prvku, pres které se filtruje, der je stupen
% derivace od 0 (jenom vyhlazeni) po k+1.
% Dvouprvkovy vektor indexy obsahuje idex prvniho a posledniho bodu
% filtrovaneho spektra vzhledem k puvodnimu
if nargin<5
 equidistant=1;
end
l_spektrum=size(spektrum,1);
polovina=((f-1)/2);
y=zeros(1,l_spektrum-f+1);
indexy=[polovina+1,l_spektrum-polovina];
if equidistant
 [b,g] = sgolay(k,f);   % spoète S-G koeficienty
 d=(spektrum(2,1)-spektrum(1,1))^der;%rozdil sousednich bodu umocneny na stupen derivace
 for n=polovina+1:l_spektrum-polovina
  y(n)=factorial(der)*dot(g(:,der+1),spektrum((n-polovina:n+polovina),2))/d;
 end
 y=[(spektrum(polovina+1:l_spektrum-polovina,1)),y((f+1)/2:end)'];
else
 polynomial_derivative=ones(1,k-der+1);
 for ii=1:k-der+1
  polynomial_derivative(ii)=factorial(k-ii+1)/factorial(k-ii+1-der);
 end
 for n=polovina+1:l_spektrum-polovina
  window=spektrum(n-polovina:n+polovina,1);
  middle=sum(window)/f;
  my_polynome=polyfit(window-middle,...
      spektrum(n-polovina:n+polovina,2),k);
  my_polynome=my_polynome(1:k-der+1).*polynomial_derivative;
  y(n)=polyval(my_polynome,spektrum(n,1)-middle);
 end
 y=[(spektrum(polovina+1:l_spektrum-polovina,1)),y((f+1)/2:end)'];
end