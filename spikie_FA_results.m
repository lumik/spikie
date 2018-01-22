function varargout = spikie_FA_results(varargin)
% Funkce spikie_FA_results zobrazuje spektra a faktorovou analyzu z techto spekter
% (subspektrum vs. koeficient). Je mozno pracovat s jednou nebo i vice
% seriemi spekter. Data jsou dodana jinym programem (background, orto).
%--------------------------------------------------------------------------
% Vstupni parametry:
%--------------------------------------------------------------------------
% varargin(1): handles.kmen_nazev je kmenovy nazev souboru se spektry 
%--------------------------------------------------------------------------
% varargin(2): Prvni parametr handles.volba urcuje, jaky typ grafu se 
% zobrazuje (nabyva hodnoty 1,2,3,4):
% 1: Kresli se spektra nekorigovana na pozadi. Obrazek obsahuje jeden 
% objekt typu osy (handles.osy_spektra)
% 2: Kresli se spektra korigovana na pozadi. Obrazek obsahuje jeden objekt   
% typu osy (handles.osy_spektra) 
% 3: Kresli se vysledky faktorove analyzy spekter nekorigovanych na pozadi. 
% Obrazek obsahuje dva objekty typu osy (handles.axes_subspectra,
% handles.axes_coefficients) pro kresleni subspekter vs. koeficientu  
% 4: Kresli se vysledky faktorove analyzy spekter korigovanych na pozadi.  
% Obrazek obsahuje dva objekty typu osy (handles.axes_subspectra,
% handles.axes_coefficients) pro kresleni subspekter vs. koeficientu. 
% Volby (1,2) a (3,4) se lisi jen popisem obrazku (korigovana a 
% nekorigovana spektra; odpovidajici data musi byt dodana programem
% background nebo orto)
%--------------------------------------------------------------------------
% varargin(3): handles.vlnocty jsou vlnocty dat (spekter nebo subspekter)
%--------------------------------------------------------------------------
% varargin(4): Tato promenna je typu "cell array", ktere ma 1 nebo 2 polozky
% (2 polozky pouze v pripade zobrazovani spekter, kdy handles.volba==1,2).
% Prvni polozka: aktualni spektra (orezani, vyber a uprava pozadi spekter)
% Druha polozka: originalni spektra (pouze vyber spekter)
%--------------------------------------------------------------------------
% varargin(5): Promenna handles.hodnoty_typ nabyva hodnoty 1,2 nebo 3:
% 1: hodnoty na x-ove ose pro koeficienty a legenda pro spektra jsou
% odvozeny od cislovani puvodnich spekter (cislovani od jedne po jedne do 
% poctu nactenych spekter, cisla pro nevybrana spektra chybi) 
% 2: hodnoty na x-ove ose pro koeficienty jsou odvozeny od cislovani
% vybranych spekter (cislovani od jedne po jedne do poctu vybranych spekter)   
% 3: hodnoty na x-ove ose pro koeficienty a legenda pro spektra je odvozena
% od hodnot nactenych ze souboru
%--------------------------------------------------------------------------
% varargin(6): A) Promenna handles.hodnoty_soubor se nacte pouze pro hodnotu
% promenne handles.hodnoty_typ=3. Je to sloupcovy vektor hodnot pro x-ovou
% osu koeficientu a tvorbu legendy pri prohlizeni spekter. Z teto promenne 
% lze odvodit take puvodni pocet spekter (pred vybranim).
% B) V pripade, ze handles.hodnoty_typ je ruzne od 3, nacte se promenna
% handles.pocet_spekter_orig (udava puvodni pocet spekter)
%--------------------------------------------------------------------------
% varargin{7}: Radkovy vektor specifikujici vybrana spektra
%--------------------------------------------------------------------------
% varargin{8}: handles.serie_volba specifikuje, zda se pracuje s jednou 
%(handles.serie_volba=1) nebo s vice seriemi spekter(handles.serie_volba=2).
%--------------------------------------------------------------------------
% V pripade prace s vice seriemi:
% varargin{9}: Nacte se pocet spekter v jednotlivych seriich (rozdeleni na 
% serie je definovano vzhledem k puvodnim nactenym spektrum; nektere serie 
% po vybrani spekter nemusi obsahovat spektra)
% varargin{10}:handles.serie_barva je radkovy "Cell array" obsahuji retezce
% ve tvaru 'r', 'b', 'g', 'y', 'm', 'c' nebo 'k' specifikujici barvu, ktera  
% je uzita pro barevne odliseni prubehu koeficientu a pro odliseni spekter
% pro jednotlive serie  
% varargin{11}:  radkovy vektor specifikujici rozdeleni spekter na 
% jednotlive serie (priklad 10,25 -> 3 serie: 1.serie [1-10 spektrum], 
% 2.serie [11-25 spektrum], 3.serie [zbyla spektra]).  
%--------------------------------------------------------------------------
% V pripade, ze handles.volba je 3,4 (vykreslovani vysledku FA), pak se  
% nacte matice koeficientu handles.V. Matice koeficientu se nacte jako 
% devaty parametr nebo dvanacty parametr (podle toho jestli se pracuje nebo 
% nepracuje s vice seriemi - pri praci s vice seriemi se totiz nactou dalsi
% tri parametry (viz vyse)).
%--------------------------------------------------------------------------

% SPIKIE_FA_RESULTS, by itself, creates a new SPIKIE_FA_RESULTS or raises the existing
% singleton*.
% H = SPIKIE_FA_RESULTS returns the handle to a new SPIKIE_FA_RESULTS or the handle to
% the existing singleton*.
% SPIKIE_FA_RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
% function named CALLBACK in SPIKIE_FA_RESULTS.M with the given input arguments.
% SPIKIE_FA_RESULTS('Property','Value',...) creates a new SPIKIE_FA_RESULTS or raises the
% existing singleton*.  Starting from the left, property value pairs are
% applied to the GUI before FA_results_OpeningFunction gets called.  An
% unrecognized property name or invalid value makes property application
% stop.  All inputs are passed to spikie_FA_results_OpeningFcn via varargin.
% See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
% instance to run (singleton)".
% See also: GUIDE, GUIDATA, GUIHANDLES
% Last Modified by GUIDE v2.5 22-Jan-2018 10:45:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spikie_FA_results_OpeningFcn, ...
                   'gui_OutputFcn',  @spikie_FA_results_OutputFcn, ...
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

% --- Executes just before spikie_FA_results is made visible.
function spikie_FA_results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spikie_FA_results (see VARARGIN)

handles.precision=varargin{1};
%--------------------------------------------------------------------------
% Nasleduje nacteni parametru:
%--------------------------------------------------------------------------
handles.kmen_nazev=varargin{2}; % kmen nazev souboru se spektry
handles.volba=varargin{3}; % na zaklade hodnoty promenne handles.volba se
% kresli pozadovany typ grafu
%--------------------------------------------------------------------------
handles.vlnocty=varargin{4}; % aktualni vlnocet (program Orto nebo Background)
%--------------------------------------------------------------------------
handles.data=varargin{5}; 
handles.spektra=handles.data{1}; % aktualni data (spektra nebo subspektra;
% uvazovano vybrani, orezani a uprava pozadi spekter pomoci programu Orto
% nebo Background)
if handles.volba==1 || handles.volba==2 
 handles.data_orig_vyber=handles.data{2}; % originalni data (pouze vyber spekter)   
end
%--------------------------------------------------------------------------
handles.hodnoty_typ=varargin{6}; % typ x-ovych hodnot 
%--------------------------------------------------------------------------
if handles.hodnoty_typ==3
 handles.hodnoty_soubor=varargin{7}; % x-ove hodnoty ze souboru      
else 
 handles.pocet_spekter_orig=varargin{7}; % puvodni pocet spekter   
end
%--------------------------------------------------------------------------
handles.spektra_vyber=varargin{8}; % vektor specifikujici vybrana spektra    
%--------------------------------------------------------------------------
handles.serie_volba=varargin{9};% specifikace: jedna nebo vice serii spekter
%--------------------------------------------------------------------------
if handles.serie_volba==2 % v pripade, ze se pracuje s vice seriemi spekter
 handles.serie_vyber=varargin{10}; % pocet spekter v jednotlivych seriich
 % (vztazeno k vybranym spektrum; nektere serie nemusi obsahovat spektra) 
 handles.serie_barva=varargin{11}; % barva pro jednotlive serie
 handles.specifikace=varargin{12}; % specifikace rozdeleni puvodnich spekter
 % na jednotlive serie 
end
if handles.volba==3 || handles.volba==4 % nacteni matice koeficientu pouze
 % v pripade, ze se zobrazuji vysledky FA 
 if handles.serie_volba==2 % nacteny jiz dalsi 3 parametry (varargin(9-11)) 
  handles.V=varargin{13};
 else
  handles.V=varargin{10};
 end
end
%-------------------------------------------------------------------------- 
% Pomoci nactenych parametru se po spusteni programu spikie_FA_results(z popupmenu
% v programu background nebo orto) provede nasledujici:
%--------------------------------------------------------------------------
if handles.serie_volba==1 % V pripade prace s jednou serii nejsou aktivni
 % nabidky pro zobrazeni vice spekter, dif. spekter a gradientu spekter
 % pomoci barev odlisujicich jednotlive spektralni serie.
 set(handles.spectra_series_color,'Enable','off'); 
 set(handles.difference_color_series,'Enable','off')
 set(handles.gradient_color_series,'Enable','off');
end
%--------------------------------------------------------------------------
if handles.hodnoty_typ==3 % V pripade, ze jsou x-ove hodnoty pro osu
 % koeficientu (a legendu pro spektra) nacteny ze souboru, tak lze jednoduse
 % urcit puvodni pocet spekter (pocet radku souboru s x-ovymi hodnotami).
 % V pripade,ze handles.hodnoty_typ je ruzno od 3, tak je puvodni pocet
 % spekter nacten jako 6 parametr.  
 handles.pocet_spekter_orig=size(handles.hodnoty_soubor,1);       
end 
handles.pocet=size(handles.spektra,2); %  V zavislosti na handles.volba se
% jedna bud o vybrany pocet spekter nebo o pocet subspekter 
%--------------------------------------------------------------------------
if handles.hodnoty_typ==1 % x-ove hodnoty pro koeficienty jsou odvozeny od
 % cislovani puvodnich spekter (cisluje se od jedne po jedne az do poctu
 % puvodnich spekter; nevybrana spektra chybi) 
 handles.hodnoty=(handles.spektra_vyber)';
elseif handles.hodnoty_typ==2 % x-ove hodnoty pro koeficienty a legendu pro
 % spektra jsou odvozeny od cislovani vybranych spekter(cisluje se od jedne
 % po jedne do poctu vybranych spekter)
 handles.hodnoty=(1:1:size(handles.spektra_vyber,2))';
else % x-ove hodnoty pro koeficienty a tvorbu legendy pro spektra byly
% nacteny ze souboru
 handles.hodnoty=handles.hodnoty_soubor([handles.spektra_vyber]);
end
%--------------------------------------------------------------------------
% Uprava mezi os pro spektra/subpektra:
handles.auto_data=cell(1,handles.pocet);%promenna pro automat. skalovani os 
handles.auto_data=axes_adjust([handles.vlnocty handles.spektra]); % automat.
% skalovani mezi os pro spektra (handles.volba=1,2) nebo subspektra
% (handles.volba=3,4) pomoci uziti funkce axes_adjust
handles.manual_data=handles.auto_data; % Pri spusteni programu je manualni
% skalovani os pro kazde spektrum/subspektrum odvozeno od automatickeho
% rezimu 
%--------------------------------------------------------------------------
% Uprava mezi os pro koeficienty (nastane pouze v pripade, ze se zobrazuji
% vysledky faktorove analyzy - tj. handles.volba je 3 nebo 4)
if (handles.volba==3 || handles.volba==4)
 handles.auto_V=cell(1,handles.pocet); % promenna pro ulozeni parametru 
 % pouzitych k automatickemu a "peknemu" skalovani x-ove a y-ove osy pro
 % koeficienty.
 % Automaticke skalovani os pro koeficienty pomoci uziti funkce axes_adjust:
 handles.auto_V=axes_adjust([handles.hodnoty handles.V]);
 handles.manual_V=handles.auto_V; % Pri spusteni programu je manualni
 % skalovani os pro kazdy koeficient (sloupec matice V) odvozeno od
 % automatickeho rezimu
