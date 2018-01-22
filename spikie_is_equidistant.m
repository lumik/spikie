function status=spikie_is_equidistant(data,allowance)
% status=spikie_is_equidistant(data,allowance)
% Zjisti, zda jsou data ekvidistantni, coz je vektor hodnot, ekvidistantni,
% pricemz za hranici ekvidistantnosti se povazuje hodnota allowance, ktera
% udava o jakou cast prumerneho kroku se muzou jednotlive kroky lisit. V
% pripade neekvidistantnosti dat se nastavi status na 0, pro ekvidistantni
% data na 1. Zdani allowance je nepovinne, jeji hodnota je implicitne
% nastavena na 0.001.
if nargin<2
 allowance=.001;
end
status=1;
l_data=length(data);
if l_data>2
 average=abs(sum(data(2:end)-data(1:end-1)))/(l_data-1);
 allowance=average*allowance;
 for ii=2:l_data
  if abs(abs(data(ii)-data(ii-1))-average)>=allowance
   status=0;
  end
 end
end
if ~status
 h_warndlg=warndlg(...
     'Data isn''t equidistant. It can greatly slow down computation');
 waitfor(h_warndlg);
end