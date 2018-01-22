function meze_os=spikie_axes_adjust(spektrum) 
%--------------------------------------------------------------------------
% Uprava mezi os pro jedno spektrum
%--------------------------------------------------------------------------
% Syntaxe funkce: [meze_os]=axes_adjust(spektrum) 
%--------------------------------------------------------------------------
% Vstupni parametry:
% spektrum - prvni sloupec udava vlnocty, druhy intenzity
%--------------------------------------------------------------------------
% Vystupni parametry:
% [meze_os]=  meze x-ove a y-ove osy (xmin,xmax,ymin,ymax) pro dane
% spektrum.  
%--------------------------------------------------------------------------
% Poznamky: x-ova a y-ova osa se roztahne o 5% puvodniho rozsahu na 
% kazdem "konci".
%--------------------------------------------------------------------------
x_min=min(spektrum(:,1)); %minimalni x
x_max=max(spektrum(:,1)); %maximalni x
delta_x=abs(x_max-x_min)*0.05; 
x_min=x_min-delta_x; % dolni x-ova mez 
x_max=x_max+delta_x; % horni x-ova mez
if x_max==x_min % hodnoty musi byt rostouci a nenulove
 x_min=x_min-1;   
 x_max=x_max+1; 
end    
y_min=min(spektrum(:,2)); %minimalni y
y_max=max(spektrum(:,2)); %maximalni y
delta_y=abs(y_max-y_min)*0.05;
y_min=y_min-delta_y;
y_max=y_max+delta_y;
if y_max==y_min % hodnoty musi byt rostouci a nenulove
 y_min=y_min-1;   
 y_max=y_max+1; 
end    
meze_os=[x_min,x_max,y_min,y_max];