end
%--------------------------------------------------------------------------
% Nastaveni jmena obrazku pro kazdou ze ctyr alternativ: spektra s
% nekorigovanym pozadim, spektra s korigovanym pozadim, subspektra vs.
% koeficienty z FA spekter majicich nekorigovane pozadi, subspektra vs. 
% koeficienty z FA spekter majicich korigovane pozadi.
%--------------------------------------------------------------------------
switch handles.volba
 case 1,
  set(hObject,'MenuBar','none','Name','Background-uncorrected spectra',...
  'NumberTitle','off');
 case 2,
  set(hObject,'MenuBar','none','Name','Background-corrected spectra',...
  'NumberTitle','off');
 case 3,
  set(hObject,'MenuBar','none','Name',...
  'Factor analysis of background-uncorrected spectra (subspectra vs. coefficients)',...
  'NumberTitle','off');   
 case 4,
  set(hObject,'MenuBar','none','Name',...
  'Factor analysis of background-corrected spectra (subspectra vs. coefficients)',...
  'NumberTitle','off');  
end
%--------------------------------------------------------------------------
% Pri spusteni programu spikie_FA_results se kresli bud spektra (do jednoho
% objektu typu osy) nebo subspektra vs. koeficienty (uziji se dva objekty
% typu osy). Kresleni spekter odpovida handles.volba = 1, 2 a kresleni 
% vysledku faktorove analyzy odpovida handles.volba = 3, 4. Volby 1,2
% (analog. 3,4) nemaji vliv na dalsi beh programu. Specifikuji jen rozdilny
% popis obrazku (viz vyse) -> Odpovidajici data a specifikace, zda jsou
% korigovana nebo nekorigovana jsou poskytnuty jako parametry ve volajicim
% programu (background, orto) 
%--------------------------------------------------------------------------
% 1) Dalsi cast kodu se tyka kresleni spekter (handles.volba=1 nebo 2). Pri
% spusteni programu se vykresli prvni spektrum (cislovani je vzhledem k
% vybranym spektrum - vysvetleni viz vyse) do jednoho objektu typu osy 
% (handles.osy_spektra). Zbyle 2 definovane objekty typu osy nejsou viditelne.
%--------------------------------------------------------------------------
if handles.volba==1 || handles.volba==2 
 set(handles.osy_spektra,'Visible','on');
 set(handles.axes_subspectra,'Visible','off');
 set(handles.axes_coefficients,'Visible','off');
 set(handles.new_window_coefficients,'Visible','off');
 axes(handles.osy_spektra); % Prepnuti na osy pro zobrazeni spekter
 if handles.serie_volba==1 % Nepracuje se seriemi spekter. Zobrazi se prvni
  % spektrum (defaultne modra barva): 
  plot(handles.vlnocty,handles.spektra(:,1),'b');  
 else % Pracuje se s nekolika seriemi spekter. Zobrazi se prvni spektrum
  % barvou, ktera odpovida poradi dane serie:   
  orig_poradi_spektra=handles.spektra_vyber(1);
  pocet_serii=size(handles.serie_vyber,2);
  hranice=handles.specifikace;
  hranice(pocet_serii)=handles.pocet_spekter_orig;
  for n=1:1:pocet_serii
   if orig_poradi_spektra <= hranice(n)
    serie_poradi=n;
    break
   end
  end
  plot(handles.vlnocty,handles.spektra(:,1),handles.serie_barva{serie_poradi});   
 end
 axis(handles.auto_data{1}); % Automaticke nastaveni os pro prvni spektrum
 grid minor % Zobrazeni mrizky pro spektra
 %-------------------------------------------------------------------------
 % Nasleduje generovani legendy pro spektra:
 %-------------------------------------------------------------------------
 if handles.serie_volba==1 % Nezobrazuje se cislovani serii (nepracuje se
  % seriemi). 
  handles.legenda={['par:',num2str(handles.spektra_vyber(1))]};
  legend(gca,1,handles.legenda);
 else % handles.serie_volba==2 (zobrazuje se cislovani serii) 
  handles.legenda={['par:',num2str(handles.spektra_vyber(1)),...
  '  ser:',num2str(serie_poradi)]};
  legend(gca,1,handles.legenda);
 end
 %-------------------------------------------------------------------------
 set(handles.coefficients_axes_limits,'Enable','off'); % Pri zobrazovani
 % spekter je inaktivni tlacitko pro nastaveni mezi os pro koeficienty
 set(handles.Select_subspectrum_title,'Title','Select spectrum') % indikace
 % na panelu, ze vybirame spektra
 set(handles.subspectra_axes_limits,'String','spectra'); % Pomoci tlacitka 
 % je indikovano, ze limity os se upravuji pro spektra
 set(handles.text_spectrum_push,'String',strcat('spectrum:',...
 num2str(1)),'BackgroundColor','green'); % Pomoci zeleneho tlacitka je 
 % indikovano, ze se zobrazuje prvni (tj. pripustne) spektrum
 %-------------------------------------------------------------------------
 % 2) Dalsi cast kodu se tyka kresleni vysledku FA (handles.volba=3 nebo 4).
 % Pri spusteni programu se vykresli prvni dvojice subspektrum vs. koeficient.
 % V tomto pripade nejsou osy pro kresleni spekter viditelne. Pouzivaji se
 % misto toho dva jine objekty typu osy: handles.axes_subspectra (kresleni
 % subspekter) a handles.axes_coefficients (kresleni koeficientu). Napred
 % se vykresli prvni subspektrum (A) a pote odpovidajici prvni koeficient 
 % (prvni sloupec matice koeficientu handles.V)(B).
 %-------------------------------------------------------------------------
else %(handles.volba==3 || handles.volba==4) 
 set(handles.osy_spektra,'Visible','off');   
 set(handles.axes_subspectra,'Visible','on');
 set(handles.axes_coefficients,'Visible','on');
 set(handles.new_window_coefficients,'Visible','on');
 % Pomoci zeleneho tlacitka je indikovano, ze se zobrazuje prvni (tj.
 % pripustne subspektrum vs. koeficient):
 set(handles.text_spectrum_push,'String',...
 strcat('subspectrum:',num2str(1)),'BackgroundColor','green');
 % Nazev panelu indikuje, ze vybirame subspektra (vs. koeficienty):
 set(handles.Select_subspectrum_title,'Title','Select subspectrum');
 % Indikace na tlacitku, ze limity os upravujeme pro subspektra:
 set(handles.subspectra_axes_limits,'String','subspectra'); 
 %-------------------------------------------------------------------------
 % (A) Kresleni prvniho subspektra
 %-------------------------------------------------------------------------
 axes(handles.axes_subspectra); % Prepnuti na osy pro kresleni subspekter 
 plot(handles.vlnocty,handles.spektra(:,1),'b');%Vykresleni prvniho subspektra  
 grid minor % zobrazeni mrizky pro prvni subspektrum 
 title('Subspectrum: 1')
 axis(handles.auto_data{1}); % skalovani os pro prvni subspektrum
 %-------------------------------------------------------------------------
 % (B) Nyni se vykresli prubeh prvniho koeficientu
 %-------------------------------------------------------------------------
 axes(handles.axes_coefficients);% prepnuti na osy pro kresleni koeficientu
 handles.typ='-ok'; % koeficienty se defaultne kresli spojovanou carou
 set(handles.context_menu_coefficients_line,'Checked','on'); % indikace v 
 % kontextovem menu, ze se koeficienty kresli spojovanou carou
 %-------------------------------------------------------------------------
 % Prubeh prvniho koeficientu se kresli bud pro jednu (B1) nebo vice serii
 % spekter(B2).
 %-------------------------------------------------------------------------
 if handles.serie_volba==1
  %------------------------------------------------------------------------   
  % B1) Zobrazuje se pouze jedna serie (jeden plot, tj. nepracuje se seriemi)
  % pro prvni koeficient.
  %------------------------------------------------------------------------
  % Matlab spojuje sousedni body carou -> Data je treba setridit podle x: 
  [x,indexy]=sort(handles.hodnoty);% tridi se x-ovy hodnoty pro koeficienty
  y=handles.V(:,1); % vyber prvniho koeficientu
  y=y(indexy); % setrideni y-ovych hodnot pro 1. koeficient podle jiz
  % setrideneho x. Vykresleni prubehu 1.koeficientu pro jednu serii spekter
  % (handle pro plot (handles.plot_coeff) se uchovava pro moznost zmeny 
  % typu grafu (bodovy nebo carovy graf) pomoci kontextoveho menu (viz
  % callback context_menu_coefficients)):
  handles.plot_coeff=plot(x,y,handles.typ,'MarkerSize',5,'MarkerFaceColor','g');
 else
  %------------------------------------------------------------------------  
  % B2) Zobrazuje se prvni koeficient pro vice serii spekter (vice plotu 
  % do jednoho grafu). Jednotlive serie se vykresli pomoci nadefinovane 
  % barvy. 
  %------------------------------------------------------------------------
  [y,indexy]=sort(handles.spektra_vyber);
  x_all=handles.hodnoty(indexy);
  y_all=handles.V(indexy,1);
  hold on % jednotlive serie pro 1. koeficient se pridavaji do jednoho plotu
  plot_index=0;
  if handles.serie_vyber(1)~=0 % Napred se vykresli prubeh 1. koeficientu
   % pro prvni serii spekter.
   plot_index=plot_index+1;
   from=1; % 1.serie zacina 1.spektrem (vzhledem k vybranym spektrum) 
   to=handles.serie_vyber(1); %1.serie konci spektrem handles.serie_vyber(1)
   % (vzhledem k vybranym spektrum)
   x=x_all(from:1:to);
   y=y_all(from:1:to);
   [x,indexy]=sort(x);
   y=y(indexy);
   handles.plot_coeff(plot_index)=plot(x,y,handles.typ,'MarkerSize',5,...
   'MarkerFaceColor',handles.serie_barva{1}); 
   % Vykresleni prubehu prvniho koeficientu pro 
   % prvni serii spekter. "Handle" pro plot (handles.plot_coeff(1)) se 
   % uchovava pro moznost zmeny typu grafu pomoci kontextoveho menu (bodovy
   % nebo carovy graf - viz callback context_menu_coefficients). 
  else % V pripade, ze prvni serie neobsahuje ani jedno spektrum -> to=0
   % Dalsi serie pak bude zacinat prvnim spektrem (vztazeno k vybranym 
   % spektrum)
   to=0;
  end
  % Po vykresleni prubehu 1. serie pro 1. koeficient se analogicky vykresli
  % v cyklu ostatni serie pro 1. koeficient. Dana serie pro zobrazeni musi
  % nutne obsahovat nenulovy pocet spekter: 
  for m=2:1:size(handles.serie_vyber,2) % size(handles.serie_vyber,2)=pocet serii
   if handles.serie_vyber(m)~=0 
    plot_index=plot_index+1;   
    from=to+1;
    to=from+handles.serie_vyber(m)-1;
    x=x_all(from:1:to);
    y=y_all(from:1:to);
    [x,indexy]=sort(x);
    y=y(indexy);
    handles.plot_coeff(plot_index)=plot(x,y,handles.typ,'MarkerSize',5,...
    'MarkerFaceColor',handles.serie_barva{m}); % Ulozi se take "handle" na plot 
   end 
  end
  %------------------------------------------------------------------------
  % Generovani legendy. Polozky legendy (ser:1, ser:2, ... ser:n) se
  % generuji pouze pro serie spekter majicich po vyberu (vyber v programu
  % background, orto) nenulovy pocet spekter:
  %------------------------------------------------------------------------
  n=0;
  for m=1:1:size(handles.serie_vyber,2)
   if handles.serie_vyber(m)~=0
    n=n+1;
    handles.legenda(n)={strcat('ser:',num2str(m))};
   end
  end
  handles.handle_legenda=legend(gca,n,handles.legenda);
  %------------------------------------------------------------------------
 end % end (if handles.serie_volba==1)
 %-------------------------------------------------------------------------
 grid minor % Zobrazeni mrizky pro prvni koeficient (pro pripad jedne nebo 
 % i vice serii spekter) 
 title('Coefficient: 1');
 axis(handles.auto_V{1}); % skalovani os pro prvni koeficient 
 %-------------------------------------------------------------------------
