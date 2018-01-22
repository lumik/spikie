function varargout = spikie_singV_resE(varargin)
% SPIKIE_SINGV_RESE M-file for spikie_singV_resE.fig
%      SPIKIE_SINGV_RESE, by itself, creates a new SPIKIE_SINGV_RESE or raises the existing
%      singleton*.
%
%      H = SPIKIE_SINGV_RESE returns the handle to a new SPIKIE_SINGV_RESE or the handle to
%      the existing singleton*.
%
%      SPIKIE_SINGV_RESE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPIKIE_SINGV_RESE.M with the given input arguments.
%
%      SPIKIE_SINGV_RESE('Property','Value',...) creates a new SPIKIE_SINGV_RESE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before singV_resE_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spikie_singV_resE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spikie_singV_resE

% Last Modified by GUIDE v2.5 22-Jan-2018 10:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spikie_singV_resE_OpeningFcn, ...
                   'gui_OutputFcn',  @spikie_singV_resE_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before spikie_singV_resE is made visible.
function spikie_singV_resE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spikie_singV_resE (see VARARGIN)
%--------------------------------------------------------------------------
% Tento program vykresli singularni hodnoty a residualni chyby z vysledku
% faktorove analyzy

% vstupni parametry: 
% varargin(1): Zde se nacte parametr, ktery pouze urcuje pojmenovani
% obrazku. Hodnota 1 znamena, ze jde o sing. hodnoty a res. chyb z FA 
% spekter nekorigovanych na pozadi. Jina hodnota znamena, ze jde o sing.
% hodnoty a res. chyby z FA spekter s korigovanym pozadim.  
% varargin(2): Zde se nacte vektor singularnich hodnot 
% varargin(3): Zde se nacte vektor residualnich chyb
%--------------------------------------------------------------------------
handles.volba=varargin{1}; % handles.volba urcuje zpusob popisu obrazku  
handles.W=varargin{2}; % nacteni sloupce singularnich hodnot
handles.E=varargin{3}; % nacteni sloupce residualnich chyb
% Promenne handles.W_auto a handles.E_auto obsahuji hodnoty mezi os 
% pro automaticke skalovani os x-ove a y-ove osy (xmin,xmax,ymin,ymax) pro 
% singularni hodnoty a residualni chyby . Vychazi se z toho, ze minimalni 
% hodnota x-ove osy je 1 a maximalni hodnota odpovida velikosti vektoru
% sing. hodnot a res. chyb (dimenze vektoru sing. hodnot je o jednu vyssi 
% nez vektoru res. chyb). Automaticke skalovani mezi os pro sing. hodnoty 
% a res. chyby pomoci funkce axes_adjust: 
handles.W_auto=axes_adjust([(1:1:size(handles.W,1))' handles.W]);
handles.E_auto=axes_adjust([(1:1:size(handles.E,1))' handles.E]);
% Hodnoty manualniho skalovani os vychazi pri spusteni programu z automat. 
% skalovani: 
handles.W_manual=handles.W_auto; 
handles.E_manual=handles.E_auto;
%--------------------------------------------------------------------------
% Na zaklade volby specifikovane pomoci varargin(3) se vypisuje nazev 
% obrazku
%--------------------------------------------------------------------------
if handles.volba==1
 set(hObject,'MenuBar','figure','Name',...
 'Singular values and residual errors for background-uncorrected spectra',...
 'NumberTitle','off');
else
 set(hObject,'MenuBar','figure','Name',...
 'Singular values and residual errors for background-corrected spectra',...
 'NumberTitle','off');    
end
%--------------------------------------------------------------------------
% Pri spusteni programu se vykresli singularni hodnoty a koeficienty se 
% skalovanim mezi os v rezimu auto.
%--------------------------------------------------------------------------
axes(handles.singular_axes); % prepnuti na osy pro kresleni singularnich
% hodnot
handles.plot_W=plot(1:1:size(handles.W,1),handles.W(:,1),'-ko','MarkerSize',5,...
'MarkerFaceColor','g'); % vykresleni singularnich hodnot
axis(handles.W_auto{1}); % automaticke skalovani os pri zobrazeni sing. hodnot
grid minor % mrizka pro graf singularnich hodnot
title('Singular values');
axes(handles.residual_axes);% prepnuti na osy pro kresleni residualnich chyb
handles.plot_E=plot(1:1:size(handles.E,1),handles.E(:,1),'-ko','MarkerSize',5,...
'MarkerFaceColor','g'); % vykresleni residualnich chyb 
axis(handles.E_auto{1});% automaticke skalovani os pri zobrazeni res. chyb.
grid minor % mrizka pro graf residualnich chyb
title('Residual errors');
%--------------------------------------------------------------------------
set(handles.text_limits_push,'String','auto','BackgroundColor','green');
handles.axes_manual=0; % Indikace rezimu skalovani os pomoci zeleneho
% tlacitka. Defaultni je rezim auto (handles.axes_manual=0). Upravou mezi
% os pro singularni nebo residualni hodnoty se prechazi do systemu
% manualniho nastaveni os (handles.axes_manual=1). Stiskem tlacitka 
% (callback:text_limits_push) se prechazi opet do rezimu automat. nastaveni
% mezi os. 
%--------------------------------------------------------------------------
% Choose default command line output for spikie_singV_resE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spikie_singV_resE wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%**************************************************************************
% --- Outputs from this function are returned to the command line.
function varargout = spikie_singV_resE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%**************************************************************************
% --- Executes on button press in text_limits_push.
function text_limits_push_Callback(hObject, eventdata, handles)
% hObject    handle to text_limits_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Prechod do rezimu automatickeho skalovani os pro singularni hodnoty a
% residualni chyby
%--------------------------------------------------------------------------
handles.axes_manual=0; % Indikace rezimu automatickeho skalovani os
% Rezim auto je indikovan zelenym napisem auto na tlacitku:
set(handles.text_limits_push,'String','auto','BackgroundColor','green'); 
axes(handles.singular_axes);% prepnuti na osy pro kresleni singularnich
% hodnot
axis(handles.W_auto{1}); % automaticke skalovani os pri zobrazeni sing. hodnot
axes(handles.residual_axes); %prepnuti na osy pro kresleni residualnich chyb
axis(handles.E_auto{1}); %automaticke skalovani os pri zobrazeni res. chyb.
guidata(hObject,handles);% aktualizace dat
%**************************************************************************
% --- Executes on button press in singular_limits_push.
function singular_limits_push_Callback(hObject, eventdata, handles)
% hObject    handle to singular_limits_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Manualni nastaveni mezi os pro singularni hodnoty
%--------------------------------------------------------------------------
% Predchozi nastaveni mezi os v rezimu manual je vychozi pri dalsi zmene   
% mezi os pomoci funkce axes_limits:
osy=handles.W_manual{1};
[status,x_min,x_max,y_min,y_max]=axes_limits(osy(1),osy(2),osy(3),osy(4)); 
if status==1 % Po zadani pripustnych mezi os se prechazi do rezimu manual
 handles.axes_manual=1; % Mod manual -> handles.axes_manual=1 
 % Mod manual je indikovan zelenym tlacitkem s napisem manual:  
 set(handles.text_limits_push,'String','manual','BackgroundColor','green');   
 axes(handles.singular_axes);
 axis([x_min,x_max,y_min,y_max]); % Zmena mezi os podle zadanych parametru 
 handles.W_manual{1}=[x_min,x_max,y_min,y_max]; % Aktualizace mezi os v 
 % rezimu manual pro singularni hodnoty
 guidata(hObject,handles);% aktualizace promennych
end
%**************************************************************************
% --- Executes on button press in residual_limits_push.
function residual_limits_push_Callback(hObject, eventdata, handles)
% hObject    handle to residual_limits_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Manualni nastaveni mezi os pro residualni chyby
%--------------------------------------------------------------------------
% Predchozi nastaveni mezi os v rezimu manual je vychozi pri dalsi zmene 
% mezi os pomoci funkce axes_limits:
osy=handles.E_manual{1};
[status,x_min,x_max,y_min,y_max]=axes_limits(osy(1),osy(2),osy(3),osy(4)); 
if status==1 % Po zadani pripustnych mezi os se prechazi do rezimu manual  
 handles.axes_manual=1; % Mod manual -> handles.axes_manual=1 
 %Mod manual je indikovan zelenym tlacitkem s napisem manual:  
 set(handles.text_limits_push,'String','manual','BackgroundColor','green');   
 axes(handles.residual_axes);
 axis([x_min,x_max,y_min,y_max]); % Zmena mezi os podle zadanych parametru 
 handles.E_manual{1}=[x_min,x_max,y_min,y_max]; % Aktualizace mezi os v
 % rezimu manual pro residualni chyby
 guidata(hObject,handles);% aktualizace promennych
end
%**************************************************************************
% --- Executes on button press in log_singular.
function log_singular_Callback(hObject, eventdata, handles)
% hObject    handle to log_singular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Logaritmicka skala y-ove osy pro singularni hodnoty
%--------------------------------------------------------------------------
axes(handles.singular_axes);% Prepnuti na osy pro kresleni singularnich
% hodnot
if get(hObject,'Value')==1
 handles.plot_W=semilogy(1:1:size(handles.W,1),handles.W(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); % vykresleni singularnich hodnot (log. skala)
 title('Singular values');
else
 handles.plot_W=plot(1:1:size(handles.W,1),handles.W(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); % vykresleni singularnich hodnot (normalni skala)
 title('Singular values');
 if handles.axes_manual==0
  axis(handles.W_auto{1}); 
 else
  axis(handles.W_manual{1});
 end
end
grid minor % Mrizka pro graf singularnich hodnot
guidata(hObject,handles);% aktualizace promennych
% Hint: get(hObject,'Value') returns toggle state of log_singular
%**************************************************************************
% --- Executes on button press in log_residual.
function log_residual_Callback(hObject, eventdata, handles)
% hObject    handle to log_residual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Logaritmicka skala y-ove osy pro residualni chyby
%--------------------------------------------------------------------------
axes(handles.residual_axes);% Prepnuti na osy pro kresleni residualnich
% chyb
if get(hObject,'Value')==1 
 handles.plot_E=semilogy(1:1:size(handles.E,1),handles.E(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); % vykresleni residualnich chyb (log. skala)
 title('Residual errors');
else
 handles.plot_E=plot(1:1:size(handles.E,1),handles.E(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); % vykresleni residualnich chyb (normalni skala)
  title('Residual errors');
  if handles.axes_manual==0
   axis(handles.E_auto{1}); 
  else
  axis(handles.E_manual{1});
 end
end
grid minor % Mrizka pro graf residualnich chyb
guidata(hObject,handles);% aktualizace promennych
% Hint: get(hObject,'Value') returns toggle state of log_residual
%**************************************************************************
% --- Executes on button press in data_push.
function data_push_Callback(hObject, eventdata, handles)
% hObject    handle to data_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Vypis singularnich hodnot a residualnich chyb v listboxu
%--------------------------------------------------------------------------
data_info=figure; % Okno pro vypis informaci
set(data_info,'Units','normalized','Position',[0.50,0.47,0.38,0.48]);
% Nazev okna je urcen podle toho, jestli jde o spektra s korigovanym nebo 
% nekorigovanym pozadim:
if handles.volba==1
 set(data_info,'MenuBar','none','Name',...
 'Singular values and coefficients for background-uncorrected spectra',...
 'NumberTitle','off');
else
 set(data_info,'MenuBar','none', 'Name',...
 'Singular values and coefficients for background-corrected spectra',...
 'NumberTitle','off');
end
%--------------------------------------------------------------------------
data_list=cell(1,size(handles.W,1)+2); % Struktura cell array pro ulozeni 
% singularnich hodnot a residualnich chyb
%--------------------------------------------------------------------------
% Naplneni promenne data_list: 
data_list(1)=...
{strcat('                  Sing. values                            Res. error')};
for i=1:1:size(handles.W,1)-1
 data_list(1+i)={strcat(num2str(i),'................',num2str(handles.W(i)),...
 '..............................',num2str(handles.E(i)))};
end
% Vektor singularnich hodnot ma o jeden prvek vice nez vektor residualnich
% chyb: 
data_list(1+size(handles.W,1))={strcat(num2str(size(handles.W,1)),...
'................',num2str(handles.W(end)))};
%--------------------------------------------------------------------------
% Vypsani singularnich hodnot a residualnich chyb v listboxu:
uicontrol('Parent',data_info,'Style','listbox','Units','normalized',...
'Position',[0.10,0.06666,0.80,0.889],'String',data_list);
%--------------------------------------------------------------------------

% --- Executes on button press in new_window.
function new_window_Callback(hObject, eventdata, handles)
% hObject    handle to new_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

new_window=figure;
if handles.volba==1
 set(new_window,'MenuBar','figure','Name',...
 'Singular values and coefficients for background-uncorrected spectra',...
 'NumberTitle','off');
else
 set(new_window,'MenuBar','figure', 'Name',...
 'Singular values and coefficients for background-corrected spectra',...
 'NumberTitle','off');
end
subplot(1,2,1);
if get(handles.log_singular,'Value')
 semilogy(1:1:size(handles.W,1),handles.W(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); % vykresleni singularnich hodnot (log. skala)
else
 plot(1:1:size(handles.W,1),handles.W(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); % vykresleni singularnich hodnot (normalni skala)
 % Manualni nebo automaticke skalovani os pro singularni hodnoty:
 if handles.axes_manual==0
  axis(handles.W_auto{1}); 
 else
  axis(handles.W_manual{1});
 end
end
title('Singular values');
grid minor;
subplot(1,2,2);
if get(handles.log_residual,'Value')
 semilogy(1:1:size(handles.E,1),handles.E(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); 
else
 plot(1:1:size(handles.E,1),handles.E(:,1),'-ko','MarkerSize',5,...
 'MarkerFaceColor','g'); 
 if handles.axes_manual==0
  axis(handles.E_auto{1}); 
 else
  axis(handles.E_manual{1});
 end
end
title('Residual errors');
grid minor;

