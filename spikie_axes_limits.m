function [status,x_min,x_max,y_min,y_max]=...
    spikie_axes_limits(x_min_orig,x_max_orig,y_min_orig,y_max_orig)
%--------------------------------------------------------------------------
% Nadefinovani mezi os uzivatelem
%--------------------------------------------------------------------------
% Syntaxe funkce:[status,x_min,x_max,y_min,y_max]=...
% axes_limits(x_min_orig,x_max_orig,y_min_orig,y_max_orig) 
%--------------------------------------------------------------------------
% Vstupni parametry:
% x_min_orig, x_max_orig -> aktualni min. a max. hodnota x-ove osy
% y_min_orig, y_max_orig -> aktualni min. a max. hodnota y-ove osy
%--------------------------------------------------------------------------
% Vystupni parametry:
% status -> V pripade, ze bylo stisknuto cancel nebo byly zadany
% nepripustne meze os (zobrazi se error dialog), je status nastaven 
% na hodnotu 0. V tomto pripade vraci funkce puvodni (nezmenene meze
% os). V opacnem pripade vraci funkce zmenene meze os:
% x_min, x_max -> zmenena min. a max. hodnota x-ove osy
% y_min, y_max -> zmenena min. a max. hodnota y-ove osy 
%--------------------------------------------------------------------------
prompt_limits = {'X-minimum:','X-maximum:','Y-minimum','Y-maximum'};
dlg_title_limits = 'Axes limits';
num_lines = 1;
def_limits = {num2str(x_min_orig),num2str(x_max_orig),...
num2str(y_min_orig),num2str(y_max_orig)};
odpoved_axes_limits = inputdlg(prompt_limits,dlg_title_limits,...
num_lines,def_limits);

if ~isequal(odpoved_axes_limits,{}) % Testovani, zda nebylo stisknuto cancel
 [x_min,status_1]=str2num(odpoved_axes_limits{1}); % Pozadovane X_min
 [x_max,status_2]=str2num(odpoved_axes_limits{2}); % Pozadovane X_max
 [y_min,status_3]=str2num(odpoved_axes_limits{3}); % Pozadovane Y_min
 [y_max,status_4]=str2num(odpoved_axes_limits{4}); % Pozadovane Y_max
 if status_1==0 || status_2==0 || status_3==0 || status_4==0 ||...
  size(x_min,2)~=1 || size(x_max,2)~=1 || size(y_min,2)~=1 ||...
  size(y_max,2)~=1 || (x_min>=x_max)||(y_min>=y_max); 
  errordlg('Enter new values','Invalid values!');
  status=0;
  x_min=x_min_orig;x_max=x_max_orig;y_min=y_min_orig;y_max=y_max_orig;
 else
  status=1;
 end % if (testovani pripustnych hodnot)
else %Bylo stisknuto cancel
 status=0;
 x_min=x_min_orig;x_max=x_max_orig;y_min=y_min_orig;y_max=y_max_orig; 
end % if (testovani zda nebylo stisknuto cancel)