end % (if handles.volba==1 || handles.volba==2) 
%--------------------------------------------------------------------------
handles.current_adresar=pwd; % % Aktualni adresar. Pri ukladani dat (normal.
% spektra, dif. spektra, grad. spektra) se zobrazi tento adresar v 
% prislusnem dialog. okne jako "startovni". "Startovni" adresar se meni
% podle adresare posledniho ulozeni. 
handles.vyber=1; % Promenna handles.vyber v programu definuje poradi 
% zobrazovaneho spektra nebo vykreslovane dvojice subspektrum vs. koeficient
% (poradi je odvozeno od cislovani vybranych spekter).
% Defaultne je pri spusteni handles.vyber=1 
handles.axes_manual=0; % Pri spusteni programu maji osy meze podle rezimu 
% auto (handles.manual=1 by znacilo manualni skalovani os).
% Zelene tlacitko indikujici typ skalovani os (auto nebo manual):
set(handles.axes_mode_push,'String','auto','BackgroundColor','green');
%--------------------------------------------------------------------------
% Choose default command line output for spikie_FA_results
handles.output = hObject;
% Update handles structure
guidata(hObject, handles); % Aktualizace globalnich promennych
% UIWAIT makes spikie_FA_results wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%**************************************************************************
% --- Outputs from this function are returned to the command line.
function varargout = spikie_FA_results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
%**************************************************************************
% --- Executes on button press in select_number_push.
function [handle_plot_coeff,handle_legenda]=...
select_number_push_Callback(hObject,eventdata, handles)
% hObject    handle to select_number_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% V tomto Callbacku se podle vyberu uzivatele zobrazuje dane spektrum
% (handles.volba=1,2) nebo subspektrum vs. koeficient (handles.volba=3,4).
% Tento callback ma 2 vystupni parametry (handle na plot koeficientu nebo
% na legendu pro koeficienty). 
%--------------------------------------------------------------------------
% Pokud se spousti tento Callback z jineho Callbacku, tak se nezobrazuje
% dotaz na vyber spekter/subspekter. Dotaz na vyber se lisi podle toho,
% jestli vybirame spektra nebo subspektra vs. koeficienty.  
%--------------------------------------------------------------------------
if isequal(gcbo,handles.select_number_push)     
 if handles.volba==1 || handles.volba==2  
  prompt={'Select spectrum ?'};
  vyber='Choice of spectra';
 else  
  prompt={'Select subspectrum ?'};
  vyber='Choice of subspectra';
 end
 num_lines=1;
 odpoved_vyber=inputdlg(prompt,vyber,num_lines);
else
 odpoved_vyber={num2str(handles.vyber)};  
end
%--------------------------------------------------------------------------
if ~isequal(odpoved_vyber,{}) % Testovani, zda nedoslo ke stisku cancel
 [vyber,status]=str2num(odpoved_vyber{1});   
 if status~=0 && size(vyber,2)==1 && vyber <= handles.pocet && vyber >= 1 && ...
  isequal(floor(vyber),vyber) % test pripustnych hodnot (pripustne hodnota
  % je cele nezaporne cislo maximalne rovne poctu vybranych spekter nebo
  % poctu subspekter). 
  handles.vyber=vyber; % Pozadavane spektrum/subspektrum je pripustne
  %------------------------------------------------------------------------ 
  % 1) Nasledujici cast kodu se tyka zobrazovani spekter. Spektra se kresli  
  % do jednoho objektu typu osy (handles.osy_spektra). Zbyle 2 objekty typu
  % osy nejsou viditelne (handles.axes_subspectra,handles.axes_coefficients)
  %->(viz Callback: spikie_FA_results_OpeningFcn):
  %------------------------------------------------------------------------
  if handles.volba==1 || handles.volba==2 
   handle_plot_coeff=[];handle_legenda=[]; % Nezobrazuji se vysledky FA a
   % handle na plot koeficientu a legendu neni tedy treba. Callback ale
   % musi vracet tyto vystupni parametry
   %-----------------------------------------------------------------------
   % Vypis poradi vybraneho spektra na tlacitku:
   set(handles.text_spectrum_push,'String',strcat('spectrum:',...
   num2str(handles.vyber)),'BackgroundColor','green'); 
   %-----------------------------------------------------------------------
   if handles.serie_volba==1 % Pracuje se pouze s jednou sadou spekter. 
    % Vybrane spektrum se defaultne vykresli modrou barvou:    
    plot(handles.vlnocty,handles.spektra(:,handles.vyber),'b'); 
   else % Pracuje se s nekolika seriemi spekter. Vybrane spektrum se zobrazi 
   % barvou, ktera odpovida nadefinovane barve serie, ke ktere prislusi:
    orig_poradi_spektra=handles.spektra_vyber(:,handles.vyber);
    pocet_serii=size(handles.serie_vyber,2);
    hranice=handles.specifikace;
    hranice(pocet_serii)=handles.pocet_spekter_orig;
    for n=1:1:pocet_serii
     if orig_poradi_spektra <= hranice(n)
      serie_poradi=n;
      break
     end
    end
    plot(handles.vlnocty,handles.spektra(:,handles.vyber),...
    handles.serie_barva{serie_poradi});
   end
   grid minor % Mrizka pro dane spektrum
   %-----------------------------------------------------------------------
   % Generovani legendy (jako v iniciacnim callbacku spikie_FA_results_OpeningFcn)
   % Ted je to ale pro vybrane spektrum a ne pro prvni.
   %-----------------------------------------------------------------------
   if handles.serie_volba==1 % Nezobrazuje se cislovani serii (nepracuje se
    % seriemi). 
    handles.legenda={['par:',num2str(handles.spektra_vyber(handles.vyber))]};
   else % handles.serie_volba==2 (zobrazuje se cislovani serii) 
    handles.legenda={['par:',num2str(handles.spektra_vyber(handles.vyber)),...
    '  ser:',num2str(serie_poradi)]};
   end
   legend(gca,'Location','NorthEast',handles.legenda);
   %-----------------------------------------------------------------------
   % Rezim automat. nebo manual. skalovani os pro dane spektrum
   %-----------------------------------------------------------------------
   if (handles.axes_manual==0); % rezim auto
    axis(handles.auto_data{handles.vyber});  
   else % rezim manual (handles.axes_manual=1)
    axis(handles.manual_data{handles.vyber}); 
   end;
   %-----------------------------------------------------------------------
   % 2) Kresli se vysledky faktorove analyzy (subspektrum vs. koeficient).  
   % V tomto pripade nejsou osy pro kresleni spekter viditelne. Pouzivaji 
   % se misto toho dva jine objekty typu osy: handles.axes_subspectra
   %(kresleni subspekter) a handles.axes_coefficients(kresleni koeficientu)
   % ->(viz Callback: spikie_FA_results_OpeningFcn). Napred se vykresli pozadovane
   % subspektrum (A) a pote odpovidajici koeficient (B).
   %-----------------------------------------------------------------------
  else % handles.volba==3 || handles.volba==4 
   % Vypis kolikate subs. vs. koef. se kresli je zobrazen na tlacitku:
   set(handles.text_spectrum_push,'String',...
   strcat('subspectrum:',num2str(handles.vyber)),'BackgroundColor','green'); 
   %-----------------------------------------------------------------------
   % (A) Napred se zobrazuje vybrane subspektrum 
   %------------------------------------------------------------------------
   axes(handles.axes_subspectra); % Prepnuti na osy pro kresleni subspekter 
   plot(handles.vlnocty,handles.spektra(:,handles.vyber),'b'); % vykresleni
   % pozadovaneho subspektra
   title(['Subspectrum: ',num2str(handles.vyber)]);
   grid minor % Zobrazeni mrizky pro dane subspektrum
   %------------------------------------------------------------------------
   % Rezim automat. nebo manual. skalovani os pro vybrane subspektrum
   %------------------------------------------------------------------------
   if(handles.axes_manual==0); % rezim auto
    axis(handles.auto_data{handles.vyber}); 
   else % rezim manual (handles.axes_manual=1)
    axis(handles.manual_data{handles.vyber}); 
   end; 
   %-----------------------------------------------------------------------
   %(B) Nyni se zobrazi prislusny prubeh koeficientu pro vybrane subspektrum.
   % Tento prubeh se kresli bud pro jednu (B1) nebo vice spektralnich
   % serii(B2).
   %-----------------------------------------------------------------------
   axes(handles.axes_coefficients); % prepnuti na osy pro zobrazeni
   % koeficientu 
   %-----------------------------------------------------------------------
   if handles.serie_volba==1
    %----------------------------------------------------------------------
    % (B1) Zobrazuje se pouze jedna serie koeficientu (jeden plot).
    %----------------------------------------------------------------------
    handle_legenda=[]; % Callback musi vracet handle na legendu pro
    % koeficienty, i kdyz neni v tomto pripade tento handle treba
    % Matlab spojuje dva sousedni body carou->Data je treba setridit podle x. 
    [x,indexy]=sort(handles.hodnoty); % tridi se x-ovy hodnoty
    y=handles.V(:,handles.vyber); % vyber pozadovaneho koeficientu (sloupec 
    % matice koeficientu handles.V)
    y=y(indexy); % Setrideni y-ovych hodnot pro pozadovany koeficient podle 
    % jiz setrideneho x
    handles.plot_coeff=plot(x,y,handles.typ,'MarkerSize',5,'MarkerFaceColor','g');
    grid minor % Zobrazeni mrizky pro jednu serii koeficientu 
   else
    %----------------------------------------------------------------------
    % B2) Zobrazuje se dany koeficient pro vice serii spekter. Napred je 
    % treba smazat predchozi graf (cla). Pote se pridavaji do jednoho grafu 
    % grafy odpovidajici ruznym seriim spekter (hold on). 
    %----------------------------------------------------------------------
    cla 
    hold on
    [y,indexy]=sort(handles.spektra_vyber);
    x_all=handles.hodnoty(indexy);
    y_all=handles.V(indexy,handles.vyber);
    plot_index=0; % Pocet vykreslenych plotu (serie, ktere po vybrani 
    % neobsahují spektra, se nevykresli)
    if handles.serie_vyber(1)~=0  % Napred se vykresli koeficienty
     % odpovidajici prvni serii
     plot_index=plot_index+1;   
     from=1; %1.serie zacina prvnim spektrem (vzhledem k poradi vybranych spekter)
     to=handles.serie_vyber(1);%1.serie konci spektrem handles.serie_vyber(1) 
     x=x_all(from:1:to);
     y=y_all(from:1:to);
     [x,indexy]=sort(x); % tridi se x-ove hodnoty v ramci serie
     y=y(indexy); % setrideni odpovidajicich y-ovych hodnot podle setrideneho x
     handles.plot_coeff(plot_index)=plot(x,y,handles.typ,'MarkerSize',5,...
     'MarkerFaceColor',handles.serie_barva{1}); 
    else % V pripade, ze prvni serie neobsahuje ani jedno spektrum -> to=0
     % Dalsi serie pak bude zacinat prvnim spektrem (vztazeno k poradi  
     % vybranych spekter) 
     to=0;   
    end
    % Po moznem vykresleni prubehu vybraneho koeficientu pro prvni serii se
    % v cyklu vykresli ostatni serie. Serie pro zobrazeni musi obsahovat
    % nenulovy pocet spekter: 
    for m=2:1:size(handles.serie_vyber,2) % size(handles.serie_vyber,2)=pocet serii
     if handles.serie_vyber(m)~=0
      plot_index=plot_index+1;      
      from=to+1;
      to=from+handles.serie_vyber(m)-1;
      x=x_all(from:1:to);
      y=y_all(from:1:to);
      [x,indexy]=sort(x);
      y=y(indexy);
      handles.plot_coeff(plot_index)=plot(x,y,handles.typ,'MarkerSize',5,...
      'MarkerFaceColor',handles.serie_barva{m}); % Ulozi se take "handle" 
      % pro dany plot
     end
    end
    %----------------------------------------------------------------------
    % Generovani legendy. Polozky legendy (ser:1, ser:2,... ser:n) se
    % generuji pouze pro serie spekter majicich po vyberu (vyber spekter
    % pomoci programu background nebo orto) nenulovy pocet spekter:
    %----------------------------------------------------------------------
    n=0;   
    for m=1:1:size(handles.serie_vyber,2)
     if handles.serie_vyber(m)~=0
      n=n+1;
      handles.legenda(n)={strcat('ser:',num2str(m))};
     end
    end
    handles.handle_legenda=legend(gca,n,handles.legenda);
    handle_legenda=handles.handle_legenda;
    %----------------------------------------------------------------------
   end % end (if handles.serie_volba==1)
   %-----------------------------------------------------------------------
   % Rezim automat. nebo manual. skalovani os pro koeficienty
   %----------------------------------------------------------------------- 
   if(handles.axes_manual==0); % rezim auto  
    axis(handles.auto_V{handles.vyber}); % automat. nastaveni mezi os 
   else % rezim manual (handles.axes_manual=1)
    axis(handles.manual_V{handles.vyber}); % manualni nastaveni mezi os 
   end
   title(['Coefficient: ',num2str(handles.vyber)]);
   %-----------------------------------------------------------------------
   % V rezimu hold on (zobrazovani koeficientu pro serii spekter) neni 
   % treba znova kreslit mrizku (v iniciacnim callbacku spikie_FA_results_OpeningFcn
   % byla totiz mrizka jiz vykreslena pomoci grid minor). Opakovane pouziti
   % grid minor by vedlo ke smazani mrizky! 
   %-----------------------------------------------------------------------
   handle_plot_coeff=handles.plot_coeff; % Tento callback lze take volat z 
   % jinych callbacku (select_down_push, select_up_push) a vraci promennou
   % handle_plot_coeff. Tato promenna obsahuje handle (vice handlu pro vice
   % spektralnich serii) na aktualni graf koeficientu
  end % if handles.volba==1 || handles.volba==2 
 %-------------------------------------------------------------------------
 % Zadany nepripustne hodnoty pro vyber spektra/subspektra. Podle toho
 % jestli prohlizime spektra nebo subspektra vs. koeficienty se vypise
 % cervena chybova hlaska.
 %-------------------------------------------------------------------------
 else
  if handles.volba==1 || handles.volba==2   
   set(handles.text_spectrum_push,'String', 'No such spectrum', ...
   'BackgroundColor','red');       
  else
   set(handles.text_spectrum_push,'String', 'No such subspectrum', ...
   'BackgroundColor','red');
  end
 end % if (testovani pripustnych hodnot) 
end %(if testovani zda nebylo stisknuto cancel)
guidata(hObject, handles); % aktualizace globalnich promennych  
%**************************************************************************
% --- Executes on button press in select_up_push.
function select_up_push_Callback(hObject, eventdata, handles)
% hObject    handle to select_up_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Prohlizeni spektra nebo subspektra vs. koeficientu pro poradove cislo o 
% jednicku vyssi. 
%--------------------------------------------------------------------------
if handles.vyber < handles.pocet % Inkrementovat lze nenajvys predposledni
 % spektrum/subspektrum.
 handles.vyber=handles.vyber+1; % inkrementace
 % Pro inkrementovane spektrum / subspektrum vs. koeficient se provede vse
 % jako v Callbacku select_number_push_Callback. Protoze se Callback
 % select_number_push_Callback vola v jinem Callbacku, tak se nezobrazuje
 % dotaz na vyber spekter/subspekter (vyber odpovida inkrementovanemu
 % spektru/subspektru) 
 [handles.plot_coeff,handles.handle_legenda]= select_number_push_Callback(handles.select_up_push,...
 eventdata,handles);
%--------------------------------------------------------------------------
% Nepripustna inkrementace. Dosazeno posledni spektrum/subspektrum. Indikace
% chyboveho stavu podle toho, jestli pracujeme se spektry ci subspektry.
%--------------------------------------------------------------------------
else
 if handles.volba==1 || handles.volba==2
  set(handles.text_spectrum_push,'String', strcat('last spectrum:',...
  num2str(handles.pocet)),'BackgroundColor','red');   
 else
  set(handles.text_spectrum_push,'String',...
  strcat('last subspectrum:',num2str(handles.pocet)), ...
  'BackgroundColor','red'); 
 end
 %------------------------------------------------------------------------- 
end % end (if handles.vyber < handles.pocet) - test pripustne inkrementace
guidata(hObject,handles); % aktualizace globalnich promennych
%**************************************************************************
% --- Executes on button press in select_down_push.
function select_down_push_Callback(hObject, eventdata, handles)
% hObject    handle to select_down_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Prohlizeni spektra nebo subspektra vs. koeficientu pro poradove cislo o 
% jednicku nizsi
%--------------------------------------------------------------------------
if handles.vyber > 1 % Dekrementovat lze minimalne druhe spektrum/subspektrum
 handles.vyber=handles.vyber-1; % dekrementace
 % Pro dekremetovane spektrum / subspektrum vs. koeficient se provede vse
 % jako v Callbacku select_number_push_Callback. Protoze se 
 % Callback select_number_push_Callback vola v jinem Callbacku, tak se 
 % nezobrazuje dotaz na vyber spekter/subspekter (vyber odpovida dekreme-
 % ntovanemu spektru/subspektru) 
 [handles.plot_coeff,handles.handle_legenda]=select_number_push_Callback(handles.select_up_push,...
 eventdata, handles);
%--------------------------------------------------------------------------
% Nepripustna dekrementace. Dosahli jsme prvni spektrum/subspektrum.Indikace
% chyboveho stavu podle toho, jestli pracujeme se spektry ci subspektry.
%--------------------------------------------------------------------------
else 
 if handles.volba==1 || handles.volba==2 
  set(handles.text_spectrum_push,'String','first spectrum:1',...
  'BackgroundColor','red'); 
 else
  set(handles.text_spectrum_push,'String','first subspectrum:1', ...
  'BackgroundColor','red'); 
 end 
end % end (if handles.vyber > 1)  test pripustne dekrementace
guidata(hObject,handles);% aktualizace globalnich promennych 
%**************************************************************************
% --- Executes on button press in axes_invert_push.
function axes_invert_push_Callback(hObject, eventdata, handles)
% hObject    handle to axes_invert_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Zobrazeni invertovaneho (vynasobeni -1) spektra nebo subspektra vs. 
% koeficientu.   
%--------------------------------------------------------------------------
% Napred se provede inverze vybraneho spektra nebo subspektra:
handles.spektra(:,handles.vyber)=-handles.spektra(:,handles.vyber);
%--------------------------------------------------------------------------
% Otocena spektra nebo subspektra maji jine skalovani os. Manualni
% skalovani pro vybrany spektrum nebo subspektrum je po otoceni odvozeno od
% automatickeho:
%--------------------------------------------------------------------------
osy=axes_adjust([handles.vlnocty handles.spektra(:,handles.vyber)]);
handles.auto_data(handles.vyber)={osy{1}}; % automaticke skalovani 
handles.manual_data(handles.vyber)={osy{1}}; % manualni skalovani 
%--------------------------------------------------------------------------
% V pripade vykreslovani vysledku faktorove analyzy musi byt provedeno take
% otoceni vybraneho koeficientu a uprava mezi jeho os. Manualni skalovani
% os pro vybrany koeficient je po otoceni odvozeno od automatickeho:
%--------------------------------------------------------------------------
if handles.volba==3 || handles.volba==4 
 handles.V(:,handles.vyber)=-handles.V(:,handles.vyber);
 osy=axes_adjust([handles.hodnoty handles.V(:,handles.vyber)]);
 handles.auto_V(handles.vyber)={osy{1}}; % automaticke skalovani
 handles.manual_V(handles.vyber)={osy{1}}; % manualni skalovani 
end
% Pro vykresleni invertovaneho spektra/subspektra vs. koeficientu staci 
% zavolat Callback: select_number_push_Callback.
[handles.plot_coeff,handles.handle_legenda]=select_number_push_Callback(handles.axes_invert_push,...
eventdata, handles);
guidata(hObject,handles); % aktualizace globalnich promennych 
%**************************************************************************
% --- Executes on button press in subspectra_axes_limits.
function subspectra_axes_limits_Callback(hObject, eventdata, handles)
% hObject    handle to subspectra_axes_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Manualni nastaveni mezi os pro 1) vybrane spektrum (handles.volba=1,2) 
% nebo pro 2) subspektrum (handles.volba=3,4). 
%--------------------------------------------------------------------------
meze_os=handles.manual_data{handles.vyber}; % Predchozi nastaveni mezi os 
% pro spektra/subspektra v rezimu manual se bere jako defaultni pri dalsi 
% zmene mezi os (funkce axes_limits)
[status,x_min,x_max,y_min,y_max]=...
axes_limits(meze_os(1),meze_os(2),meze_os(3),meze_os(4));
if status==1 % V pripade zadani pripustnych mezi dojde k prechodu do rezimu
 % manual
 handles.axes_manual=1; % Indikace rezimu manual (handles.axes_manual=1)
 % Mod manual je indikovan zelenym tlacitkem s napisem manual: 
 set(handles.axes_mode_push,'String','manual','BackgroundColor','green');
 if handles.volba==1 || handles.volba==2 % Zobrazovani spekter
  axes(handles.osy_spektra) % Prepnuti na osy pro kresleni spekter
  legend(gca,1,handles.legenda); % V pripade zmeny mezi os pro spektra  
  % je treba znova vykreslit legendu (pokud se kresli)
 else %  handles.volba==3 || handles.volba==4 -> zobrazovani vysledku FA 
  axes(handles.axes_subspectra) % Prepnuti na osy pro kresleni subspekter   
 end
 axis([x_min,x_max,y_min,y_max]); % Zmena mezi os podle zadanych parametru
 % Aktualizace novych mezi os pro vybrane spektrum nebo subspektrum v rezimu
 % manual:   
 handles.manual_data(handles.vyber)={[x_min,x_max,y_min,y_max]};
 guidata(hObject,handles);
end
%**************************************************************************
% --- Executes on button press in coefficients_axes_limits_X_osa_limits.
function coefficients_axes_limits_Callback(hObject, eventdata, handles)
% hObject    handle to coefficients_axes_limits_X_osa_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Manualni nastaveni mezi os pro koeficienty (handles.volba=3,4) 
%--------------------------------------------------------------------------
meze_os=handles.manual_V{handles.vyber}; % Predchozi nastaveni mezi os v 
% rezimu manual se bere jako defaultni pri dalsi zmene mezi os (funkce
% axes_limits)
[status,x_min,x_max,y_min,y_max]=...
 axes_limits(meze_os(1),meze_os(2),meze_os(3),meze_os(4));
if status==1 %V pripade zadani pripustnych mezi, dojde k prechodu do rezimu
 % manual   
 handles.axes_manual=1; %Indikace rezimu manual (handles.axes_manual=1)
 % Mod manual je zobrazen zelenym napisem manual na tlacitku: 
 set(handles.axes_mode_push,'String','manual','BackgroundColor','green');
 axes(handles.axes_coefficients)% Prepnuti na osy pro kresleni koeficientu   
 axis([x_min,x_max,y_min,y_max]); % Zmena mezi os podle zadanych parametru
 if handles.serie_volba==2 % Prace s vice seriemi  
  handles.handle_legenda=legend(gca,1,handles.legenda); % Po zmene mezi os 
  % pro koeficienty je treba znovu vykreslit legendu (pokud se kresli) 
 end
 % Aktualizace novych mezi os pro koeficienty v rezimu manual:
 handles.manual_V(handles.vyber)={[x_min,x_max,y_min,y_max]};
 guidata(hObject,handles);
end
%**************************************************************************
% --- Executes on button press in text_spectrum_push.
function text_spectrum_push_Callback(hObject, eventdata, handles)
% hObject    handle to text_spectrum_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Toto tlacitko slouzi jenom pro zobrazovani informace o poradi
% vykreslovaneho spektra nebo subspektra (a prislusnych koeficientu)
%**************************************************************************
% --- Executes on button press in axes_mode_push.
function axes_mode_push_Callback(hObject, eventdata, handles)
% hObject    handle to axes_mode_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Toto tlacitko slouzi jenom pro zobrazovani informace o pouzitem modu
% skalovani os a pro prechod z manualniho (rezim manual) do automatickeho
% (rezim auto) rezimu skalovani os 
%--------------------------------------------------------------------------
handles.axes_manual=0; % indikace rezimu automatickeho skalovani os
% Rezim auto je indikovan zelenym napisem auto na tlacitku:
set(handles.axes_mode_push,'String','auto','BackgroundColor','green');
 %-------------------------------------------------------------------------
 % Automaticke skalovani os pro spektra 
 %-------------------------------------------------------------------------
 if handles.volba==1 || handles.volba==2 
  axes(handles.osy_spektra) % prepnuti na osy pro kresleni spekter
  axis(handles.auto_data{handles.vyber}); % automat. nastaveni mezi os
  legend(gca,1,handles.legenda); % Po zmene mezi os pro spektra je treba 
  % znovu zobrazit legendu (pokud se kresli)
 %-------------------------------------------------------------------------
 % Automaticke skalovani os pro subspektra vs. koeficienty
 %-------------------------------------------------------------------------
 else %(handles.volba 3 nebo 4)  
  axes(handles.axes_subspectra) % prepnuti na osy pro kresleni subspekter
  axis(handles.auto_data{handles.vyber}); % automat. nastaveni os pro subs.
  axes(handles.axes_coefficients) % prepnuti na osy pro kresleni koef. 
  axis(handles.auto_V{handles.vyber}); % automat. nastaveni os pro koef.
  if handles.serie_volba==2 
   handles.handle_legenda=legend(gca,1,handles.legenda); % Po zmene mezi os 
   % pro koeficienty je treba znovu zobrazit legendu (pokud se kresli)
  end  
 end
guidata(hObject,handles);
%**************************************************************************
function context_menu_coefficients_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_coefficients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Kontextove menu pro koeficienty. Z kontextoveho menu lze vybrat typ grafu
% pro koeficienty. Graf muze byt bud carovy (spojovani jednotlivych bodu
% primou carou) nebo bodovy (samotne body). Z kontextoveho menu lze vyvolat
% rovnez tabulku rozdeleni spekter do jednotlivych serii. Kontextove menu je
% asociovano s osami pro zobrazeni koeficientu (handles.axes_coefficients). 
%**************************************************************************
function context_menu_coefficients_line_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_coefficients_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Polozka kontextoveho menu pro koeficienty (nastaveni typu grafu pro prubeh
% koeficientu na carovy graf -> z kontextoveho menu se vybere line).
% K dispozici je "handle" na aktualni graf koeficientu: handles.plot_coeff
% (v pripade vice serii obsahuje promenna handles.plot_coeff ve skutecnosti
% pole "handlu" - tj. jeden "handle" pro jeden plot).
%--------------------------------------------------------------------------
handles.typ='-ok'; % kresli se cerna cara 
set(handles.plot_coeff,'LineStyle','-');
% indikace v kontextovem menu, ze se jedna o carovy graf:
set(hObject,'Checked','on'); 
set(handles.context_menu_coefficients_points,'Checked','off'); 
guidata(hObject,handles);
%**************************************************************************
function context_menu_coefficients_points_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_coefficients_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Polozka kontextoveho menu pro koeficienty (nastaveni typu grafu pro prubeh
% koeficientu na bodovy graf -> z kontextoveho menu se vybere points).
% K dispozici je "handle" na aktualni graf koeficientu: handles.plot_coeff
% (v pripade vice serii obsahuje promenna handles.plot_coeff ve skutecnosti
% pole "handlu" - tj. jeden "handle" pro jeden plot).
%--------------------------------------------------------------------------
handles.typ='ok'; % kresli se body s cernou hranici
set(handles.plot_coeff,'LineStyle','none');
% indikace v kontextovem menu, ze se jedna o bodovy graf:
set(hObject,'Checked','on');
set(handles.context_menu_coefficients_line,'Checked','off'); 
guidata(hObject,handles);
%**************************************************************************
function context_menu_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Kontextove menu pro spektra. Toto kontextove menu je asociovano s objektem
% osy pro zobrazeni spekter (handles.osy_spektra). Toto menu umoznuje
% zobrazit vice spekter do jednoho grafu, tabulku rozdeleni spekter do
% serii, normalizaci spekter, tvorbu diferencnich a gradientovych spekter
%**************************************************************************
function Spectral_series_info_coefficients_Callback(hObject, eventdata, handles)
% hObject    handle to Spectral_series_info_coefficients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Polozka kontextoveho menu pro spektra umoznujici zobrazit tabulku 
% rozdeleni spekter do jednotlivych serii
%--------------------------------------------------------------------------
% Informace o rozdeleni spekter do spektralnich serii
%--------------------------------------------------------------------------
% Okno pro vypis informaci
h_table=figure;
set(h_table,'MenuBar','none','Name','Info about spectral series',...
'NumberTitle','off','Units','normalized','Position',[0.5,0.37,0.29,0.30]);
%--------------------------------------------------------------------------
pocet_orig=handles.pocet_spekter_orig; % pocet puvodnich spekter
% Pri praci s vice seriemi se do promenne serie_vyber_orig ulozi pocty 
% puvodnich spekter v jednotlivych seriich
if handles.serie_volba==2 
 vyber_vse=1:1:pocet_orig;
 pocet_serii=size(handles.serie_vyber,2);
 serie_vyber_orig(1)=sum(vyber_vse <= handles.specifikace(1));
 for n=1:1:pocet_serii-2
  serie_vyber_orig(n+1)=sum(vyber_vse <= handles.specifikace(n+1))-... 
  sum(vyber_vse <= handles.specifikace(n));
 end
 serie_vyber_orig(pocet_serii)=pocet_orig ...
 -sum(vyber_vse <=handles.specifikace(pocet_serii-1));
end
%-------------------------------------------------------------------------
 % Promenna hodnoty obsahuje pro kazde spektrum hodnotu 'Yes' nebo 'No' 
 % podle toho jestli spektrum bylo nebo nebylo vybrano:
 for m=1:1:pocet_orig
  if find(handles.spektra_vyber==m) 
   occurrence(m)={'Yes'};
  else
   occurrence(m)={'No'};
  end 
 end
%--------------------------------------------------------------------------
if handles.hodnoty_typ==3 % Nacteny hodnoty ze souboru
 table_string(1)={'Orig. spectrum  |  occurrence  |  values from file'};    
else
 table_string(1)={'Orig. spectrum  |  occurrence '}; 
end
table_string(2)={repeat_char('*',54)};   
%--------------------------------------------------------------------------   
% Tabulka v pripade jedne serie spekter
%--------------------------------------------------------------------------
if handles.serie_volba==1
 for i=1:1:pocet_orig
  if handles.hodnoty_typ~=3  
   table_string(2+i)={[num2str(i),'  |  ',num2str(occurrence{i})]};
  else 
   table_string(2+i)={[num2str(i),'  |  ',num2str(occurrence{i}),'  |  ',...
   num2str(handles.hodnoty_soubor(i))]};   
  end
 end
 table_string(pocet_orig+3)={repeat_char('*',54)};
 table_string(pocet_orig+4)={'Selected spectrum  |  Orig. spectrum'};
 index_hodnota=pocet_orig+5;
 for i=1:size(handles.spektra_vyber,2)
  table_string(index_hodnota+i)={[num2str(i),'  |  ',num2str(handles.spektra_vyber(i))]};
 end
%-------------------------------------------------------------------------- 
% Tabulka v pripade vice serii spekter
%--------------------------------------------------------------------------
else
 index_hodnota=1;
 radek=1; % Radek tabulky  
 for i=1:1:pocet_serii
  if serie_vyber_orig(i)~=0
   table_string(radek+1)={repeat_char('*',54)};   
   table_string(radek+2)={['Series: ',num2str(i)]};
   table_string(radek+3)={['All spectra: ',num2str(serie_vyber_orig(i))]};
   table_string(radek+4)={['Present: ',num2str(handles.serie_vyber(i))]};
   switch handles.serie_barva{i}
    case 'r'
     barva='red'; % cervena barva  
    case 'b'
     barva='blue'; % modra barva       
    case 'g'
     barva='green'; % zelena barva      
    case 'y'
     barva='yellow'; % zluta barva      
    case 'm'
     barva='magenta'; % fialova barva      
    case 'c'
     barva='cyan'; % azurova barva         
    case 'k'
     barva='black'; % cerna barva      
   end
   table_string(radek+5)={['Color: ',barva]};
   radek=radek+6;
   for j=1:1:serie_vyber_orig(i)
    radek=radek+1;
    if handles.hodnoty_typ~=3 % Nejsou nacteny hodnoty ze souboru 
     table_string(radek)={[num2str(index_hodnota),...
     '  |  ',num2str(occurrence{index_hodnota})]};
     index_hodnota=index_hodnota+1;
    else % Nacteny hodnoty ze souboru
     table_string(radek)={[num2str(index_hodnota),...
     '  |  ',num2str(occurrence{index_hodnota}),...
     '  |  ',num2str(handles.hodnoty_soubor(index_hodnota))]};
     index_hodnota=index_hodnota+1;
    end
   end
  end
 end
 table_string(radek+1)={repeat_char('*',54)};
 table_string(radek+2)={'Selected spectrum  |  Orig. spectrum'};
 radek=radek+3;
 for i=1:size(handles.spektra_vyber,2)
  table_string(radek+i)={[num2str(i),'  |  ',num2str(handles.spektra_vyber(i))]};
 end
end
%--------------------------------------------------------------------------
% listbox pro vypis informaci
uicontrol('Parent',h_table,'Style','listbox','Units','normalized',...
'Position',[0.076,0.098,0.861,0.81],'String',table_string);
%**************************************************************************
function Spectral_series_info_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to Spectral_series_info_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Spectral_series_info_coefficients_Callback(handles.Spectral_series_info_coefficients, eventdata, handles);
%**************************************************************************
function more_graph_Callback(hObject, eventdata, handles)
% hObject    handle to more_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Z kontextoveho menu pro spektra (asociovano s handles.osy_spektra) lze
% vybrat polozku pro zobrazeni vice spekter. Tato polozka ma dalsi dve
% polozky -> zobrazeni vice spekter automatickou barvou nebo barvou podle
% serii (viz dale).
%**************************************************************************
function spectra_automatic_color_Callback(hObject, eventdata, handles)
% hObject    handle to spectra_automatic_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Z kontextoveho menu pro spektra (asociovano s handles.osy_spektra) lze
% vybrat polozku pro zobrazeni vice spekter (tato polozka ma dalsi dve
% polozky -> zobrazeni spekter automatickou barvou nebo barvou podle serii).
% V tomto callbacku maji spektra automatickou barvu (kazde spektrum ma
% jinou barvu, max. 7 barev -> max. 7 spekter). Pokud je tento Callback
% volan z jineho Callbacku, tak v zavislosti na hodnote promenne
% handles.volba_zobrazeni se kresli bud spektra s barvami podle serii nebo
% gradientova a diferencni spektra s barvou automatickou nebo podle serii.
% Promenna handles.volba_zobrazeni nabyva hodnot:  
% 0 ......spektra, barvy: automaticky   
% 1 ......spektra, barvy: podle serii
% 2 ......gradient spekter, barvy: automaticky
% 3 ......gradient spekter, barvy: podle serii
% 4 ......diferencni spektra, barvy: automaticky 
% 5 ......diferencni spektra, barvy: podle serii
%--------------------------------------------------------------------------
if isequal(gcbo,handles.spectra_automatic_color) 
 volba=0; % spektra s automatickou barvou
else % Callback je spusten v jinem Callbacku -> volba=1,2,3,4 nebo 5
 volba=handles.volba_zobrazeni; 
end
if volba==2 || volba==3 %gradient spekter (musi se nacist stupen gradientu)
 grad_stupen=handles.gradient_stupen;
end
if volba==4 || volba==5 % diferencni spektra (musi se nacist ktere spektrum
 % (cislo spektra) se bude odecitat od dale vybranych spekter))    
 spektrum_diff=handles.spektrum_diff;
end
%--------------------------------------------------------------------------
% Dotaz na vyber spekter v zavislosti na handles.volba_zobrazeni:
if volba==0 || volba==1 % Prohlizeni spekter
 [status,vyber,pocet_vyber]=dotaz_vyber(handles.pocet,...
 'Select spectra to view',{['1:',num2str(size(handles.spektra_vyber,2))]},1,1);
elseif volba==2 || volba==3 % Prohlizeni gradientovych spekter 
 [status,vyber,pocet_vyber]=dotaz_vyber(handles.pocet,...
 'Select spectra from which to form gradient',...
 {['1:',num2str(size(handles.spektra_vyber,2))]},1,1);
else % Prohlizeni diferencnich spekter
 [status,vyber,pocet_vyber]=dotaz_vyber(handles.pocet,...
 'Select spectra from which to substract chosen spectrum',...
 {['1:',num2str(size(handles.spektra_vyber,2))]},1,1);   
end  
%--------------------------------------------------------------------------
if status~=0 %test, zda jsou vybrana pripustna spektra (funkce dotaz_vyber) 
 %-------------------------------------------------------------------------   
 % Priprava dat pro zobrazeni:   
 %-------------------------------------------------------------------------
 % Data s aktualni x-ovou skalou (orezani primo v programu spikie_FA_results):
 if handles.axes_manual
  x_min_current=handles.manual_data{handles.vyber}(1);
  x_max_current=handles.manual_data{handles.vyber}(2);
 else
  x_min_current=handles.auto_data{handles.vyber}(1);
  x_max_current=handles.auto_data{handles.vyber}(2);   
 end
 [status,spektra_current]=orezani_spekter([handles.vlnocty handles.spektra],...
 [x_min_current,x_max_current],1,0); % Data s ohledem  na aktualni x-ovou
 % skalu (vyber v programu spikie_FA_results)
 if status
  vlnocty_current=spektra_current(:,1); % X-ova skala    
  spektra_current=spektra_current(:,2:end); % Spektra bez x-ove skaly
 else
  uiwait(errordlg(['Selected range contains less than 2 points',...
  ' -> data will be displayed with the whole range of x values.'],...
  'Insufficient number of points '));   
  vlnocty_current=handles.vlnocty;
  spektra_current=handles.spektra;
 end
 data=spektra_current(:,vyber); % Data pro zobrazeni obsahuji spektra,ktera
 % jsou v poradi jak byla vybrana. V pripade zobrazeni gradientu nebo 
 % diferencnich spekter je treba jeste tyto spektra urcit:
 if volba==2 || volba==3 % Pro vybrana spektra (matice data) se spocita
  % gradient pozadovaneho stupne (grad_stupen) 
  data=gradient_more(data,grad_stupen);
 end
 if volba==4 || volba==5  % Od vybranych spekter (matice data) se odecte    
  % dane spektrum (cislo spektra je spektrum_diff) 
  spektrum=spektra_current(:,spektrum_diff); % Vybrane spektrum pro odecteni
  % od ostatnich spekter. Odecteni se provede v cyklu: 
  for m=1:1:pocet_vyber
   data(:,m)=data(:,m)-spektrum;   
  end
 end
 %-------------------------------------------------------------------------
 obrazek_data=figure; % obrazek pro zobrazeni dat
 % Jmeno obrazku se lisi podle toho jaka data se zobrazuji
 if volba==0 || volba==1
  set(obrazek_data,'MenuBar','figure','Name','Figure of selected spectra',...
  'NumberTitle','off');
 elseif volba==2 || volba==3 
  set(obrazek_data,'MenuBar','figure','Name','Gradient of selected spectra',...
  'NumberTitle','off');
 else
  set(obrazek_data,'MenuBar','figure','Name',['Difference spectra',...
  ' (substraction of spectrum No. ',num2str(spektrum_diff),...
  ' from selected spectra)'],'NumberTitle','off');
 end
 %-------------------------------------------------------------------------    
 % Rozdeleni spekter do serii 
 %-------------------------------------------------------------------------
 if handles.serie_volba==2 % Musi se pracovat s vice seriemi
  hranice=handles.specifikace;
  pocet_serii=size(handles.specifikace,2)+1;
  hranice(size(handles.specifikace,2)+1)=handles.pocet_spekter_orig;   
  for m=1:1:pocet_vyber    
   orig_poradi_spektra=handles.spektra_vyber(vyber(m));
   for n=1:1:pocet_serii  
    if orig_poradi_spektra <= hranice(n)
     serie_poradi(m)=n;
     break
    end
   end
  end
 end % end if handles.serie_volba==2
 %-------------------------------------------------------------------------
 grid minor 
 hold on % Bude se prekreslovat vice spekter do jednoho obrazku
 if volba==0 || volba==2 || volba==4 % Automaticke barveni (cykluje se pres 7 barev)
  barva={'r','b','g','y','m','c','k'};
  n=1;
  for m=1:1:pocet_vyber  
   plot(vlnocty_current,data(:,m),barva{n});
   if mod(m,7)==0
    n=0;   
   end
   n=n+1;
  end
 else % Barvy podle serii
  for m=1:1:pocet_vyber  
   plot(vlnocty_current,data(:,m),handles.serie_barva{serie_poradi(m)});
  end
 end
 %-------------------------------------------------------------------------
 % Generovani legendy:
 %-------------------------------------------------------------------------
 if pocet_vyber<=20 % Legenda ma maximalne 15 polozek 
  if handles.serie_volba==1 
   for m=1:1:pocet_vyber
    legenda(m)={['spec:',num2str(vyber(m)),'  par:',...
    num2str(handles.spektra_vyber(vyber(m)))]};
   end    
  else
   for m=1:1:pocet_vyber 
    legenda(m)={['spec:',num2str(vyber(m)),'  par:',...
    num2str(handles.spektra_vyber(vyber(m))),'  ser:',num2str(serie_poradi(m))]};
   end
  end
  legend(gca,pocet_vyber,legenda); % Vytvoreni legendy
 end
 %-------------------------------------------------------------------------
 % Skalovani os se voli tak, aby byla videt vsechna spektra:
 osy=axes_adjust([vlnocty_current data]);
 meze=osy{1};
 x_min=meze(1);
 x_max=meze(2);
 y_min=meze(3);
 y_max=meze(4);
 if size(vyber,2)>1
  for k=2:1:size(vyber,2)    
   meze=osy{k};
   y_min_dalsi=meze(3);
   y_max_dalsi=meze(4);
   if y_min_dalsi<y_min
    y_min=y_min_dalsi;   
   end
   if y_max_dalsi>y_max
    y_max=y_max_dalsi;      
   end
  end
 end
 axis(gca,[x_min,x_max,y_min,y_max]) 
 %-------------------------------------------------------------------------
 hold off
end
%**************************************************************************
function spectra_series_color_Callback(hObject, eventdata, handles)
% hObject    handle to spectra_series_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Z kontextoveho menu pro spektra (asociovano s handles.osy_spektra) lze
% vybrat polozku pro zobrazeni vice spekter (tato polozka ma dalsi dve
% polozky -> zobrazeni vice spekter automatickou barvou nebo barvou podle
% serii). V tomto callbacku se spektra zobrazuji barvou podle serii. Staci
% zavolat callback (spectra_automatic_color_Callback) a nastavit prislusnou
% volbu zobrazeni(handles.volba_zobrazeni=1)
%--------------------------------------------------------------------------
handles.volba_zobrazeni=1;
spectra_automatic_color_Callback(handles.spectra_series_color, eventdata, handles);
%**************************************************************************
function gradient_of_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to gradient_of_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Z kontextoveho menu pro spektra (asociovano s handles.osy_spektra) lze
% vybrat polozku pro zobrazeni gradientovych spekter. Tato polozka ma dalsi
% dve polozky -> zobrazeni gradientovych spekter automatickou barvou nebo
% barvou podle serii (viz dale).
%**************************************************************************
function gradient_color_automatic_Callback(hObject, eventdata, handles)
% hObject    handle to gradient_color_automatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Zobrazeni obecne vice gradientovych spekter pomoci kontextoveho menu pro
% spektra. Spektra se kresli automatickou barvou (max. 7 spekter, protoze
% je k dispozici max. 7 barev). Pokud je tento Callback volan z jineho
% callbacku (gradient_color_series_Callback), tak se gradientova spektra
% kresli s barvami podle serii. Pro kresleni vice grad. spekter se vyuzije
% callback pro kresleni vice spekter(spectra_automatic_color_Callback).
%--------------------------------------------------------------------------
if isequal(gcbo,handles.gradient_color_automatic)% kresli se gradientova
 % spektra automatickou barvou 
 handles.volba_zobrazeni=2; 
else % Tento callback je volan z jineho Callbacku -> kresli se gradientova 
 % spektra barvami podle serii   
 handles.volba_zobrazeni=3;   
end
%--------------------------------------------------------------------------
prompt = {'Choose the order of gradient'};
dlg_title_stupen = 'The order of gradient';
num_lines = 1;
def_stupen = {'1'};
options.Resize='on';
odpoved_stupen=inputdlg(prompt,dlg_title_stupen,num_lines,def_stupen,options);
if ~isequal(odpoved_stupen,{}) % Testovani zda nebylo stisknuto cancel 
 [stupen,status]=str2num(odpoved_stupen{1});
 if (status==0 || size(stupen,2)~=1 || stupen<0 ||...
  ~isequal(floor(stupen),stupen)) % Zadana nepripustna hodnota (stupen
  % pro gradient musi byt nezaporne cele cislo)   
  errordlg('Enter new value !','Invalid value');
 else % Zadana pripustna hodnota
  handles.gradient_stupen=stupen; % stupen se ulozi jako globalni promenna
  spectra_automatic_color_Callback(handles.gradient_color_automatic,...
  eventdata,handles);
 end
end
%**************************************************************************
function gradient_color_series_Callback(hObject, eventdata, handles)
% hObject    handle to gradient_color_series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Zobrazeni obecne vice gradientovych spekter pomoci kontextoveho menu pro
% spektra. Spektra se kresli barvami podle serii. Tento Callback vola
% callback "gradient_color_automatic_Callback", ktery dale vola callback
% "spectra_automatic_color_Callback".
%--------------------------------------------------------------------------
gradient_color_automatic_Callback(handles.gradient_color_series,...
eventdata, handles);
%**************************************************************************
function difference_of_two_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to difference_of_two_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Z kontextoveho menu pro spektra (asociovano s handles.osy_spektra) lze
% vybrat polozku pro zobrazeni diferencnich spekter. Tato polozka ma dalsi
% dve polozky -> zobrazeni diferencnich spekter automatickou barvou nebo
% barvou podle serii (viz dale).
%**************************************************************************
function difference_color_automatic_Callback(hObject, eventdata, handles)
% hObject    handle to difference_color_automatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Zobrazeni obecne vice diferencnich spekter. Diferencni spektra se ziskaji
% odectenim jednoho vybraneho spektra od skupiny dalsich vybranych spekter.
% Diferencni spektra se kresli automatickou barvou (max. 7 spekter, protoze
% je k dispozici max. 7 barev). Pokud je tento callback volan z jineho
% callbacku (difference_color_series_Callback), tak se diferencni spektra
% kresli barvami podle serii. Pro kresleni vice diferencnich spekter se
% vyuzije callback pro kresleni vice spekter(spectra_automatic_color_Callback)
%--------------------------------------------------------------------------
if isequal(gcbo,handles.difference_color_automatic) % kresli se diferencni
 % spektra automatickou barvou  
 handles.volba_zobrazeni=4;
else % Tento callback je volan z jineho callbacku -> kresli se diferencni 
 % spektra barvami podle serii 
 handles.volba_zobrazeni=5;   
end
%--------------------------------------------------------------------------
prompt = {'Choose spectrum which will be substracted from the other spectra'};
dlg_title_spektrum = 'Spectrum for substraction';
num_lines = 1;
def_spektrum = {'1'};
options.Resize='on';
odpoved_spektrum=inputdlg(prompt,dlg_title_spektrum, num_lines,def_spektrum,options);
if ~isequal(odpoved_spektrum,{}) % Testovani zda nebylo stisknuto cancel 
 [spektrum, status]=str2num(odpoved_spektrum{1});
 if status==0 || size(spektrum,2)~=1 || spektrum<0 ||...
  spektrum >size(handles.spektra,2)||~isequal(floor(spektrum),spektrum) % Vybrano
  % nepripustne spektrum   
  errordlg('Enter new value !','Invalid value');
 else % Vybrano pripustne spektrum 
  handles.spektrum_diff=spektrum; % poradi vybraneho spektra se ulozi jako 
  % globalni promenna
  spectra_automatic_color_Callback(handles.difference_color_automatic,...
  eventdata,handles);
 end
end
%**************************************************************************
function difference_color_series_Callback(hObject, eventdata, handles)
% hObject    handle to difference_color_series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Zobrazeni obecne vice diferencnich spekter pomoci kontextoveho menu pro
% spektra. Spektra se kresli barvami podle serii. Tento Callback vola
% callback "difference_color_automatic_Callback", ktery dale vola callback
% "spectra_automatic_color_Callback".
%--------------------------------------------------------------------------
difference_color_automatic_Callback(handles.difference_color_series,...
eventdata, handles);
%**************************************************************************
function save_difference_of_two_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to save_difference_of_two_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Ulozeni diferencnich spekter (pristupne z kontextoveho menu pro spektra). 
% Napred dojde k vyberu spektra, ktere bude odecteno od dalsich spekter.
% Pote jsou vybrana spektra, od kterych bude toto spektrum odecteno.
% Prislusna diferencni spektra se nakonec ulozi. Ke kmenovemu nazvu
% ulozeneho souboru se pridava nahodne vygenerovane 5-mistne cislo (aby
% nedoslo k prepsani souboru ve stejnem adresari). Je rovnez nabidnuta
% moznost setridit x-ove hodnoty pro diferencni spektra vzestupne nebo
% sestupne.
%--------------------------------------------------------------------------
if handles.axes_manual
 x_min_current=handles.manual_data{handles.vyber}(1);
 x_max_current=handles.manual_data{handles.vyber}(2);
else
 x_min_current=handles.auto_data{handles.vyber}(1);
 x_max_current=handles.auto_data{handles.vyber}(2);   
end
[status,spektra_current]=orezani_spekter([handles.vlnocty handles.spektra],...
[x_min_current,x_max_current],1,0); % Data s ohledem na aktualni x-ovou
% skalu (vyber v programu spikie_FA_results)
if status
 vlnocty_current=spektra_current(:,1); % X-ova skala    
 spektra_current=spektra_current(:,2:end); % Spektra bez x-ove skaly
 prompt = {'Choose spectrum which will be substracted from the other spectra'};
 dlg_title_spektrum = 'Spectrum for substraction';
 num_lines = 1;
 def_spektrum = {'1'}; % Defaultne je vybrano prvni spektrum 
 options.Resize='on';
 odpoved_spektrum=inputdlg(prompt,dlg_title_spektrum,num_lines,def_spektrum,options);
 if ~isequal(odpoved_spektrum,{}) % Testovani zda nebylo stisknuto cancel 
  [spektrum, status]=str2num(odpoved_spektrum{1});
  if (status==0 || size(spektrum,2)~=1 || spektrum<0 ||...
   spektrum >size(handles.spektra,2)||~isequal(floor(spektrum),spektrum)) % Vybrano
   % nepripustne spektrum   
   errordlg('Enter new value !','Invalid value');
  else % Vybrano pripustne spektrum 
   [status,vyber]=dotaz_vyber(size(handles.spektra,2),...
   'Select spectra from which to substract chosen spectrum',...
   {['1:',num2str(size(handles.spektra_vyber,2))]},1,1);
   if status~=0 % spektra od nichz bude odecteno dane spektrum jsou pripustna
    % Data s aktualni x-ovou skalou (orezani primo v programu spikie_FA_results):
    data=spektra_current(:,vyber); % Vybrana spektra 
    spektrum_diff=spektra_current(:,spektrum); % Vybrane spektrum pro odecteni 
    % Urceni diferencnich spekter: 
    for m=1:1:size(data,2)
     data(:,m)=data(:,m)-spektrum_diff;   
    end
    % Pro trideni jsou treba vlnocty:
    data=trideni([vlnocty_current data],'Saving difference spectra'); 
    vlnocty=data(:,1); % setridene vlnocty pro ulozeni   
    data=data(:,2:end); % setridena data (bez vlnoctu) pro ulozeni
    kmen_nazev=strcat(handles.kmen_nazev,'_',num2str(floor(100000*rand())));
    adresar=save_spektra([kmen_nazev,'_diff'],vlnocty,data,1,...
    'Where to save difference spectra ?',handles.current_adresar,'',1,...
    'Saving data','Type of data','txt',handles.precision); % Ulozeni dif. spekter
    if ~isequal(adresar,0)
     handles.current_adresar=adresar; % aktualni adresar (viz iniciacni callback)
     guidata(hObject, handles); 
    end
   end % testovani korektne vybranych spekter
  end % testovani korektne vybraneho spektra
 end % testovani, zda nebylo stisknuto cancel
else
 uiwait(errordlg(['Selected range contains less than 2 points',...
 ' -> data will not be saved'],'Insufficient number of points '));    
end % status orezani x-ove skaly
%**************************************************************************
function save_gradient_of_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to save_gradient_of_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Ulozeni gradientovych spekter (pristupne z kontextoveho menu pro spektra).
% Napred dojde k vyberu stupne gradientu (stupen=0 -> puvodni spektra,
% stupen=1-> grad, stupen=2->grad(grad), atd). Pote dojde k vyberu spekter,
% ze kterych se spocita gradient a vsechna tato spektra se nakonec ulozi. 
% Ke kmenovemu nazvu ulozeneho souboru se pridava nahodne vygenerovane
% 5-mistne cislo (aby nedoslo k prepsani souboru ve stejnem adresari).
% Je rovnez nabidnuta moznost setridit x-ove hodnoty pro gradientova
% spektra vzestupne nebo sestupne.
%--------------------------------------------------------------------------
% Data s aktualni x-ovou skalou (orezani primo v programu spikie_FA_results):    
if handles.axes_manual
 x_min_current=handles.manual_data{handles.vyber}(1);
 x_max_current=handles.manual_data{handles.vyber}(2);
else
 x_min_current=handles.auto_data{handles.vyber}(1);
 x_max_current=handles.auto_data{handles.vyber}(2);   
end
[status,spektra_current]=orezani_spekter([handles.vlnocty handles.spektra],...
[x_min_current,x_max_current],1,0); 
if status
 vlnocty_current=spektra_current(:,1); % X-ova skala    
 spektra_current=spektra_current(:,2:end); % Spektra bez x-ove skaly
 prompt = {'Choose the order of gradient'};
 dlg_title_stupen = 'The order of gradient';
 num_lines = 1;
 def_stupen = {'1'}; % Defaultne je uvazovan gradient prvniho stupne
 options.Resize='on';
 odpoved_stupen=inputdlg(prompt,dlg_title_stupen, num_lines,def_stupen,options);
 if ~isequal(odpoved_stupen,{}) % Testovani zda nebylo stisknuto cancel 
  [stupen, status]=str2num(odpoved_stupen{1});
  if (status==0 || size(stupen,2)~=1 || stupen<0 ||...
   ~isequal(floor(stupen),stupen)) % Zadana nepripustna hodnota (stupen
   % gradientu musi byt nezaporne cele cislo)   
   errordlg('Enter new value !','Invalid value');
  else % Zadana pripustna hodnota pro stupen gradientu
   [status,vyber]=dotaz_vyber(size(handles.spektra,2),...
   'Select spectra from which to form gradient',...
   {['1:' num2str(handles.pocet_spekter_orig)]},1,1); % Vyber spekter, ze kterych 
   % se spocte gradient a ktera se ulozi. Defaultne jsou vybrana vsechna spektra 
   if status~=0 % Vybrana pripustna spektra pro vypocet gradientu
    data=spektra_current(:,vyber); % Vybrana spektra    
    data=gradient_more(data,stupen); % vypocet gradientu pro vybrana spektra  
    data=trideni([vlnocty_current data],'Saving ''gradient'' spectra');  
    vlnocty=data(:,1); % setridene vlnocty pro ulozeni    
    data=data(:,2:end); % setridena data (bez vlnoctu) pro ulozeni 
    kmen_nazev=strcat(handles.kmen_nazev,'_',num2str(floor(100000*rand())));
    adresar=save_spektra([kmen_nazev,'_grad'],vlnocty,data,1,...
    'Where to save gradient spectra ?',handles.current_adresar,'',1,...
    'Saving data','Type of data','txt',handles.precision); % Ulozeni grad. spekter
    if ~isequal(adresar,0)
     handles.current_adresar=adresar;  % aktualni adresar (viz iniciacni callback)
     guidata(hObject, handles); 
    end
   end % testovani korektne vybranych spekter
  end %testovani, korektne vybraneho stupne gradientu
 end % testovani, zda nebylo stisknuto cancel
else
  uiwait(errordlg(['Selected range contains less than 2 points',...
  ' -> data will not be saved'],'Insufficient number of points '));   
end
%**************************************************************************
function normalization_based_on_FA_Callback(hObject, eventdata, handles)
% hObject    handle to normalization_based_on_FA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Kontextove menu (asociovano s objektem typu osy: handles.osy_spektra)
% umoznujici normalizaci spekter podle prvniho koeficientu z faktorove
% analyzy spekter 
%**************************************************************************
function normalization_based_on_FA_table_Callback(hObject, eventdata, handles)
% hObject    handle to normalization_based_on_FA_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Po spusteni tohoto callbacku (kontextove menu pro spektra) se zobrazi
% tabulka normalizacnich faktoru pro aktualni spektra (obecne orezana
% spektra s upravenym pozadim).
% Normalizacni faktory pro spektra jsou ziskany nasledujicim zpusobem:
% 1) Provede se faktorova analyza aktualnich spekter a zjisti se prvni
% koeficienty (prvni sloupec matice koeficientu V)
% 2) Spocte se prumerna hodnota prvnich koeficientu
% 3) Normalizacni koeficienty pro spektra jsou ziskany jako absolutni
% hodnoty podilu hodnot prvnich koeficientu pro aktualni spektra a jejich
% prumerne hodnoty. 
%--------------------------------------------------------------------------
% Data s aktualni x-ovou skalou (orezani primo v programu spikie_FA_results):   
if handles.axes_manual
 x_min_current=handles.manual_data{handles.vyber}(1);
 x_max_current=handles.manual_data{handles.vyber}(2);
else
 x_min_current=handles.auto_data{handles.vyber}(1);
 x_max_current=handles.auto_data{handles.vyber}(2);   
end   
[status,spektra_current]=orezani_spekter([handles.vlnocty handles.spektra],...
[x_min_current,x_max_current],1,0);
aaa=spektra_current(:,1); % temp
if status
 spektra_current=spektra_current(:,2:end); % Spektra bez x-ove skaly
 if isequal(gcbo,handles.normalization_based_on_FA_table) 
  [U,W,V]=faktorka(spektra_current); % Faktorova analyza ze spekter     
  konstanty=abs(V(:,1)/mean(V(:,1))); % Normovaci konstanty z FA
 else
  maximum=max(spektra_current)'; % maxima pro dana spektra
  
  % temp
  r=size((spektra_current),2); 
  xx=min(aaa):0.01:max(aaa);
  for i=1:1:r
  sp=spektra_current(:,i);
  
  %sp=spline(aaa,sp,xx);
   sp = polyval(polyfit(aaa,sp,5),xx);
   [Ymax(i),indexm]=max(sp);
   Xmax(i)=xx(indexm);
   end


  
 
   adresar=save_spektra(['aaa','_temp'],Xmax',Ymax',1,...
    'Where to save normalized spectra ?',handles.current_adresar,'',1,...
    'Saving norm. spectra','Type of data','txt',handles.precision);

%   adresar=save_spektra(['aaa','_temp2'],xx',(spline(aaa,spektra_current(:,9),xx))',1,...
%     'Where to save normalized spectra ?',handles.current_adresar,'',1,...
%      'Saving norm. spectra','Type of data','txt',handles.precision);

  
   adresar=save_spektra(['aaa','_temp2'],xx',(polyval(polyfit(aaa,spektra_current(:,1),5),xx))',1,...
     'Where to save normalized spectra ?',handles.current_adresar,'',1,...
      'Saving norm. spectra','Type of data','txt',handles.precision);









  
    % temp
  
  

    
    
    
 
  
 
  
  konstanty=abs(maximum/mean(maximum)); % normovaci konstanty z maxim spekter   
 end
 h_info=figure; % okno pro vypis informaci
 set(h_info,'MenuBar','none','Name','normalization coefficients for current spectra',...
 'NumberTitle','off','Units','normalized','Position',[0.50,0.47,0.20,0.30]);
 vypis(1)={strcat('Spectrum No.','     Norm. factor')};
 vypis(2)={strcat('-----------------------------------')};
 for i=1:1:handles.pocet
  vypis(2+i)={strcat(num2str(i),...
  '..........................',num2str(konstanty(i)))};
 end
 uicontrol('Parent',h_info,'Style','listbox','Units','normalized',...
 'Position',[0.076,0.098,0.881,0.845],'String',vypis); % Tabulka (listbox)
 % normalizacnich faktoru pro spektra
else
 uiwait(errordlg(['Selected range contains less than 2 points',...
 ' -> Normalization cannot not be done !'],'Insufficient number of points '));    
end
%**************************************************************************
function normalization_based_on_FA_save_Callback(hObject, eventdata, handles)
% hObject    handle to normalization_based_on_FA_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% Po spusteni tohoto Callbacku (kontextove menu pro spektra) se spoctou
% normalizacni faktory (stejnym zpusobem jako v Callbacku: 
% normalization_based_on_FA_table_Callback). Tyto normalizacni faktory se
% pouziji na normalizaci spekter("podeleni spekter" temito faktory). Lze
% ukladat normalizovana spektra, normalizacni faktory nebo oboji. Je
% nabidnuta rovnez moznost setridit normalizovana spektra vzestupne nebo
% sestupne podle x-oveho sloupce.  
%--------------------------------------------------------------------------
% Data s aktualni x-ovou skalou (orezani primo v programu spikie_FA_results):   
if handles.axes_manual
 x_min_current=handles.manual_data{handles.vyber}(1);
 x_max_current=handles.manual_data{handles.vyber}(2);
else
 x_min_current=handles.auto_data{handles.vyber}(1);
 x_max_current=handles.auto_data{handles.vyber}(2);   
end   
[status,spektra_current]=orezani_spekter([handles.vlnocty handles.spektra],...
[x_min_current,x_max_current],1,0); 
if status
 Ulozeni = questdlg('What do you want to save ?',...
 'Saving results of normalization ','Both','Norm. factor','Spectra','Both');
 if ~isequal(Ulozeni,'')
  kmen_nazev=strcat(handles.kmen_nazev,'_',num2str(floor(100000*rand())));
  if isequal(gcbo,handles.normalization_based_on_FA_save) 
   [U,W,V]=faktorka(spektra_current(:,2:end)); % Faktorova analyza ze spekter     
   konstanty=abs(V(:,1)/mean(V(:,1))); % Normovaci konstanty z FA
  else
   maximum=max(spektra_current(:,2:end))'; % maxima pro dana spektra
   konstanty=abs(maximum/mean(maximum)); % normovaci konstanty z maxim spekter    
  end
  if ismember({Ulozeni},{'Both','Spectra'})
   type_spectra = questdlg('Select spectra for normalization ',...
   'Saving normalized spectra ','Original spectra','Current spectra',...
   'Original spectra');
   if strcmp(type_spectra,'Original spectra') 
    vlnocty=handles.data_orig_vyber(:,1);
    data_orig_vyber=handles.data_orig_vyber(:,2:end);   
    for i=1:1:handles.pocet % Normalizace puvodnich spekter (spektra bez
     % orezani a upravy pozadi) pomoci normovacich konstant ziskanych z FA
     % pro aktualni spektra (obecne orezana spektra s upravenym pozadim)
     % Muzu takto normovat napriklad na uzky pas.
     spektra_norm(:,i)=data_orig_vyber(:,i)/konstanty(i);
    end        
   else
    vlnocty=spektra_current(:,1);
    spektra_current=spektra_current(:,2:end);
    for i=1:1:handles.pocet % Normalizace aktualnich spekter (obecne orezana  
     % spektra s upravenym pozadim) pomoci normovacich konstant ziskanych z
     % jejich faktorove analyzy.
     spektra_norm(:,i)=spektra_current(:,i)/konstanty(i);
    end
   end
   spektra_norm=trideni([vlnocty spektra_norm],'Saving normalized spectra');
   vlnocty=spektra_norm(:,1); % Vlnocty setridenych spekter
   spektra_norm=spektra_norm(:,2:end); % intenzity setridenych spekter
  end
  switch Ulozeni
   case 'Norm. factor'
    %----------------------------------------
    % Ukladaji se pouze normalizacni faktory
    %----------------------------------------   
    adresar=save_spektra([kmen_nazev,'_factor'],(1:1:handles.pocet)',konstanty,1,...
    'Where to save normalization factors ?',handles.current_adresar,'',0,...
    '','','txt',handles.precision); 
    if ~isequal(adresar,0)
     handles.current_adresar=adresar;
     guidata(hObject, handles); 
    end    
   case 'Spectra'
    %----------------------------------------
    % Ukladaji se pouze normalizovana spektra
    %----------------------------------------
    % Ukladani normalizovanych spekter
    adresar=save_spektra([kmen_nazev,'_norm'],vlnocty,spektra_norm,1,...
    'Where to save normalized spectra ?',handles.current_adresar,'',1,...
    'Saving norm. spectra','Type of data','txt',handles.precision); 
    if ~isequal(adresar,0)
     handles.current_adresar=adresar;
     guidata(hObject, handles); 
    end
   case 'Both'
    %---------------------------------------------------------   
    % Ukladaji se normalizacni faktory i normalizovana spektra
    %---------------------------------------------------------
    adresar=save_spektra([kmen_nazev,'_factor'],(1:1:handles.pocet)',konstanty,1,...
    'Where to save normalization factors ?',handles.current_adresar,'',0,...
    '','','txt',handles.precision); 
    if ~isequal(adresar,0)
     handles.current_adresar=adresar;
     guidata(hObject, handles); 
    end
    adresar=save_spektra([kmen_nazev,'_norm'],vlnocty,spektra_norm,1,...
    'Where to save normalized spectra ?',handles.current_adresar,'',1,...
    'Saving norm. spectra','Type of data','txt',handles.precision);
    if ~isequal(adresar,0)
     handles.current_adresar=adresar;
     guidata(hObject, handles); 
    end
  end % end switch
 end % testovani, zda nebylo stisknuto cancel pri vyberu, co ulozit 
else
 uiwait(errordlg(['Selected range contains less than 2 points',...
 ' -> Normalization cannot not be done !'],'Insufficient number of points ')); 
end % Testovani spravneho orezani
%**************************************************************************
function normalization_based_on_max_Callback(hObject, eventdata, handles)
% hObject    handle to normalization_based_on_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Kontextove menu (asociovano s objektem typu osy: handles.osy_spektra)
% umoznujici normalizaci spekter podle maxima spektra z vybrane oblasti
%**************************************************************************
function normalization_based_on_max_table_Callback(hObject, eventdata, handles)
% hObject    handle to normalization_based_on_max_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
normalization_based_on_FA_table_Callback(hObject, eventdata, handles)
%**************************************************************************
function normalization_based_on_max_save_Callback(hObject, eventdata, handles)
% hObject    handle to normalization_based_on_max_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
normalization_based_on_FA_save_Callback(hObject, eventdata, handles)
%**************************************************************************
function remove_noise_Callback(hObject, eventdata, handles)
% hObject    handle to remove_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.axes_manual
 x_min_current=handles.manual_data{handles.vyber}(1);
 x_max_current=handles.manual_data{handles.vyber}(2);
else
 x_min_current=handles.auto_data{handles.vyber}(1);
 x_max_current=handles.auto_data{handles.vyber}(2);   
end
[status,spektra]=orezani_spekter([handles.vlnocty handles.spektra],...
[x_min_current,x_max_current],1,0); % subspektra s x-ovou skalou
if status
 vlnocty=spektra(:,1); % x-ova skala    
 spektra=spektra(:,2:end); % spektra bez x-ove skaly
 prompt = {'Choose dimension ?'};
 dlg_title_dimension = 'Noise correction';
 num_lines = 1;
 def_dimension = {num2str(1)};
 options.Resize='on';
 odpoved_dimension=inputdlg(prompt,dlg_title_dimension,num_lines,def_dimension,options);
 if ~isequal(odpoved_dimension,{}) % Testovani zda nebylo stisknuto cancel 
  [dimension,status]=str2num(odpoved_dimension{1});
  if status==1 && size(dimension,2)==1 && dimension>0 && ...
   isequal(floor(dimension),dimension) && dimension <=min(size(spektra)) 
   default_vyber={['1:',num2str(handles.pocet)]};%Defaultne jsou vybrana vsechna spektra:
   [status_vyber,spektra_vyber,pocet_spekter_vyber]=...
   dotaz_vyber(handles.pocet,'Selection of spectra for analysis',default_vyber,1,1); 
   if status_vyber~=0
    spektra=spektra(:,spektra_vyber);
    [U,W,V]=faktorka(spektra);
    spektra=zeros(size(spektra,1),pocet_spekter_vyber);
    for m=1:1:pocet_spekter_vyber % cyklus pres vsechna spektra
     for n=1:1:dimension % cyklus pres prvnich n dimenzi 
      spektra(:,m)=spektra(:,m)+U(:,n)*W(n)*V(spektra_vyber(m),n);
     end
    end
    spektra=trideni([vlnocty spektra],'Saving ''noise-corrected'' spectra');   
    vlnocty=spektra(:,1); % x-ova skala    
    spektra=spektra(:,2:end); % spektra bez x-ove skaly    
    kmen_nazev=strcat(handles.kmen_nazev,'_',num2str(floor(100000*rand())));
    adresar=save_spektra([kmen_nazev,'_noise'],vlnocty,spektra,1,...
    'Where to save noise-corrected spectra ?',handles.current_adresar,'',1,...
    'Saving data','Type of data','txt',handles.precision); 
    if ~isequal(adresar,0)
     handles.current_adresar=adresar;  % aktualni adresar (viz iniciacni callback)
     guidata(hObject, handles); 
    end
   end % test spravneho vyberu spekter
  else
   errordlg(['Dimension is incorrectly defined or exceeds factor dimension ',...
   '(minimum from number of spectra and spectral points) !'],'Invalid value');   
  end % test dimenze 
 end % test, zda nebylo stisknuto cancel
else
uiwait(errordlg(['Selected range contains less than 2 points',...
' -> data will not be saved'],'Insufficient number of points '));    
end % test orezani
%************************************************************************** 
function save_more_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to save_more_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.axes_manual
 x_min_current=handles.manual_data{handles.vyber}(1);
 x_max_current=handles.manual_data{handles.vyber}(2);
else
 x_min_current=handles.auto_data{handles.vyber}(1);
 x_max_current=handles.auto_data{handles.vyber}(2);   
end
[status,spektra_current]=orezani_spekter([handles.vlnocty handles.spektra],...
[x_min_current,x_max_current],1,0); 
if status
 vlnocty_current=spektra_current(:,1); % X-ova skala    
 spektra_current=spektra_current(:,2:end); % Spektra bez x-ove skaly
 [status,vyber]=dotaz_vyber(size(handles.spektra,2),...
 'Select which spectra to save',{['1:' num2str(handles.pocet_spekter_orig)]},1,1); 
 if status~=0 % Vybrana pripustna spektra 
  data=spektra_current(:,vyber); % Vybrana spektra    
  data=trideni([vlnocty_current data],'Saving selected spectra');  
  vlnocty=data(:,1); % setridene vlnocty pro ulozeni    
  data=data(:,2:end); % setridena data (bez vlnoctu) pro ulozeni 
  kmen_nazev=strcat(handles.kmen_nazev,'_',num2str(floor(100000*rand())));
  adresar=save_spektra([kmen_nazev,'_kor'],vlnocty,data,1,...
  'Where to save spectra ?',handles.current_adresar,'',1,...
  'Saving data','Type of data','txt',handles.precision); % Ulozeni spekter
  if ~isequal(adresar,0)
   handles.current_adresar=adresar;  % aktualni adresar (viz iniciacni callback)
   guidata(hObject, handles); 
  end
 end % testovani korektne vybranych spekter
else
 uiwait(errordlg(['Selected range contains less than 2 points',...
 ' -> spectra will not be saved'],'Insufficient number of points '));       
end
%**************************************************************************
function new_window_coefficients_Callback(hObject, eventdata, handles)
% hObject    handle to new_window_coefficients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

new_window_FA=figure;
if handles.volba==3 
 set(new_window_FA,'MenuBar','figure','Name',...
 'Factor analysis of background-uncorrected spectra (subspectra vs. coefficients)',...
 'NumberTitle','off');
else
 set(new_window_FA,'MenuBar','figure','Name',...
 'Factor analysis of background-corrected spectra (subspectra vs. coefficients)',...
 'NumberTitle','off');
end
subplot(1,2,1);
plot(handles.vlnocty,handles.spektra(:,handles.vyber),'b');
if(handles.axes_manual==0); % rezim auto
 axis(handles.auto_data{handles.vyber}); % automat. nastaveni os 
else % rezim manual (handles.axes_manual=1)
 axis(handles.manual_data{handles.vyber}); % manualni nastaveni os 
end;
title(['Subspectrum: ',num2str(handles.vyber)]);
grid minor;
subplot_2=subplot(1,2,2);
copyobj(handles.plot_coeff,subplot_2);
set(subplot_2,'box','on')
if(handles.axes_manual==0); % rezim auto  
 axis(handles.auto_V{handles.vyber}); % automat. nastaveni mezi os 
else % rezim manual (handles.axes_manual=1)
 axis(handles.manual_V{handles.vyber}); % manualni nastaveni mezi os 
end
title(['Coefficient: ',num2str(handles.vyber)]);
if handles.serie_volba==2
 copyobj(handles.handle_legenda,gcf);
end
grid minor;



  
















% --------------------------------------------------------------------
function fourier_Callback(hObject, eventdata, handles)
% hObject    handle to fourier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Fourier_Callback(hObject, eventdata, handles)
% hObject    handle to Fourier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
