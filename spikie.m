function varargout = spikie(varargin)
% SPIKIE M-file for spikie.fig
%      SPIKIE, by itself, creates a new SPIKIE or raises the existing
%      singleton*.
%
%      H = SPIKIE returns the handle to a new SPIKIE or the handle to
%      the existing singleton*.
%
%      SPIKIE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPIKIE.M with the given input arguments.
%
%      SPIKIE('Property','Value',...) creates a new SPIKIE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spikie_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spikie_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spikie

% Last Modified by GUIDE v2.5 22-Jan-2018 10:44:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spikie_OpeningFcn, ...
                   'gui_OutputFcn',  @spikie_OutputFcn, ...
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

% --- Executes just before spikie is made visible.
function spikie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spikie (see VARARGIN)

% Choose default command line output for spikie
handles.output = hObject;
cla(handles.main_axes); % vymaze hlavni graf pri spusteni
handles.inifilename='spikie.ini'; % nazev souboru s ulozenymi parametry.
% Pokud tento soubor neexistuje, tak funkce spikie_load_parameters
% pouzije parametry inplicitni.
handles.maxiter = 100; % maximum iteraci pro iterativni odecteni pomoci
% polynomu
handles.digits=16; % pocatecni hodnota pro presnost ukladanych dat (pocet 
% cifer za desetinnou teckou)
start_treshold=4; % Pocatecni hodnota treshold pro odhaleni Spiku v
% v nasobcich odchylky.
handles.treshold=start_treshold; % Nastaveni pocatecni hodnoty
% handles.treshold
handles.points=9; % Nastavi hodnotu points (sirku okna) pro SavGol
handles.degree=2; % Nastavi stupen polynomu pro SavGol
handles.del_points=1; % Nastavi pocet bodu kolem nalzeneho spatneho bodu,
% ktere se budou povazovat take za spatne.
handles.fited_points_for_edit=5; % Nastavi pocatecni pocet bodu, ktere se pouziji
% pro fit, pri nahrazeni spiku.
handles.allowance_equidistant_vlnocty=.001;
[handles.maxiter,handles.digits]=spikie_load_parameters(hObject,...
    eventdata, handles);
% pokusi se nacist pocatecni parametry ze souboru spikie.ini, pokud
% soubor neexistuje nebo se nacteni nezdari, pouzije preddefinovane hodnoty
handles.smoothed=0; % nastaveni indikatoru, zdali uz byla vybrana metoda
% hledani spiku ci nikoli
handles.current_directory = pwd; % nastaveni aktualniho adresare
handles.possible_method={'Subtraction - Savitzky-Golay'}; % Promena,
% obsahujici seznam moznych metod nalezeni spiku pro potreby
% metoda_popupmenu
probability=sprintf('%.7f %%',100*erf(start_treshold/sqrt(2)));
handles.poly_fit_degree=2; % Pocatecni stupen polynomu pouzity pro odecteni
% spiku. Je treba nastavit jeste hodnotu v handles.degree_poly_buttongroup
% SelectedObject
handles.mode=1; %Pocatecni nastaveni modu je single. Pro mode batch nabyva
% hodnoty 2
handles.mode_FA=1; %Pocatecni nastaveni prace s faktorovou analyzou
% (hodnota 2) nebo s normalnimi spektry (hodnota 1)
handles.zoom_auto=1; % Z pocatku je nastaven automaticky zoom. Pro manualne
% nastavene meze os tato promena nabyva hodnoty 0
handles.interactive_zoom_indicator=0; % Znameni toho, zdali se kurzor na
% hlavnich osach chova jako lupa. Hodnota 0 znamena, ze ne, hodnota 1
% znamena, ze ano
set(handles.main_axes,'Units','normalized','Position',[.03,.03,.73,.86])
set(handles.figure1,'CloseRequestFcn',@closedlg,'Resize','on');
% Volani funkce closedlg a nastaveni moznosti zmeneni velikosti okna
% pri zavreni okna aplikace
set(handles.load_pushbutton,'Style','pushbutton','Units','normalized',...
    'Position', [0.925 0.93 0.065 0.04],'String','Load','TooltipString',...
    'Will load data into workspace'); % nastaveni tlacitka pro nacteni
% spekter
set(handles.loaded_file_text,'Style','pushbutton','Units','normalized',...
    'Position',[.03 .93 .15 .05],'String','Loaded file:',...
    'BackgroundColor','green','Enable','inactive'); % inicializace
% textoveho pole ukazujiciho zpracovavany soubor
set(handles.choose_interval_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position', [0.84 0.93 0.075 0.04],'String',...
    'Choose interval','TooltipString','Will choose used wavenumbers');
% nastaveni tlacitka pro nacteni spekter
set(handles.op_mode_panel,'Title','Operational mode','Units',...
    'normalized','Position',[.63,.93,.2,.057]);
set(handles.mode_display_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.35 .15 .3 .8],'String','single','Parent',...
    handles.op_mode_panel,'BackgroundColor','green','Enable','inactive',...
    'Visible','on');
set(handles.mode_FA_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.68 .15 .3 .8],'String','normal','Parent',...
    handles.op_mode_panel,'BackgroundColor','green','Enable','inactive',...
    'Visible','on');
set(handles.mode_pushbutton,'Style','pushbutton','Units','normalized',...
    'Position',[.02 .15 .31 .8],'String','mode','Parent',...
    handles.op_mode_panel,'TooltipString',...
    'Will chose between working with single spectrum or batch proces',...
    'Visible','on','Enable','on');
set(handles.select_spec_panel,'Title','Select spectrum','Units',...
    'normalized','Position',[.18,.93,.2,.057],'Visible','off');
set(handles.chosen_spec_text,'Style','pushbutton','Units','normalized',...
    'Position',[.47 .15 .5 .8],'String','Chosen spectrum:','Parent',...
    handles.select_spec_panel,'BackgroundColor','green','Enable',...
    'inactive');
set(handles.chose_spec_pushbutton,'Style','pushbutton','Units','normalized','Position',...
    [.02 .15 .13 .8],'String','#','Parent',handles.select_spec_panel,...
    'TooltipString','Will chose one spectrum','Visible','on',...
    'Enable','on','FontSize',10);
set(handles.down_pushbutton,'Style','pushbutton','Units','normalized','Position',...
    [.17 .15 .13 .8],'String','<','Parent',handles.select_spec_panel,...
    'TooltipString','Will chose one spectrum','FontSize',10);
set(handles.up_pushbutton,'Style','pushbutton','Units','normalized','Position',...
    [.32 .15 .13 .8],'String','>','Parent',handles.select_spec_panel,...
    'TooltipString','Will chose one spectrum','FontSize',10);
set(handles.zoom_panel,'Title','Zoom','Units',...
    'normalized','Position',[.38,.93,.25,.057],'Visible','off');
set(handles.auto_zoom_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.016 .15 .148 .8],'String','auto','Parent',...
    handles.zoom_panel,'TooltipString','Automaticly adjusts axes');
set(handles.horizontal_zoom_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.180 .15 .148 .8],'String','hor','Parent',...
    handles.zoom_panel,'TooltipString',...
    'Automaticly adjusts wavenumber axis');
set(handles.vertical_zoom_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.344 .15 .148 .8],'String','vert','Parent',...
    handles.zoom_panel,'TooltipString',...
    'Automaticly adjusts intensity axis');
set(handles.manual_zoom_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.508 .15 .148 .8],'String','man','Parent',...
    handles.zoom_panel,'TooltipString',...
    'Enable manual setting of axes limits.');
set(handles.interactive_zoom_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.672 .15 .148 .8],'String','inte','Parent',...
    handles.zoom_panel,'TooltipString',...
    'Interactive zoom tool');
set(handles.invert_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[.836 .15 .148 .8],'String','invert','Parent',...
    handles.zoom_panel,'TooltipString','Inverts intesity axis');
set(handles.spikefind_panel,'Visible','off','Units','normalized','Title',...
    'Spikefinding panel:','Position',[0.78,0.56,0.21,0.27])
set(handles.make_pushbutton,'Parent',handles.spikefind_panel,'Style',...
    'pushbutton','Units','normalized','Position',...
    [.3 .4 .4 .16],'String','Make',...
    'TooltipString','Will use the chosen method');
set(handles.method_text,'Style','text','Units','normalized','Position',...
    [.815 .87 .15 .03],'String', 'Method of spikefinding:');
set(handles.metoda_popupmenu,'Style','popupmenu','Units','normalized',...
    'Position',[.815 .82 .15 .05]);
set(handles.metoda_popupmenu,'String',[{'Select the method'},...
    handles.possible_method],'Value',1);
set(handles.slave_menu_text,'Style','text','Units','normalized',...
    'Position',[.79 .14 .2 .03],'String','Displayed spectrum:');
set(handles.points_text,'Paren',handles.spikefind_panel,'Style','text',...
    'Units','normalized','Position',[.16 .81 .3 .15],'String',...
    sprintf('Points:\n (odd number)'),'Visible','off');
set(handles.degree_text,'Paren',handles.spikefind_panel,'Style','text',...
    'Units','normalized','Position',[.54 .81 .3 .15],'String',...
    sprintf('Degree of\n polynomial:'),'Visible','off');
set(handles.treshold_text,'Paren',handles.spikefind_panel,'Style',...
    'text','Units','normalized','Position',[.16 .2 .3 .1],'String',...
    sprintf('Treshold:'),'Visible','off');
set(handles.probability_text,'Paren',handles.spikefind_panel,'Style',...
    'text','Units','normalized','Position',[.54 .2 .3 .1],'String',...
    sprintf('Probability:'),'Visible','off');
set(handles.points_edit,'Paren',handles.spikefind_panel,'Style','edit',...
    'Units','normalized','Position',[.21 .67 .2 .13],'String',...
    num2str(handles.points),'BackgroundColor',[1,1,1],'Visible','off');
set(handles.degree_edit,'Paren',handles.spikefind_panel,'Style','edit',...
    'Units','normalized','Position',[.59 .67 .2 .13],'String',...
    num2str(handles.degree),'Visible','off','BackgroundColor',[1,1,1]);
set(handles.treshold_edit,'Paren',handles.spikefind_panel,'Style',...
    'edit','Units','normalized','Position',[.21 .05 .2 .13],'String',...
    num2str(start_treshold),'TooltipString',...
    'In multiples of standard deviation','BackgroundColor',[1,1,1],...
    'Visible','off');
set(handles.probability_display_text,'Paren',handles.spikefind_panel,...
    'Style','pushbutton','Units','normalized','Position',...
    [.52 .05 .34 .13],'String',probability,'TooltipString',...
    'Probability of value in normal distribution','Visible','off',...
    'BackgroundColor','green','Enable','inactive');
set(handles.slave_popupmenu,'Style','popupmenu','Units','normalized',...
    'Position',[.79 .1 .2 .05]);
set(handles.slave_popupmenu,'String',{'Original spectrum',...
    'Current spectrum','Diference spectrum'},'Value',1,...
    'Enable','off','TooltipString',...
    'You must chose the method of spikefinding at first');
handles.defaultBackground = get(0,'defaultUicontrolBackgroundColor');
% Ulozi nastaveni pro barvu defaultni pro system
set(handles.save_pushbutton,'Style','pushbutton','Units','normalized',...
    'Position',[0.8 0.05 0.08 0.04],'String','Save','BackgroundColor',...
    handles.defaultBackground,'TooltipString','Will save the data',...
    'Enable','off');
set(handles.save_file_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[0.9 0.05 0.08 0.04],'String',...
    'Save to file','TooltipString','Will save the data to file',...
    'Enable','off');
set(handles.spikedel_panel,'Visible','off','Units','normalized','Title',...
    'Spike deletion:','Position',[0.78,0.25,0.21,0.3])
set(handles.spikedel_text,'Parent',handles.spikedel_panel,'Style',...
    'text','Units','normalized','Position',[.1 .93 .8 .07],'String',...
    sprintf('Method of deletion'),'Visible','on');
set(handles.spikedel_popupmenu,'Parent',handles.spikedel_panel,'Style',...
    'popupmenu','Units','normalized','Position',[.2 .8 .6 .1],...
    'Visible','on','Enable','on');
set(handles.spikedel_popupmenu,'String',{'Polynomial fit',...
    'Polynomial fit - iterative'});
set(handles.del_points_text,'Parent',handles.spikedel_panel,'Style',...
    'text','Units','normalized','Position',[.05 .65 .3 .13],'String',...
    sprintf('Deleted points\naround spike'),'Visible','on');
set(handles.del_points_edit,'Parent',handles.spikedel_panel,'Style',...
    'edit','Units','normalized','Position',[.1 .53 .2 .1],'String',...
    num2str(handles.del_points),'Visible','on');
set(handles.fited_points_text,'Parent',handles.spikedel_panel,'Style',...
    'text','Units','normalized','Position',[.05 .36 .3 .13],'String',...
    sprintf('Half number of\nfited points'),'Visible','on');
set(handles.fited_points_edit,'Parent',handles.spikedel_panel,'Style',...
    'edit','Units','normalized','Position',[.1 .23 .2 .1],'String',...
    num2str(handles.fited_points_for_edit),'Visible','on');
set(handles.degree_poly_buttongroup,'Parent',handles.spikedel_panel,...
    'Units','normalized','Position',[.45 .23 .5 .5],'Visible','on',...
    'SelectionChangeFcn',@degree_poly_buttongroup_SelectionChangeFcn,...
    'SelectedObject',handles.poly_2_radiobutton);
set(handles.poly_0_radiobutton,'Parent',...
    handles.degree_poly_buttongroup,'Style','radiobutton','Units',...
    'normalized','Position',[.2 .6 .3 .3],'String',sprintf('0'),...
    'Visible','on');
set(handles.poly_1_radiobutton,'Parent',handles.degree_poly_buttongroup,...
    'Style','radiobutton','Units','normalized','Position',[.2 .2 .3 .3],...
    'String',sprintf('1'),'Visible','on');
set(handles.poly_2_radiobutton,'Parent',handles.degree_poly_buttongroup,...
    'Style','radiobutton','Units','normalized','Position',[.6 .6 .3 .3],...
    'String',sprintf('2'),'Visible','on');
set(handles.poly_3_radiobutton,'Parent',handles.degree_poly_buttongroup,...
    'Style','radiobutton','Units','normalized','Position',[.6 .2 .3 .3],...
    'String',sprintf('3'),'Visible','on');
set(handles.makedel_pushbutton,'Parent',handles.spikedel_panel,'Style',...
    'pushbutton','Units','normalized','Position',[.3 .03 .4 .15],...
    'String',sprintf('Make'),'Visible','on');
set(handles.unselect_pushbutton,'Style','pushbutton','Units',...
    'normalized','Position',[0.9 0.25 0.08 0.04],'String','Unselect',...
    'TooltipString',['Will unselect this spectrum. This spectrum',...
    'won''t be saved in batch mode'],'Visible','off','Enable','on');
if ~isempty(varargin)>0
 set(handles.choose_interval_pushbutton,'Visible','on');
 set(handles.load_pushbutton,'Visible','off');
 set(handles.metoda_popupmenu,'String',[{'Select the method'},...
     handles.possible_method],'Value',1);
 set(handles.method_text,'Visible','on');
 set(handles.spikefind_panel,'Visible','on');
 set(handles.make_pushbutton,'Visible','on','Enable','off');
 set(handles.metoda_popupmenu,'Visible','on','Enable','on');
 set(handles.op_mode_panel,'Visible','on');
 handles.soubor=varargin{1};% jmeno nacteneho souboru
 set(handles.loaded_file_text,'String',...
     sprintf('<html><div align=center>Loaded file:<br>%s</div>',...
     handles.soubor));
 handles.kmen_nazev=handles.soubor(1:strfind(handles.soubor,'.')-1);
 handles.num_chos_spec=varargin{2};
 set(handles.chosen_spec_text,'String',sprintf('Chosen spectrum: %d',...
      handles.num_chos_spec));
 %------------------------------------------------------------------------
 % Pocet spekter po nacteni a jejich vlnoctova skala. Pomoci tlacitka 
 % data form (Callback: data_form_push)lze vsak pozdeji vybrat jen nektera
 % spektra nebo spektra orezat.
 handles.vlnocty=varargin{3}; % Vlnoctova skala nactenych  
 % spekter. Puvodni vlnoctovou skalu je treba uchovavat, protoze muze 
 % dojit k orezani spekter.
 handles.data_loaded=varargin{4}; % Puvodni nactena data se 
 % uz dale uvazuji bez sloupce vlnoctu (vlnocty nactenych spekter jsou 
 % ulozeny v promenne handles.vlnocty_orig).
 handles.data_orig=handles.data_loaded;
 for ii=1:handles.pocet_spekter
   handles.already_processed_points_ind{ii}={}; % cell array
   % obsahujici upravene body
   handles.already_processed_points_ind{ii}{1}=[];
 end
 handles.spectrum_chosen=handles.data_orig(:,handles.num_chos_spec);
 axes(handles.main_axes);
 plot(handles.vlnocty,handles.spectrum_chosen,'b');
 meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
 x_min=meze(1);
 x_max=meze(2);
 y_min=meze(3);
 y_max=meze(4);
 axis(gca,[x_min,x_max,y_min,y_max]);
else
 set(handles.op_mode_panel,'Visible','off');   
 set(handles.choose_interval_pushbutton,'Visible','off');
 set(handles.load_pushbutton,'Visible','on','Enable','on');
 set(handles.metoda_popupmenu,'Visible','off');
 set(handles.method_text,'Visible','off');
 set(handles.spikefind_panel,'Visible','off','Title',...
     'Spikefinding panel:');
 set(handles.make_pushbutton,'Visible','off','Enable','off');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spikie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spikie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_pushbutton.
function load_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filter_spec={'*.*','All Files (*.*)';
 '*.mat','MAT-files (*.mat)';
 '*.txt;*.dat','text files (*.txt,*.dat)'}; 
[status,soubor,cesta,data_orig]=spikie_load(0,handles.current_directory,...
  filter_spec,'Load Data','Off');
if status==0 % Pokud dojde k chybe pri nacitani dat (stisknuti cancel),
  % zobrazi se chybova hlaska.   
  h_errordlg=errordlg('No data load or invalid format of data !',...
      'loading data');
  waitfor(h_errordlg);
else % V pripade nacteni dat se provadi vse dalsi v Callbacku (prepisou se
  % predchozi data a smazou predchozi fity).
  cla(handles.main_axes);
  handles.mode=1;
  handles.mode_FA=1;
  set(handles.save_file_pushbutton,'Enable','off');
  set(handles.mode_display_pushbutton,'String','single')
  set(handles.mode_FA_pushbutton,'String','normal',...
        'BackgroundColor','green','Enable','inactive')
  set(handles.spikedel_text,'Visible','on');
  set(handles.spikedel_popupmenu,'Visible','on');
  set(handles.spikefind_panel,'Position',[0.78,0.56,0.21,0.27]);
  set(handles.make_pushbutton,'Parent',handles.spikefind_panel,...
      'Position',[.3 .4 .4 .16]);
  set(handles.points_text,'Position',[.16 .81 .3 .15]);
  set(handles.degree_text,'Position',[.54 .81 .3 .15]);
  set(handles.treshold_text,'Position',[.16 .2 .3 .1]);
  set(handles.probability_text,'Position',[.54 .2 .3 .1]);
  set(handles.treshold_edit,'Position',[.21 .05 .2 .13],...
      'BackgroundColor',[1,1,1]);
  set(handles.probability_display_text,'Position',[.52 .05 .34 .13]);
  set(handles.points_edit,'Position',[.21 .67 .2 .13],...
      'BackgroundColor',[1,1,1]);
  set(handles.degree_edit,'Position',[.59 .67 .2 .13],...
      'BackgroundColor',[1,1,1]);
  set(handles.spikedel_panel,'Position',[0.78,0.25,0.21,0.3],...
      'Title','Spike deletion:');
  set(handles.makedel_pushbutton,'Visible','on');
  set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
  set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);

  set(handles.op_mode_panel,'Visible','on');   
  set(handles.zoom_panel,'Visible','on');
  set(handles.choose_interval_pushbutton,'Visible','on');
  set(handles.slave_popupmenu,'Enable','off','Value',1);
  set(handles.method_text,'Visible','on');
  set(handles.metoda_popupmenu,'String',[{'Select the method'},...
      handles.possible_method],'Value',1);
  set(handles.select_spec_panel,'Visible','on')
  set(handles.chosen_spec_text,'String','Chosen spectrum: 1')
  set(handles.slave_popupmenu,'Enable','off')
  set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
      handles.defaultBackground);
  set(handles.save_file_pushbutton,'Enable','off');
  set(handles.spikefind_panel,'Visible','off','Title',...
      'Spikefinding panel:');
  set(handles.make_pushbutton,'Visible','off');
  set(handles.metoda_popupmenu,'Visible','on');
  set(handles.points_text,'Visible','off');
  set(handles.degree_text,'Visible','off');
  set(handles.points_edit,'Visible','off');
  set(handles.degree_edit,'Visible','off');
  set(handles.treshold_text,'Visible','off');
  set(handles.treshold_edit,'Visible','off');
  set(handles.probability_text,'Visible','off');
  set(handles.probability_display_text,'Visible','off');
  set(handles.spikedel_panel,'Visible','off');
  set(handles.down_pushbutton,'Enable','off');
  set(handles.unselect_pushbutton,'Visible','off');
  handles.smoothed=0; % nastaveni indikatoru, zdali uz byla vybrana metoda
  % hledani spiku ci nikoli
  handles.soubor=soubor;% jmeno nacteneho souboru
  set(handles.loaded_file_text,'String',...
      sprintf('<html><div align=center>Loaded file:<br>%s</div>',soubor));
  handles.cesta=cesta; % cesta k souboru
  handles.current_directory=cesta; % Aktualni adresar (viz "opening
  % callback") 
  handles.kmen_nazev=handles.soubor(1:strfind(handles.soubor,'.')-1);
  % Kmenovy nazev souboru pro pozdejsi ulozeni dat. Ke kmenovemu nazvu
  % souboru se pri ukladani pridava jeste _cor,
  % aby nedoslo k prepsani originalniho souboru ve stejnem adresari:
  if ~issorted(data_orig(:,1)) && ~issorted(flipud(data_orig(:,1)))
   h_warndlg=warndlg(['Data wasn''t sorted, hence it has been sorted ',...
       'by reason of troublefree going of program.']);
   waitfor(h_warndlg);
   [data_orig(:,1),ind]=sort(data_orig(:,1));
   data_orig(:,2:end)=data_orig(ind,2:end);
  end
  if issorted(flipud(data_orig(:,1)))
   data_orig=flipud(data_orig(:,1));
  end
  handles.vlnocty=data_orig(:,1); % Vlnoctova skala nactenych  
  % spekter. Puvodni vlnoctovou skalu je treba uchovavat, protoze muze 
  % dojit k orezani spekter.
  handles.chosen_interval_ind={};
  handles.chosen_interval_ind{1}=1:length(handles.vlnocty);
  handles.data_loaded=data_orig(:,2:end); % Puvodni nactena data se 
  % uz dale uvazuji bez sloupce vlnoctu (vlnocty nactenych spekter jsou 
  % ulozeny v promenne handles.vlnocty_orig).
  handles.data_orig=handles.data_loaded;
  handles.data_saved=handles.data_orig;
  handles.data_new=handles.data_orig;
  handles.pocet_spekter=size(handles.data_orig,2); % Aktualni pocet spekter 
  % po nacteni odpovida poctu nactenych spekter. Pokud dojde k vyberu
  % spekter (Callback: data_form_push), aktualni pocet spekter se zmensi na
  % vybranou hodnotu. Promenna handles.pocet_spekter se v programu pouziva
  % jak pro puvodni nactena data, tak i pro vybrana spektra.
  %------------------------------------------------------------------------
  handles.manual_axes_limits=zeros(handles.pocet_spekter,24); % Prelokace
  % pameti pro pripadne manualni nastaveni mezi os, kazdemu spektru
  % nalezi vzdy ctyri cisla, [x_min,x_max,y_min,y_max], prvni ctverice je
  % pro originalni spektrum, druha pro current spectrum, treti pro
  % difference spectrum, ctvrta pro spectrum with polynomial fit,
  % pata pro spectrum with repaired points a sesta pro new spectrum.
  handles.manual_axes_indicator=zeros(handles.pocet_spekter,6);
  % indikatory rezimu auto (hodnota 0) nebo manual (hodnota 1) pro
  % jednotliva spektra, pricemz kazdy slopec nalezi jinemu zobrazeni se
  % stejnym systemem jako handles.manual_axes_limits
  handles.make_pushbutton_indicator=zeros(1,handles.pocet_spekter);
  % nastaveni indikatoru provedeni SavGol filtru pro potreby vykresleni
  % grafu po zmacknuti tlacitka choose interval
  handles.indices_modif_recent=cell(1,handles.pocet_spekter); % Prealokace
  % pole obsahujiciho pro kazde spektrum vektor, ve kterem jsou
  % ulozeny indexy mezi intervalu vlnoctu - vzdy dvojice po sobe
  % nasledujicich cisel uvadi dolni a horni mez - na kterych je spektrum
  % vyhlazene SavGol filtrem. Je to potreba z toho duvodu, ze SavGol filtr
  % nevyhlazuje od kraje pouziteho intervalu, ale o pul hodnoty Points
  % dale, kdyz jsou vsak vybrane poditervaly, na kterych se pracuje, tak
  % program vyhladi co nejvice bodu z intervalu i za cenu toho, ze sahne do
  % jeste neupraveneho intervalu
  handles.indices_modif_int_recent=cell(1,handles.pocet_spekter);
  % Prealokace pole, obsahujiciho pro kazde spektrum vektor obsahujici
  % indexy vsech pouzitych vlnoctu pro SavGol. Duvod pro zavedeni toho
  % vektoru krome duvodu zminenych u handles.indices_modif_recent je
  % zrychleni programu, aby se pro pouziti vykreslovani grafu nemusely tato
  % cisla pokazde pocitat zvlast
  handles.already_processed_spectra=zeros(1,handles.pocet_spekter);
  handles.already_processed_points_ind={}; % cell array
  handles.now_processed_points_ind={}; % cell array
  % obsahujici upravene, ale jeste neulozene body
  handles.fited_points={};
  handles.new_points={};
  handles.new_points_ind={};
  handles.already_saved=ones(1,handles.pocet_spekter); % indikator ulozeni
  % dat pro jednotliva spektra
  handles.already_batch_saved=1; % indikator ulozeni dat v modu batch
  handles.spectrum_chosen_modif_recent={};
  handles.vlnocty_modif_recent={};
  handles.differentions_recent=cell(1,handles.pocet_spekter);
  handles.spectrum_for_differentions_recent=cell(1,handles.pocet_spekter);
  handles.indices_for_differentions_recent=cell(1,handles.pocet_spekter);
  for ii=1:handles.pocet_spekter
   handles.already_processed_points_ind{ii}={}; % cell array
   % obsahujici upravene body
   %handles.already_processed_points_ind{ii}{1}=[];
   handles.now_processed_points_ind{ii}={}; % cell array
   % obsahujici upravene, ale jeste neulozene body
   handles.now_processed_points_ind{ii}{1}=[];
   handles.fited_points{ii}={};
   handles.fited_points{ii}{1}=[];
   handles.new_points{ii}={};
   handles.new_points{ii}{1}=[];
   handles.new_points_ind{ii}={};
   handles.new_points_ind{ii}{1}=[];
   handles.spectrum_chosen_modif_recent{ii}={};
   handles.vlnocty_modif_recent{ii}={};
  end
  
  if handles.pocet_spekter==1
   set(handles.up_pushbutton,'Enable','off');
  else
   set(handles.up_pushbutton,'Enable','on');
  end
  handles.num_chos_spec=1;
  handles.spectrum_chosen=handles.data_saved(:,1);
  handles.spectrum_chosen_orig=handles.data_orig(:,1);
  handles.data_new(:,handles.num_chos_spec)=handles.spectrum_chosen;
  axes(handles.main_axes);
  hold off
  plot(handles.vlnocty,handles.spectrum_chosen_orig,'b');
  meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
  x_min=meze(1);
  x_max=meze(2);
  y_min=meze(3);
  y_max=meze(4);
  axis(gca,[x_min,x_max,y_min,y_max]);
  handles.plotting_function='load_pushbutton';
  handles.equidistant_mode=spikie_is_equidistant(handles.vlnocty,...
      handles.allowance_equidistant_vlnocty);
 end;
guidata(hObject, handles);

% --- Executes on button press in mode_pushbutton.
function mode_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to mode_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
if handles.mode_FA==1
 predef_mode_FA_answer=['Do you want to change working data set to ',...
     'the factor analysis of this data set?'];
else
 predef_mode_FA_answer=['Do you want to change working data set from ',...
     'the factor analysis back to the original data set?'];
end
mode_FA_yn = questdlg(predef_mode_FA_answer,...
 'Operational mode','yes', 'no','no');
if ~isequal(mode_FA_yn,'') 
 switch mode_FA_yn
  case 'yes'
   if handles.mode_FA==1
    handles.mode_FA=2;
    set(handles.mode_FA_pushbutton,'String','FA plots',...
        'BackgroundColor',handles.defaultBackground,'Enable','on')
    [handles.data_orig,handles.W,handles.V,handles.E]=spikie_faktorka(...
        handles.data_saved);
   else
    handles.mode_FA=1;
    set(handles.mode_FA_pushbutton,'String','normal',...
        'BackgroundColor','green','Enable','inactive')
    handles.W=diag(handles.W);
    handles.data_orig=handles.data_saved*handles.W*handles.V';
   end
   if handles.pocet_spekter==1
    set(handles.up_pushbutton,'Enable','off');
   else
    set(handles.up_pushbutton,'Enable','on');
   end
   set(handles.down_pushbutton,'Enable','off');
   set(handles.chosen_spec_text,'String','Chosen spectrum: 1')
   handles.num_chos_spec=1;
   handles.data_saved=handles.data_orig;
   handles.data_new=handles.data_orig;
   handles.manual_axes_limits=zeros(handles.pocet_spekter,24); % Prelokace
   % pameti pro pripadne manualni nastaveni mezi os, kazdemu spektru
   % nalezi vzdy ctyri cisla, [x_min,x_max,y_min,y_max], prvni ctverice je
   % pro originalni spektrum, druha pro current spectrum, treti pro
   % difference spectrum, ctvrta pro spectrum with polynomial fit,
   % pata pro spectrum with repaired points a sesta pro new spectrum.
   handles.manual_axes_indicator=zeros(handles.pocet_spekter,6);
   % indikatory rezimu auto (hodnota 0) nebo manual (hodnota 1) pro
   % jednotliva spektra, pricemz kazdy slopec nalezi jinemu zobrazeni se
   % stejnym systemem jako handles.manual_axes_limits
   handles.already_processed_spectra=zeros(1,handles.pocet_spekter);
   handles.already_processed_points_ind={}; % cell array
   handles.now_processed_points_ind={}; % cell array
   % obsahujici upravene, ale jeste neulozene body
   handles.fited_points={};
   handles.new_points={};
   handles.new_points_ind={};
   handles.already_saved=ones(1,handles.pocet_spekter); % indikator ulozeni
   % dat pro jednotliva spektra
   handles.already_batch_saved=1; % indikator ulozeni dat v modu batch
   handles.spectrum_chosen_modif_recent={};
   handles.vlnocty_modif_recent={};
   handles.differentions_recent=cell(1,handles.pocet_spekter);
   handles.spectrum_for_differentions_recent=cell(1,handles.pocet_spekter);
   handles.indices_for_differentions_recent=cell(1,handles.pocet_spekter);
   for ii=1:handles.pocet_spekter
    handles.already_processed_points_ind{ii}={}; % cell array
    % obsahujici upravene body
    %handles.already_processed_points_ind{ii}{1}=[];
    handles.now_processed_points_ind{ii}={}; % cell array
    % obsahujici upravene, ale jeste neulozene body
    handles.now_processed_points_ind{ii}{1}=[];
    handles.fited_points{ii}={};
    handles.fited_points{ii}{1}=[];
    handles.new_points{ii}={};
    handles.new_points{ii}{1}=[];
    handles.new_points_ind{ii}={};
    handles.new_points_ind{ii}{1}=[];
    handles.spectrum_chosen_modif_recent{ii}={};
    handles.vlnocty_modif_recent{ii}={};
   end 
   handles.num_chos_spec=1;
   handles.spectrum_chosen=handles.data_saved(:,handles.num_chos_spec);
   handles.spectrum_chosen_orig=handles.data_orig(:,handles.num_chos_spec);
   handles.data_new(:,handles.num_chos_spec)=handles.spectrum_chosen;
 end
 operational_mode = questdlg('Choose operational mode.', ...
 'Operational mode','single', 'batch','single');
 %-------------------------------------------------------------------------
 % Pro pokracovani nesmi dojit ke stisknuti cancel
 %-------------------------------------------------------------------------
 num_chos_spec=handles.num_chos_spec;
 if ~isequal(operational_mode,'') 
  switch operational_mode
   case 'single'
    handles.mode=1;
    set(handles.mode_display_pushbutton,'String','single')
    set(handles.spikedel_text,'Visible','on');
    set(handles.spikedel_popupmenu,'Visible','on');
    set(handles.spikefind_panel,'Position',[0.78,0.56,0.21,0.27]);
    set(handles.make_pushbutton,'Parent',handles.spikefind_panel,...
        'Position',[.3 .4 .4 .16]);
    set(handles.points_text,'Position',[.16 .81 .3 .15]);
    set(handles.degree_text,'Position',[.54 .81 .3 .15]);
    set(handles.treshold_text,'Position',[.16 .2 .3 .1]);
    set(handles.probability_text,'Position',[.54 .2 .3 .1]);
    set(handles.treshold_edit,'Position',[.21 .05 .2 .13]);
    set(handles.probability_display_text,'Position',[.52 .05 .34 .13]);
    set(handles.points_edit,'Position',[.21 .67 .2 .13]);
    set(handles.degree_edit,'Position',[.59 .67 .2 .13]);
    set(handles.spikedel_panel,'Position',[0.78,0.25,0.21,0.3],...
        'Title','Spike deletion:');
    set(handles.makedel_pushbutton,'Visible','on');
    set(handles.unselect_pushbutton,'Visible','off');
    if handles.already_saved(num_chos_spec)
     set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
        handles.defaultBackground,'TooltipString','Will save the data');
    else
     set(handles.save_pushbutton,'Enable','on','BackgroundColor','red',...
        'TooltipString',...
        'You haven''t saved your changes in this spectrum yet');
    end;
    if handles.already_processed_spectra(num_chos_spec)
     set(handles.metoda_popupmenu,'String',handles.possible_method,...
         'Value',1);
     set(handles.method_text,'Visible','on');
     set(handles.spikefind_panel,'Visible','on','Title',...
         'Spikefinding panel:');
     set(handles.make_pushbutton,'Visible','on','Enable','on');
     set(handles.metoda_popupmenu,'Visible','on','Enable','on');
     set(handles.points_text,'Visible','on');
     set(handles.degree_text,'Visible','on');
     set(handles.points_edit,'Visible','on');
     set(handles.degree_edit,'Visible','on');
     set(handles.treshold_text,'Visible','on');
     set(handles.treshold_edit,'Visible','on');
     set(handles.probability_text,'Visible','on');
     set(handles.probability_display_text,'Visible','on');
     set(handles.spikedel_panel,'Visible','on')
     handles.indices_modif=...
         handles.indices_modif_recent{num_chos_spec};
     handles.indices_modif_int=...
         handles.indices_modif_int_recent{num_chos_spec};
    else
     handles.smoothed=0;
     set(handles.metoda_popupmenu,'String',[{'Select the method'},...
         handles.possible_method],'Value',1);
     set(handles.method_text,'Visible','on');
     set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
        handles.defaultBackground,'TooltipString','Will save the data');
     set(handles.spikefind_panel,'Visible','off','Title',...
         'Spikefinding panel:');
     set(handles.make_pushbutton,'Visible','off','Enable','off');
     set(handles.metoda_popupmenu,'Visible','on','Enable','on');
     set(handles.points_text,'Visible','off');
     set(handles.degree_text,'Visible','off');
     set(handles.points_edit,'Visible','off');
     set(handles.degree_edit,'Visible','off');
     set(handles.treshold_text,'Visible','off');
     set(handles.treshold_edit,'Visible','off');
     set(handles.probability_text,'Visible','off');
     set(handles.probability_display_text,'Visible','off');
     set(handles.spikedel_panel,'Visible','off')
    end
    switch handles.already_processed_spectra(num_chos_spec)
     case 0
      set(handles.slave_popupmenu,'Enable','off','Value',1)
      choose_interval_pushbutton_plot(hObject, eventdata, handles)
     case 1       
      set(handles.slave_popupmenu,'Enable','on','String',...
          {'Original spectrum','Current spectrum','Diference spectrum'});
      if get(handles.slave_popupmenu,'Value')>3
         set(handles.slave_popupmenu,'Value',2)
      end
      slave_popupmenu_Callback(hObject, eventdata, handles);
     case 2
      set(handles.slave_popupmenu,'Enable','on','String',...
          {'Original spectrum','Current spectrum','Difference spectrum',...
          'Spectrum with polynomial fit',...
          'Spectrum with repaired points','Repaired spectrum'})
      slave_popupmenu_Callback(hObject, eventdata, handles);
    end
   case 'batch'
    go_on=1; % indikuje, zdali se maji nacist v batch mode drive upravena,
    % ale jeste neulozena spektra (hodnota 0) nebo se ma zacit odecitat
    % od zacatku
    if ~handles.already_batch_saved
     go_on_answer_dialog=['You haven''t saved last batch modification.',...
         ' New one will replace the old. Would you like to ',...
         'turn back to the old?'];
     go_on_answer = questdlg(go_on_answer_dialog, ...
     'Turn back?','yes','no','no');
     switch go_on_answer
      case 'yes'
       go_on=0;
%        handles.mode=2;
%        save_pushbutton_Callback(hObject, eventdata, handles);
%        handles.mode=1;
       chosen_spectra=handles.chosen_spectra;
      case 'no'
       handles.already_batch_saved=1;
     end
    end;
    if go_on
    prompt = {[sprintf('                Select spectra to use:\n'),...
        sprintf('      (for example 3,10:17,25\n'),...
        sprintf('you must use integers from interval (1:%d))\n',...
        handles.pocet_spekter)]};
    dlg_title_matrix = 'Selection of spectra';
    num_lines = 1;
    options.Resize='on';
    defAns=['1:',num2str(handles.pocet_spekter)];
    odpoved_chosen_spectra = inputdlg(prompt,dlg_title_matrix,num_lines,...
        {defAns},options);
    end
    %--------------------------------------------------------------------------
    % Testovani, zda nebylo stisknuto cancel
    %--------------------------------------------------------------------------
    error_indicator=0;
    if  ~go_on || ~isequal(odpoved_chosen_spectra,{})
     if go_on
      [chosen_spectra,status]=str2num(odpoved_chosen_spectra{1});
      if status==0 || isempty(chosen_spectra) ||...
             ~isequal(round(chosen_spectra),chosen_spectra) ||...
             max(chosen_spectra)>handles.pocet_spekter ||...
             min(chosen_spectra)<1 || size(chosen_spectra,1)~=1
       % Nepripustne hodnoty
       h_errordlg=errordlg(['You must type numbers of spectra chosen ',...
           'for processing'],'Incorret input','on'); 
       waitfor(h_errordlg);
       error_indicator=1;
      end
     end
     if ~error_indicator
     % Pripustne hodnoty mezi matice se ulozi do globalnich promennych
      handles.mode=2;
      handles.chosen_spectra=chosen_spectra;
      set(handles.mode_display_pushbutton,'String','batch')
      set(handles.metoda_popupmenu,'String',handles.possible_method,...
          'Value',1,'Visible','off');
      set(handles.method_text,'Visible','off');
      set(handles.spikefind_panel,'Visible','on','Title',...
          'Subtraction - Savitzky-Golay options:','Position',...
          [0.78,0.65,0.21,0.17]);
      set(handles.make_pushbutton,'Parent',handles.figure1,'Visible',...
          'on','Enable','on','Position',[0.8 0.25 0.08 0.04]);
      set(handles.points_text,'Position',[.16 .7 .3 .24],'Visible','on');
      set(handles.degree_text,'Position',[.54 .7 .3 .24],'Visible','on');
      set(handles.treshold_text,'Visible','on','Position',...
          [.16 .28 .3 .16]);
      set(handles.probability_text,'Visible','on','Position',...
          [.54 .28 .3 .16]);
      set(handles.treshold_edit,'Visible','on','Enable','on','Position',...
          [.21 .08 .2 .2]);
      set(handles.probability_display_text,'Visible','on','Position',...
          [.52 .08 .34 .2]);
      set(handles.points_edit,'Position',[.21 .48 .2 .2],'Visible','on');
      set(handles.degree_edit,'Position',[.59 .48 .2 .2],'Visible','on');
      set(handles.spikedel_panel,'Visible','on','Position',...
          [0.78,0.335,0.21,0.3],'Title',...
          'Iterative spike deletion with polynomial fit:');
      set(handles.spikedel_text,'Visible','off');
      set(handles.spikedel_popupmenu,'Visible','off');
      set(handles.makedel_pushbutton,'Visible','off');
      %set(handles.slave_popupmenu,'Enable','off','Value',1);
      if go_on
       set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
       handles.defaultBackground,'TooltipString','Will save the data');
      else
       set(handles.save_pushbutton,'Enable','on','BackgroundColor',...
       'red','TooltipString','Will save the data');
      end
      if isempty(find(handles.chosen_spectra==num_chos_spec,1))
       set(handles.unselect_pushbutton,'Enable','off','Visible','on');
      else
       set(handles.unselect_pushbutton,'Enable','on','Visible','on');
      end
      if handles.already_processed_spectra(num_chos_spec) && ~go_on
       set(handles.slave_popupmenu,'Enable','on','String',...
            {'Original spectrum','Current spectrum',...
            'Difference spectrum','Spectrum with polynomial fit',...
            'Spectrum with repaired points','Repaired spectrum'})
       slave_popupmenu_Callback(hObject, eventdata, handles);
      else
       set(handles.slave_popupmenu,'Enable','off','Value',1)
       choose_interval_pushbutton_plot(hObject, eventdata, handles)
      end
      %choose_interval_pushbutton_plot(hObject, eventdata, handles)
     end
    end
  end
 end
end
 guidata(hObject, handles);

% --- Executes on selection change in metoda_popupmenu.
function metoda_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to metoda_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slave_popupmenu,'Enable','off','Value',1);
if handles.smoothed==0 && get(handles.metoda_popupmenu,'Value')~=1
 set(handles.metoda_popupmenu,'String',handles.possible_method,...
     'Value',get(handles.metoda_popupmenu,'Value')-1);
 handles.smoothed=1;
 set(handles.spikefind_panel,'Visible','on');
 set(handles.make_pushbutton,'Visible','on','Enable','on');
end
if handles.smoothed==1
 switch get(handles.metoda_popupmenu,'Value')
  case 1
   set(handles.spikefind_panel,'Title',...
       'Subtraction - Savitzky-Golay options:');
   set(handles.points_text,'Visible','on');
   set(handles.degree_text,'Visible','on');
   set(handles.treshold_text,'Visible','on');
   set(handles.probability_text,'Visible','on');
   set(handles.probability_display_text,'Visible','on');
   set(handles.points_edit,'Visible','on');
   set(handles.degree_edit,'Visible','on');
   set(handles.treshold_edit,'Visible','on','Enable','on');
 end
end
% Hints: contents = get(hObject,'String') returns metoda_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from metoda_popupmenu
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function metoda_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metoda_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in slave_popupmenu.
function slave_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to slave_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns slave_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from slave_popupmenu
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);
used_plot=get(handles.slave_popupmenu,'Value');
handles.plotting_function='slave_popupmenu';
switch used_plot
 case 1
  axes(handles.main_axes);
  plot(handles.vlnocty,handles.spectrum_chosen,'color',[.7,.7,.7],...
      'linewidth',1);
  hold on
  for ii=1:length(handles.chosen_interval_ind)
  plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
      handles.spectrum_chosen(handles.chosen_interval_ind{ii}),...
      '-b','linewidth',1);
  end
  for ii=1:length(handles.already_processed_points_ind{...
          handles.num_chos_spec})
   if ~isempty(handles.already_processed_points_ind{...
           handles.num_chos_spec}{ii})
    if handles.already_processed_points_ind{handles.num_chos_spec}{ii}...
            (1)...
            ==1&&handles.already_processed_points_ind{...
            handles.num_chos_spec}{ii}(end)==length(handles.vlnocty)
     plot(handles.vlnocty(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}),handles.spectrum_chosen_orig(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}),'-r','linewidth',2,'MarkerSize',10);
    elseif handles.already_processed_points_ind{handles.num_chos_spec}...
            {ii}(1)==1
     plot(handles.vlnocty(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii},...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(end)+1),...
         handles.spectrum_chosen_orig(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii},...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(end)+1),'-r','linewidth',2,'MarkerSize',10);
    elseif handles.already_processed_points_ind{...
            handles.num_chos_spec}{ii}(end)==length(handles.vlnocty)
     plot(handles.vlnocty(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(1)-1,...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}),...
         handles.spectrum_chosen_orig(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(1)-1,...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}),'-r','linewidth',2,'MarkerSize',10);
    else
     plot(handles.vlnocty(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(1)-1:...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(end)+1),...
         handles.spectrum_chosen_orig(...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(1)-1:...
         handles.already_processed_points_ind{handles.num_chos_spec}...
         {ii}(end)+1),'-r','linewidth',2,'MarkerSize',10);
    end
   end
  end
  hold off
  if(handles.manual_axes_indicator(handles.num_chos_spec,used_plot))
    axis(gca,handles.manual_axes_limits(handles.num_chos_spec,...
        4*used_plot-3:4*used_plot));
  else
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
   x_min=meze(1);
   x_max=meze(2);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_min,x_max,y_min,y_max]);
  end
 case 2
  axes(handles.main_axes);
  treshold=handles.treshold;
  plot(handles.vlnocty,handles.spectrum_chosen,'color',[.7,.7,.7],...
      'linewidth',1);
  hold on
  for ii=1:length(handles.chosen_interval_ind)
   plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
       handles.spectrum_chosen(handles.chosen_interval_ind{ii}),...
       'b','linewidth',1);
  end
  for ii=1:length(handles.already_processed_points_ind{...
          handles.num_chos_spec})
   plot(handles.vlnocty(...
       handles.already_processed_points_ind{handles.num_chos_spec}{ii}),...
       handles.spectrum_chosen(...
       handles.already_processed_points_ind{handles.num_chos_spec}{ii}),...
       '-g','linewidth',5,'MarkerSize',10);
  end
  for ii=1:length(handles.indices_modif)/2
   ind=find(abs(handles.differentions(...
       handles.indices_for_differentions(ii)+1:...
       handles.indices_for_differentions(ii+1)))>treshold);
   plot(handles.vlnocty_modif{ii}(ind),handles.spectrum_chosen(ind+...
       handles.indices_modif(2*ii-1)-1),'xr','linewidth',2,'MarkerSize',10);
   plot(handles.vlnocty_modif{ii},handles.spectrum_chosen_modif{ii},'k',...
       'linewidth',2);
  end
  hold off
  if(handles.manual_axes_indicator(handles.num_chos_spec,used_plot))
    axis(gca,handles.manual_axes_limits(handles.num_chos_spec,...
        4*used_plot-3:4*used_plot));
  else
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
   x_min=meze(1);
   x_max=meze(2);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_min,x_max,y_min,y_max]);
  end
 case 3
  axes(handles.main_axes);
  treshold=str2num(get(handles.treshold_edit,'String'));
  ind=find(abs(handles.differentions)>treshold);
  for ii=1:length(handles.indices_modif)/2
   plot(handles.spectrum_for_differentions(...
       handles.indices_for_differentions(ii)+1:...
       handles.indices_for_differentions(ii+1),1),handles.differentions(...
       handles.indices_for_differentions(ii)+1:...
       handles.indices_for_differentions(ii+1)),'b');
   hold on
  end
  plot(handles.spectrum_for_differentions(ind,1),...
       handles.differentions(ind),'xr','linewidth',2,'MarkerSize',10)
  hold off
  if(handles.manual_axes_indicator(handles.num_chos_spec,used_plot))
    axis(gca,handles.manual_axes_limits(handles.num_chos_spec,...
        4*used_plot-3:4*used_plot));
  else
   adjust_differentions=zeros(length(handles.vlnocty),1);
   adjust_differentions(1:length(handles.differentions))=...
       handles.differentions;
   meze=spikie_axes_adjust([handles.vlnocty,adjust_differentions]);
   x_min=meze(1);
   x_max=meze(2);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_min,x_max,y_min,y_max]);
  end
 case 4
  axes(handles.main_axes);
  plot(handles.vlnocty,handles.spectrum_chosen,'color',[.7,.7,.7],...
      'linewidth',1);
  hold on
  for ii=1:length(handles.chosen_interval_ind)
   plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
       handles.spectrum_chosen(handles.chosen_interval_ind{ii}),'b');
  end
  for ii=1:length(handles.fited_points{handles.num_chos_spec})
   plot(handles.fited_points{handles.num_chos_spec}{ii}(:,1),...
       handles.fited_points{handles.num_chos_spec}{ii}(:,2),...
       'r','linewidth',3)
  end
  hold off
  if(handles.manual_axes_indicator(handles.num_chos_spec,used_plot))
    axis(gca,handles.manual_axes_limits(handles.num_chos_spec,...
        4*used_plot-3:4*used_plot));
  else
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
   x_min=meze(1);
   x_max=meze(2);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_min,x_max,y_min,y_max]);
  end
 case 5
  axes(handles.main_axes);
  plot(handles.vlnocty,handles.spectrum_chosen,'color',[.7,.7,.7],...
      'linewidth',1);
  hold on
  for ii=1:length(handles.chosen_interval_ind)
  plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
      handles.spectrum_chosen(handles.chosen_interval_ind{ii}),'g',...
      'linewidth',1.3);
  end
  for ii=1:length(handles.new_points{handles.num_chos_spec})
   plot(handles.new_points{handles.num_chos_spec}{ii}(:,1),...
       handles.new_points{handles.num_chos_spec}{ii}(:,2),...
       'xr','linewidth',2,'MarkerSize',10)
  end
  for ii=1:length(handles.chosen_interval_ind)
  plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
      handles.data_new(handles.chosen_interval_ind{ii},...
      handles.num_chos_spec),'b','linewidth',1.3);
  end
  hold off
  if(handles.manual_axes_indicator(handles.num_chos_spec,used_plot))
    axis(gca,handles.manual_axes_limits(handles.num_chos_spec,...
        4*used_plot-3:4*used_plot));
  else
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
   x_min=meze(1);
   x_max=meze(2);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_min,x_max,y_min,y_max]);
  end
 case 6
  axes(handles.main_axes);
  plot(handles.vlnocty,handles.data_new(:,handles.num_chos_spec),...
      'color',[.7,.7,.7],'linewidth',1);
  hold on
  for ii=1:length(handles.chosen_interval_ind)
  plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
      handles.data_new(handles.chosen_interval_ind{ii},...
      handles.num_chos_spec),'b');
  end
  hold off
  if(handles.manual_axes_indicator(handles.num_chos_spec,used_plot))
    axis(gca,handles.manual_axes_limits(handles.num_chos_spec,...
        4*used_plot-3:4*used_plot));
  else
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
   x_min=meze(1);
   x_max=meze(2);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_min,x_max,y_min,y_max]);
  end
end


% --- Executes during object creation, after setting all properties.
function slave_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slave_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chose_spec_pushbutton.
function chose_spec_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to chose_spec_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {sprintf('Select one spectrum\n(integer from 1 to %d)',...
    handles.pocet_spekter)}; 
dlg_title_matrix = 'Selection of spectrum';
num_lines = 1;
options.Resize='on';
odpoved_num_of_spec=inputdlg(prompt,dlg_title_matrix,num_lines,{'',''},...
    options);
%--------------------------------------------------------------------------
% Testovani, zda nebylo stisknuto cancel
%--------------------------------------------------------------------------
if ~isequal(odpoved_num_of_spec,{})
 [num_chos_spec,status]=str2num(odpoved_num_of_spec{1});
 if num_chos_spec<1 || num_chos_spec>handles.pocet_spekter || status==0 ||...
    ~isequal(floor(num_chos_spec),num_chos_spec) || size(num_chos_spec,2)~=1
% Nepripustne hodnoty
  set(handles.chosen_spec_text,'String', 'No such spectrum', ...
   'BackgroundColor','red'); % Chybna hodnota a jeji cervena indikace
  cla(handles.main_axes); 
  %errordlg('You selected incorret number of spectra','Incorret input','on'); 
 else % Pripustne hodnoty mezi matice se ulozi do globalnich promennych
  handles.smoothed=0;
  if num_chos_spec>1
   set(handles.down_pushbutton,'Enable','on');
  else
   set(handles.down_pushbutton,'Enable','off');
  end
  if num_chos_spec<handles.pocet_spekter
   set(handles.up_pushbutton,'Enable','on');
  else
   set(handles.up_pushbutton,'Enable','off');
  end
  set(handles.chosen_spec_text,'String',sprintf('Chosen spectrum: %d',...
      num_chos_spec),'BackgroundColor','green');
  chose_spec_handles_set(hObject, eventdata, handles, num_chos_spec);
  handles=guidata(hObject);
 end
end  
guidata(hObject, handles);

% --- Executes on button press in down_pushbutton.
function down_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to down_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.smoothed=0;
num_chos_spec=handles.num_chos_spec-1;
set(handles.chosen_spec_text,'String',sprintf('Chosen spectrum: %d',...
    num_chos_spec),'BackgroundColor','green');
set(handles.up_pushbutton,'Enable','on');
chose_spec_handles_set(hObject, eventdata, handles, num_chos_spec);
handles=guidata(hObject);
if num_chos_spec>1
 set(handles.down_pushbutton,'Enable','on');
else
 set(handles.down_pushbutton,'Enable','off');
end
guidata(hObject, handles)


% --- Executes on button press in up_pushbutton.
function up_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to up_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.smoothed=0;
num_chos_spec=handles.num_chos_spec+1;
set(handles.chosen_spec_text,'String',sprintf('Chosen spectrum: %d',...
    num_chos_spec),'BackgroundColor','green');
set(handles.down_pushbutton,'Enable','on');
chose_spec_handles_set(hObject, eventdata, handles, num_chos_spec);
handles=guidata(hObject);
if num_chos_spec<handles.pocet_spekter
 set(handles.up_pushbutton,'Enable','on');
else
 set(handles.up_pushbutton,'Enable','off');
end
guidata(hObject, handles)


% --- Executes on button press in make_pushbutton.
function make_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to make_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);
if handles.degree>=handles.points
 h_errordlg=errordlg(['Degree of polynom used for Savitzky-Golay ',...
     'filter must be less than number of points. Please correct their ',...
     'values.']);
 waitfor(h_errordlg);
 return
end
switch handles.mode
 case 1
  switch get(handles.metoda_popupmenu,'Value')
   case 1
    set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
        handles.defaultBackground,'TooltipString','Will save the data');
    handles.make_pushbutton_indicator(handles.num_chos_spec)=1;
    % nastaveni indikatoru provedeni
    % SavGol filtru pro potreby vykresleni grafu po zmacknuti tlacitka
    % choose interval
    set(handles.slave_popupmenu,'Enable','on','String',...
        {'Original spectrum','Current spectrum','Diference spectrum'},...
        'Value',2);
    set(handles.treshold_edit,'Enable','on');
    set(handles.spikedel_panel,'Visible','on');
%     set(handles.degree_poly_buttongroup,'SelectedObject',handles.poly_2_radiobutton);
%     handles.poly_fit_degree=2;
    degree_edit=str2double(get(handles.degree_edit,'String'));
    points_edit=str2double(get(handles.points_edit,'String'));
    half_points_edit=floor(points_edit/2);
    chosen_interval_ind=handles.chosen_interval_ind;
    length_vlnocty=length(handles.vlnocty);
    l_chosen_interval_ind=length(chosen_interval_ind);
    indices=zeros(1,l_chosen_interval_ind);
    spectrum=cell(1,l_chosen_interval_ind);
    vlnocty_modif=cell(1,l_chosen_interval_ind);
    spectrum_for_differentions=[];
    indices_for_differentions=zeros(1,l_chosen_interval_ind+1);
    for ii=1:l_chosen_interval_ind
     if chosen_interval_ind{ii}(1)-half_points_edit<1
      bottom=1;
     else
      bottom=chosen_interval_ind{ii}(1)-half_points_edit;
     end
     if chosen_interval_ind{ii}(end)+half_points_edit>length_vlnocty
      top=length_vlnocty;
     else
      top=chosen_interval_ind{ii}(end)+half_points_edit;
     end
     used_for_savgol_ind=bottom:top;
     [spectrum_n,indices_n] = spikie_SavGolDer([handles.vlnocty(...
         used_for_savgol_ind),handles.spectrum_chosen(...
         used_for_savgol_ind)],degree_edit,points_edit,0,...
         handles.equidistant_mode);
     indices(2*ii-1:2*ii)=indices_n+bottom-1;
     spectrum{ii}=spectrum_n(:,2);
     vlnocty_modif{ii}=spectrum_n(:,1);
     spectrum_for_differentions=[spectrum_for_differentions;spectrum_n];
     indices_for_differentions(ii+1)=indices_for_differentions(ii)+...
         indices_n(2)-indices_n(1)+1;
    end
    handles.indices_for_differentions=indices_for_differentions;%
    handles.spectrum_for_differentions=spectrum_for_differentions;%
    handles.indices_modif=indices;
    handles.vlnocty_modif=vlnocty_modif;%
    handles.spectrum_chosen_modif=spectrum;%
    indices_modif_int=[];
    for ii=2:2:length(indices)
     indices_modif_int=[indices_modif_int,...
         indices(ii-1):indices(ii)];
    end
    handles.indices_modif_int=indices_modif_int;
    handles.indices_modif_recent{handles.num_chos_spec}=indices;
    handles.indices_modif_int_recent{handles.num_chos_spec}=...
        indices_modif_int;
    differentions=handles.spectrum_chosen(indices_modif_int)...
        -spectrum_for_differentions(:,2);
    error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
    differentions=differentions/error;
    handles.differentions=differentions;%
    
    handles.differentions_recent{handles.num_chos_spec}=differentions;
    handles.spectrum_for_differentions_recent{handles.num_chos_spec}=...
        spectrum_for_differentions;
    handles.indices_for_differentions_recent{handles.num_chos_spec}=...
        indices_for_differentions;
    handles.spectrum_chosen_modif_recent{handles.num_chos_spec}=spectrum;
    handles.vlnocty_modif_recent{handles.num_chos_spec}=vlnocty_modif;  
    handles.already_processed_spectra(handles.num_chos_spec)=1;
    
    %Plotting the results
    slave_popupmenu_Callback(hObject, eventdata, handles);
  end
 case 2
  if handles.poly_fit_degree>=handles.fited_points_for_edit
   h_errordlg=errordlg(['Degree of polynom used for spike deletion ',...
       'must be less than half number of fited points. Please correct ',...
       'its value.']);
   waitfor(h_errordlg);
   return
  end
  set(handles.unselect_pushbutton,'Enable','off');
  enable_save_file_pushbutton=get(handles.save_file_pushbutton,'Enable');
  evrything_enable_disable(hObject, eventdata, handles, 'off')
  set(handles.save_pushbutton,'BackgroundColor',handles.defaultBackground);
  drawnow
  handles.data_new(:,handles.chosen_spectra)=...
      handles.data_saved(:,handles.chosen_spectra);
  handles.make_pushbutton_indicator(handles.chosen_spectra)=2;
    % nastaveni indikatoru provedeni SavGol filtru pro potreby vykresleni
    % grafu po zmacknuti tlacitka choose interval
  degree_edit=str2double(get(handles.degree_edit,'String'));
  points_edit=str2double(get(handles.points_edit,'String'));
  half_points_edit=floor(points_edit/2);
  del_around=str2double(get(handles.del_points_edit,'String'));
  half_fited_points=str2double(get(handles.fited_points_edit,'String'));
  treshold=handles.treshold;
  poly_fit_degree=handles.poly_fit_degree;
  chosen_interval_ind=handles.chosen_interval_ind;
  vlnocty=handles.vlnocty;
  length_vlnocty=length(vlnocty);
  l_chosen_interval_ind=length(chosen_interval_ind);
  set(handles.slave_popupmenu,'String',...
      {'Original spectrum','Current spectrum','Diference spectrum'},...
      'Value',2);
  maxiter_indicator=[];
  for ii=1:l_chosen_interval_ind
   if chosen_interval_ind{ii}(1)-half_points_edit<1
    bottom=1;
   else
    bottom=chosen_interval_ind{ii}(1)-half_points_edit;
   end
   if chosen_interval_ind{ii}(end)+half_points_edit>length_vlnocty
    top=length_vlnocty;
   else
    top=chosen_interval_ind{ii}(end)+half_points_edit;
   end
   used_for_savgol_ind{ii}=bottom:top;
  end
  l_chosen_spectra=length(handles.chosen_spectra);
  waitbar_h = waitbar(0,'1','Name','Processed spectrum:',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
  setappdata(waitbar_h,'canceling',0);
  step=0;
  waitbar_cancel_indicator=0;
  for num_chos_spec=handles.chosen_spectra
   step=step+1;
   if getappdata(waitbar_h,'canceling')
    waitbar_cancel_indicator=1;
    break
   end
   waitbar(step/l_chosen_spectra,waitbar_h,sprintf(...
       'Processed spectrum: %5d',num_chos_spec))
   spectrum_chosen=handles.data_saved(:,num_chos_spec);
   spectrum_chosen_orig=handles.data_orig(:,num_chos_spec);
   indices=zeros(1,l_chosen_interval_ind);
   spectrum=cell(1,l_chosen_interval_ind);
   vlnocty_modif=cell(1,l_chosen_interval_ind);
   spectrum_for_differentions=[];
   indices_for_differentions=zeros(1,l_chosen_interval_ind+1);
   spectrum_for_spikefinding=spectrum_chosen; % Aby se pri fitovani
   % neuvazovaly jiz odectene body mimo vybrany interval, je treba nahradit
   % originalni spektrum mimo vybrany interval spektrem jiz odectenym.
   for ii=1:l_chosen_interval_ind
    spectrum_for_spikefinding(chosen_interval_ind{ii})=...
        spectrum_chosen_orig(chosen_interval_ind{ii});
   end
   for ii=1:l_chosen_interval_ind
    [spectrum_n,indices_n] = spikie_SavGolDer([vlnocty(...
        used_for_savgol_ind{ii}),spectrum_chosen(...
        used_for_savgol_ind{ii})],degree_edit,points_edit,0,...
        handles.equidistant_mode);
    indices(2*ii-1:2*ii)=indices_n+used_for_savgol_ind{ii}(1)-1;
    spectrum{ii}=spectrum_n(:,2);
    vlnocty_modif{ii}=spectrum_n(:,1);
    spectrum_for_differentions=[spectrum_for_differentions;spectrum_n];
    indices_for_differentions(ii+1)=indices_for_differentions(ii)+...
        indices_n(2)-indices_n(1)+1;
   end
   handles.indices_for_differentions=indices_for_differentions;
   handles.spectrum_for_differentions=spectrum_for_differentions;
   handles.indices_modif=indices;
   handles.vlnocty_modif=vlnocty_modif;
   handles.spectrum_chosen_modif=spectrum;
   indices_modif_int=[];
   for ii=2:2:length(indices)
    indices_modif_int=[indices_modif_int,...
        indices(ii-1):indices(ii)];
   end
   differentions=spectrum_chosen(indices_modif_int)...
       -spectrum_for_differentions(:,2);
   error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
   
   differentions=(spectrum_chosen_orig(indices_modif_int)...
       -handles.spectrum_for_differentions(:,2))/error;
   new_spectrum=spectrum_for_spikefinding;
   new_points={};
   new_points_ind={};
   fited_points={};
   for ii=1:length(chosen_interval_ind)
    ind=find(abs(differentions(...
        indices_for_differentions(ii)+1:...
        indices_for_differentions(ii+1)))>treshold)+...
        indices(2*ii-1)-1;
    [new_points_n,new_points_ind_n,fited_points_n,new_spectrum_n]=...
        spikie_find_to_delete(ind,del_around,half_fited_points,...
        poly_fit_degree,vlnocty,spectrum_for_spikefinding,...
        chosen_interval_ind{ii}(1),...
        chosen_interval_ind{ii}(end));
    new_points=[new_points,new_points_n];
    new_points_ind=[new_points_ind,new_points_ind_n];
    fited_points=[fited_points,fited_points_n];
    new_spectrum(chosen_interval_ind{ii})=new_spectrum_n(...
        chosen_interval_ind{ii});
   end
   length_vlnocty=length(vlnocty);
   l_chosen_interval_ind=length(chosen_interval_ind);
   spectrum=cell(1,l_chosen_interval_ind); %!
   vlnocty_modif=cell(1,l_chosen_interval_ind); %!
   spectrum_for_differentions=[];
   for ii=1:l_chosen_interval_ind
    [spectrum_n,indices_n] = spikie_SavGolDer([vlnocty(...
        used_for_savgol_ind{ii}),new_spectrum(...
        used_for_savgol_ind{ii})],degree_edit,points_edit,0,...
        handles.equidistant_mode);
    spectrum{ii}=spectrum_n(:,2);
    vlnocty_modif{ii}=spectrum_n(:,1);
    spectrum_for_differentions=[spectrum_for_differentions;spectrum_n];
   end
   differentions=new_spectrum(indices_modif_int)...
       -spectrum_for_differentions(:,2);
   error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
   differentions=differentions/error;
   differentions_orig=(spectrum_chosen_orig(indices_modif_int)...
       -spectrum_for_differentions(:,2))/error;
   jj=1;
   while 1
    jj=jj+1;
    if jj>handles.maxiter
     maxiter_indicator=[maxiter_indicator,num_chos_spec];
     break;
    end
    new_points={};
    new_points_ind={};
    fited_points={};
    indicator_of_end=1;
    new_spectrum=spectrum_for_spikefinding;
    for ii=1:length(chosen_interval_ind)
     ind=find(abs(differentions(...
         indices_for_differentions(ii)+1:...
         indices_for_differentions(ii+1)))>treshold)+...
         indices(2*ii-1)-1;
     ind_orig=find(abs(differentions_orig(...
         indices_for_differentions(ii)+1:...
         indices_for_differentions(ii+1)))>treshold)+...
         indices(2*ii-1)-1;
     if ~isempty(ind)
      indicator_of_end=0;
     end
     [new_points_n,new_points_ind_n,fited_points_n,new_spectrum_n]=...
         spikie_find_to_delete(ind_orig,del_around,half_fited_points,...
         poly_fit_degree,vlnocty,spectrum_for_spikefinding,...
         chosen_interval_ind{ii}(1),chosen_interval_ind{ii}(end));
     new_points=[new_points,new_points_n];
     new_points_ind=[new_points_ind,new_points_ind_n];
     fited_points=[fited_points,fited_points_n];
     new_spectrum(chosen_interval_ind{ii})=new_spectrum_n(...
         chosen_interval_ind{ii});
    end
    if indicator_of_end
     break
    end
    spectrum=cell(1,l_chosen_interval_ind); %!
    vlnocty_modif=cell(1,l_chosen_interval_ind); %!
    spectrum_for_differentions=[];
    for ii=1:l_chosen_interval_ind
     [spectrum_n,indices_n] = spikie_SavGolDer([vlnocty(...
         used_for_savgol_ind{ii}),new_spectrum(...
         used_for_savgol_ind{ii})],degree_edit,points_edit,0,...
         handles.equidistant_mode);
     spectrum{ii}=spectrum_n(:,2);
     vlnocty_modif{ii}=spectrum_n(:,1);
     spectrum_for_differentions=[spectrum_for_differentions;spectrum_n];
    end
    differentions=new_spectrum(indices_modif_int)...
        -spectrum_for_differentions(:,2);
    error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
    differentions=differentions/error;
    differentions_orig=(spectrum_chosen_orig(indices_modif_int)...
        -spectrum_for_differentions(:,2))/error;
   end
   handles.new_points{num_chos_spec}=new_points;
   handles.new_points_ind{num_chos_spec}=new_points_ind;
   handles.fited_points{num_chos_spec}=fited_points;
   handles.data_new(:,num_chos_spec)=new_spectrum;
   handles.already_processed_spectra(num_chos_spec)=2;
   handles.spectrum_chosen_modif_recent{num_chos_spec}=spectrum;
   handles.vlnocty_modif_recent{num_chos_spec}=vlnocty_modif;
   handles.differentions_recent{num_chos_spec}=differentions_orig;
   handles.spectrum_for_differentions_recent{num_chos_spec}=...
       spectrum_for_differentions;
   handles.indices_for_differentions_recent{num_chos_spec}=...
       indices_for_differentions;
%    handles.already_processed_points_ind{num_chos_spec}=...
%        new_points_ind; % prida do cell array
   handles.indices_modif_recent{num_chos_spec}=indices;
   handles.indices_modif_int_recent{num_chos_spec}=...
        indices_modif_int;
   handles.already_saved(num_chos_spec)=0;
  end
  delete(waitbar_h)
  set(handles.chosen_spec_text,'String',sprintf('Chosen spectrum: %d',...
    handles.num_chos_spec),'BackgroundColor','green');
  handles.differentions=handles.differentions_recent{handles.num_chos_spec};
  handles.spectrum_for_differentions=...
      handles.spectrum_for_differentions_recent{handles.num_chos_spec};
  handles.indices_for_differentions=indices_for_differentions;
  handles.spectrum_chosen_modif=...
      handles.spectrum_chosen_modif_recent{handles.num_chos_spec};
  handles.vlnocty_modif=handles.vlnocty_modif_recent{handles.num_chos_spec};
  handles.indices_modif=indices;
  handles.indices_modif_int=indices_modif_int;
    
%   handles.spectrum_chosen=handles.data_saved(:,num_chos_spec);
%   handles.spectrum_chosen_orig=handles.data_orig(:,num_chos_spec);
%   handles.data_new(:,handles.num_chos_spec)=handles.spectrum_chosen;  
  if isempty(find(handles.chosen_spectra==handles.num_chos_spec,1))
   set(handles.unselect_pushbutton,'Enable','off')
  else
   set(handles.unselect_pushbutton,'Enable','on')
  end
  evrything_enable_disable(hObject, eventdata, handles, 'on')
  set(handles.save_file_pushbutton,'Enable',enable_save_file_pushbutton);
  if waitbar_cancel_indicator
   handles.already_batch_saved=1;
   set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
       handles.defaultBackground,'TooltipString',...
       'Will save processed spectra');
   set(handles.slave_popupmenu,'Value',1,'Enable','off')
  else
   handles.already_batch_saved=0;
   set(handles.save_pushbutton,'Enable','on','BackgroundColor','red',...
       'TooltipString',...
       'You haven''t saved your changes in this spectrum yet');
   set(handles.slave_popupmenu,'String',{'Original spectrum',...
       'Current spectrum','Diference spectrum',...
       'Spectrum with polynomial fit','Spectrum with repaired points',...
       'Repaired spectrum'},'Value',4)
  end
  if handles.already_processed_spectra(handles.num_chos_spec)
   set(handles.slave_popupmenu,'Enable','on','String',...
       {'Original spectrum','Current spectrum','Difference spectrum',...
       'Spectrum with polynomial fit','Spectrum with repaired points',...
       'Repaired spectrum'})
   slave_popupmenu_Callback(hObject, eventdata, handles);
  else
   set(handles.slave_popupmenu,'Enable','off','Value',1)
       choose_interval_pushbutton_plot(hObject, eventdata, handles)
  end
  if ~isempty(maxiter_indicator)
   maxiterized_spectra=sprintf('%d',maxiter_indicator(1));
   for kk=2:length(maxiter_indicator)
    maxiterized_spectra=strcat(maxiterized_spectra,sprintf(', %d',maxiter_indicator(kk)));
   end
   errordlg_message=['Algorithm was terminatetd, because it reached ',...
         sprintf('maximum number of iterations (%d) ',handles.maxiter),...
         sprintf('in spectra:\n\n %s \n\n',maxiterized_spectra),...
         'It can be changed in file spikie.ini by setting value ',...
         'maxiter. If this file don''t exist, you must ',...
         'create it in the same directory, where spikie is. Also, if ',...
         'the maxiter entry misses, you must create it. ',...
         'For example you can add to ''spikie.ini'' line: maxiter=1000. ',...
         'For comments use ''%''.'];
   h_errordlg=errordlg(errordlg_message,['Reached maximum number of '...
       'iteration']);
   waitfor(h_errordlg);
  end
end
guidata(hObject, handles);


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);
switch handles.mode
 case 1
  handles.already_saved(handles.num_chos_spec)=1;
  handles.spectrum_chosen=handles.data_new(:,handles.num_chos_spec);
  handles.already_processed_points_ind{handles.num_chos_spec}=...
      spikie_union(handles.already_processed_points_ind{...
      handles.num_chos_spec},handles.new_points_ind{...
      handles.num_chos_spec}); % prida do cell array
  % pro jiz zpracovane body prave zpracovane body
  handles.data_saved(:,handles.num_chos_spec)=...
      handles.data_new(:,handles.num_chos_spec);
  set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
      handles.defaultBackground,'TooltipString','Will save the data');
  set(handles.save_file_pushbutton,'Enable','on');
  slave_popupmenu_Callback(hObject, eventdata, handles);
 case 2
  handles.already_batch_saved=1;
  handles.spectrum_chosen=handles.data_new(:,handles.num_chos_spec);
  for ii=handles.chosen_spectra
   handles.already_saved(ii)=1;
   handles.already_processed_points_ind{ii}=...
       spikie_union(handles.already_processed_points_ind{ii},...
       handles.new_points_ind{ii}); % prida do cell array
   % pro jiz zpracovane body prave zpracovane body
  end
  handles.data_saved(:,handles.chosen_spectra)=...
      handles.data_new(:,handles.chosen_spectra);
  set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
      handles.defaultBackground,'TooltipString','Will save the data');
  set(handles.save_file_pushbutton,'Enable','on');
  slave_popupmenu_Callback(hObject, eventdata, handles);
end
guidata(hObject, handles);


function points_edit_Callback(hObject, eventdata, handles)
% hObject    handle to points_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of points_edit as text
%        str2double(get(hObject,'String')) returns contents of points_edit as a double
[points,status]=str2num(get(hObject,'String'));
if ~status || points<3 || (points+1)/2~=round(points/2) 
  set(handles.points_edit,'String',num2str(handles.points),...
      'BackgroundColor','red');
else
 set(handles.points_edit,'BackgroundColor',[1,1,1]);
 if handles.points~=points && handles.mode==1
  set(handles.spikedel_panel,'Visible','off');
 end
 handles.points=points;
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function points_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to points_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function degree_edit_Callback(hObject, eventdata, handles)
% hObject    handle to degree_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of degree_edit as text
%        str2double(get(hObject,'String')) returns contents of degree_edit as a double
[degree,status]=str2num(get(hObject,'String'));
if ~status || degree<0 || degree~=round(degree) 
  set(handles.degree_edit,'String',num2str(handles.degree),...
      'BackgroundColor','red');
else
 set(handles.degree_edit,'BackgroundColor',[1,1,1]);
 if handles.degree~=degree && handles.mode==1
  set(handles.spikedel_panel,'Visible','off');
 end
 handles.degree=degree;
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function degree_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degree_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function treshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to treshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of treshold_edit as text
%        str2double(get(hObject,'String')) returns contents of treshold_edit as a double
[treshold,status]=str2num(get(hObject,'String'));
if ~status || treshold<=0
  probability=sprintf('%.7f %%',100*erf(handles.treshold/sqrt(2)));
  set(handles.probability_display_text,'String',probability);
  set(handles.treshold_edit,'String',num2str(handles.treshold),...
      'BackgroundColor','red');
else
probability=sprintf('%.7f %%',100*erf(treshold/sqrt(2)));
set(handles.probability_display_text,'String',probability);
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.slave_popupmenu,'Value',2)
handles.treshold=treshold;
if handles.mode==1
 if handles.make_pushbutton_indicator(handles.num_chos_spec)==0
  make_pushbutton_Callback(hObject, eventdata, handles);
 else
  slave_popupmenu_Callback(hObject,eventdata,handles);
 end
end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function treshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to treshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function del_points_edit_Callback(hObject, eventdata, handles)
% hObject    handle to del_points_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of del_points_edit as text
%        str2double(get(hObject,'String')) returns contents of del_points_edit as a double
[del_points,status]=str2num(get(hObject,'String'));
if ~status || del_points<0 || del_points~=round(del_points) 
  set(handles.del_points_edit,'String',num2str(handles.del_points),...
      'BackgroundColor','red');
else
 set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
 handles.del_points=del_points;
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function del_points_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to del_points_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in spikedel_popupmenu.
function spikedel_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to spikedel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns spikedel_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spikedel_popupmenu


% --- Executes during object creation, after setting all properties.
function spikedel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spikedel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in makedel_pushbutton.
function makedel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to makedel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
if handles.poly_fit_degree>=handles.fited_points_for_edit
 h_errordlg=errordlg(['Degree of polynom used for spike deletion must ',...
     'be less than half number of fited points. Please correct its ',...
     'value.']);
 waitfor(h_errordlg);
 return
end
switch get(handles.spikedel_popupmenu,'Value')
 case 1
  handles.data_new(:,handles.num_chos_spec)=handles.spectrum_chosen;
  indices_modif_int=handles.indices_modif_int;
  differentions=handles.spectrum_chosen(indices_modif_int)...
      -handles.spectrum_for_differentions(:,2);
  error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
  handles.differentions=differentions/error;
  differentions=(handles.spectrum_chosen_orig(indices_modif_int)...
      -handles.spectrum_for_differentions(:,2))/error;
  del_around=str2double(get(handles.del_points_edit,'String'));
  half_fited_points=str2double(get(handles.fited_points_edit,'String'));
  treshold=handles.treshold;
  new_points={};
  new_points_ind={};
  fited_points={};
  spectrum_for_spikefinding=handles.spectrum_chosen; % Aby se pri fitovani
  % neuvazovaly jiz odectene body mimo vybrany interval, je treba nahradit
  % originalni spektrum mimo vybrany interval spektrem jiz odectenym.
  for ii=1:length(handles.chosen_interval_ind)
   spectrum_for_spikefinding(handles.chosen_interval_ind{ii})=...
       handles.spectrum_chosen_orig(handles.chosen_interval_ind{ii});
  end
  new_spectrum=spectrum_for_spikefinding;
  for ii=1:length(handles.chosen_interval_ind)
   ind=find(abs(differentions(...
       handles.indices_for_differentions(ii)+1:...
       handles.indices_for_differentions(ii+1)))>treshold)+...
       handles.indices_modif(2*ii-1)-1;
   [new_points_n,new_points_ind_n,fited_points_n,new_spectrum_n]=...
       spikie_find_to_delete(ind,del_around,half_fited_points,...
       handles.poly_fit_degree,handles.vlnocty,spectrum_for_spikefinding,...
       handles.chosen_interval_ind{ii}(1),...
       handles.chosen_interval_ind{ii}(end));
   new_points=[new_points,new_points_n];
   new_points_ind=[new_points_ind,new_points_ind_n];
   fited_points=[fited_points,fited_points_n];
   new_spectrum(handles.chosen_interval_ind{ii})=new_spectrum_n(...
       handles.chosen_interval_ind{ii});
  end
  handles.new_points{handles.num_chos_spec}=new_points;
  handles.new_points_ind{handles.num_chos_spec}=new_points_ind;
  handles.fited_points{handles.num_chos_spec}=fited_points;
  handles.data_new(:,handles.num_chos_spec)=new_spectrum;
  handles.already_processed_spectra(handles.num_chos_spec)=2;
  
  handles.differentions_recent{handles.num_chos_spec}=...
      handles.differentions;
  handles.already_saved(handles.num_chos_spec)=0;
  set(handles.save_pushbutton,'Enable','on','BackgroundColor','red',...
      'TooltipString',...
      'You haven''t saved your changes in this spectrum yet');
  set(handles.slave_popupmenu,'String',{'Original spectrum',...
      'Current spectrum','Difference spectrum',...
      'Spectrum with polynomial fit','Spectrum with repaired points',...
      'Repaired spectrum'},'Value',4)
  slave_popupmenu_Callback(hObject, eventdata, handles);
 case 2
  set(handles.metoda_popupmenu,'Enable','off');
  set(handles.makedel_pushbutton,'Enable','off');
  set(handles.spikedel_popupmenu,'Enable','off');
  enable_save_file_pushbutton=get(handles.save_file_pushbutton,'Enable');
  evrything_enable_disable(hObject, eventdata, handles, 'off')
  set(handles.save_pushbutton,'BackgroundColor',handles.defaultBackground);
  drawnow
  max_iter_reached_indicator=0;
  chosen_interval_ind=handles.chosen_interval_ind;
  spectrum_chosen=handles.spectrum_chosen;
  spectrum_chosen_orig=handles.spectrum_chosen_orig;
  handles.data_new(:,handles.num_chos_spec)=spectrum_chosen;
  indices_modif_int=handles.indices_modif_int;
  indices=handles.indices_modif;
  indices_for_differentions=handles.indices_for_differentions;
  differentions=spectrum_chosen(indices_modif_int)...
      -handles.spectrum_for_differentions(:,2);
  error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
  differentions=(spectrum_chosen_orig(indices_modif_int)...
      -handles.spectrum_for_differentions(:,2))/error;
  del_around=str2double(get(handles.del_points_edit,'String'));
  half_fited_points=str2double(get(handles.fited_points_edit,'String'));
  treshold=handles.treshold;
  poly_fit_degree=handles.poly_fit_degree;
  degree_edit=str2double(get(handles.degree_edit,'String'));
  points_edit=str2double(get(handles.points_edit,'String'));
  vlnocty=handles.vlnocty;
  new_points={};
  new_points_ind={};
  fited_points={};
  spectrum_for_spikefinding=spectrum_chosen; % Aby se pri fitovani
  % neuvazovaly jiz odectene body mimo vybrany interval, je treba nahradit
  % originalni spektrum mimo vybrany interval spektrem jiz odectenym.
  for ii=1:length(chosen_interval_ind)
   spectrum_for_spikefinding(handles.chosen_interval_ind{ii})=...
       spectrum_chosen_orig(handles.chosen_interval_ind{ii});
  end
  new_spectrum=spectrum_for_spikefinding;
  for ii=1:length(chosen_interval_ind)
   ind=find(abs(differentions(...
       indices_for_differentions(ii)+1:...
       indices_for_differentions(ii+1)))>treshold)+...
       indices(2*ii-1)-1;
   [new_points_n,new_points_ind_n,fited_points_n,new_spectrum_n]=...
       spikie_find_to_delete(ind,del_around,half_fited_points,...
       handles.poly_fit_degree,handles.vlnocty,spectrum_for_spikefinding,...
       handles.chosen_interval_ind{ii}(1),...
       handles.chosen_interval_ind{ii}(end));
   new_points=[new_points,new_points_n];
   new_points_ind=[new_points_ind,new_points_ind_n];
   fited_points=[fited_points,fited_points_n];
   new_spectrum(handles.chosen_interval_ind{ii})=new_spectrum_n(...
       handles.chosen_interval_ind{ii});
  end
  half_points_edit=floor(points_edit/2);
  length_vlnocty=length(handles.vlnocty);
  l_chosen_interval_ind=length(chosen_interval_ind);
  spectrum=cell(1,l_chosen_interval_ind); %!
  vlnocty_modif=cell(1,l_chosen_interval_ind); %!
  spectrum_for_differentions=[];
  used_for_savgol_ind=cell(1,l_chosen_interval_ind); %!
  for ii=1:l_chosen_interval_ind
   if chosen_interval_ind{ii}(1)-half_points_edit<1
    bottom=1;
   else
    bottom=chosen_interval_ind{ii}(1)-half_points_edit;
   end
   if chosen_interval_ind{ii}(end)+half_points_edit>length_vlnocty
    top=length_vlnocty;
   else
    top=chosen_interval_ind{ii}(end)+half_points_edit;
   end
   used_for_savgol_ind{ii}=bottom:top;
   [spectrum_n,indices_n] = spikie_SavGolDer([vlnocty(...
       used_for_savgol_ind{ii}),new_spectrum(...
       used_for_savgol_ind{ii})],degree_edit,points_edit,0,...
       handles.equidistant_mode);
   spectrum{ii}=spectrum_n(:,2);
   vlnocty_modif{ii}=spectrum_n(:,1);
   spectrum_for_differentions=[spectrum_for_differentions;spectrum_n];
  end
  differentions=new_spectrum(indices_modif_int)...
      -spectrum_for_differentions(:,2);
  error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
  differentions=differentions/error;
  differentions_orig=(spectrum_chosen_orig(indices_modif_int)...
      -spectrum_for_differentions(:,2))/error;
  jj=1;
  while 1
   jj=jj+1;
   if jj>handles.maxiter
    max_iter_reached_indicator=1;
    break;
   end
   new_points={};
   new_points_ind={};
   fited_points={};
   indicator_of_end=1;
   new_spectrum=spectrum_for_spikefinding;
   for ii=1:length(chosen_interval_ind)
    ind=find(abs(differentions(...
        indices_for_differentions(ii)+1:...
        indices_for_differentions(ii+1)))>treshold)+...
        indices(2*ii-1)-1;
    ind_orig=find(abs(differentions_orig(...
        indices_for_differentions(ii)+1:...
        indices_for_differentions(ii+1)))>treshold)+...
        indices(2*ii-1)-1;
    if ~isempty(ind)
     indicator_of_end=0;
    end
    [new_points_n,new_points_ind_n,fited_points_n,new_spectrum_n]=...
        spikie_find_to_delete(ind_orig,del_around,half_fited_points,...
        poly_fit_degree,vlnocty,spectrum_for_spikefinding,...
        chosen_interval_ind{ii}(1),chosen_interval_ind{ii}(end));
    new_points=[new_points,new_points_n];
    new_points_ind=[new_points_ind,new_points_ind_n];
    fited_points=[fited_points,fited_points_n];
    new_spectrum(chosen_interval_ind{ii})=new_spectrum_n(...
        chosen_interval_ind{ii});
   end
   if indicator_of_end
    break
   end
   spectrum=cell(1,l_chosen_interval_ind); %!
   vlnocty_modif=cell(1,l_chosen_interval_ind); %!
   spectrum_for_differentions=[];
   for ii=1:l_chosen_interval_ind
    [spectrum_n,indices_n] = spikie_SavGolDer([vlnocty(...
        used_for_savgol_ind{ii}),new_spectrum(...
        used_for_savgol_ind{ii})],degree_edit,points_edit,0,...
        handles.equidistant_mode);
    spectrum{ii}=spectrum_n(:,2);
    vlnocty_modif{ii}=spectrum_n(:,1);
    spectrum_for_differentions=[spectrum_for_differentions;spectrum_n];
   end
   differentions=new_spectrum(indices_modif_int)...
       -spectrum_for_differentions(:,2);
   error=sqrt(sum(differentions.^2)/(length(indices_modif_int)-1));
   differentions=differentions/error;
   differentions_orig=(spectrum_chosen_orig(indices_modif_int)...
       -spectrum_for_differentions(:,2))/error;
  end
  handles.new_points{handles.num_chos_spec}=new_points;
  handles.new_points_ind{handles.num_chos_spec}=new_points_ind;
  handles.fited_points{handles.num_chos_spec}=fited_points;
  handles.data_new(:,handles.num_chos_spec)=new_spectrum;
  handles.already_processed_spectra(handles.num_chos_spec)=2;
  handles.differentions=differentions_orig;
  handles.indices_for_differentions=indices_for_differentions;
  handles.spectrum_for_differentions=spectrum_for_differentions;
  handles.indices_modif=indices;
  handles.vlnocty_modif=vlnocty_modif;
  handles.spectrum_chosen_modif=spectrum;
  handles.indices_modif_int=indices_modif_int;
  
  handles.spectrum_chosen_modif_recent{handles.num_chos_spec}=spectrum;
  handles.vlnocty_modif_recent{handles.num_chos_spec}=vlnocty_modif;
  handles.differentions_recent{handles.num_chos_spec}=differentions_orig;
  handles.spectrum_for_differentions_recent{handles.num_chos_spec}=...
      spectrum_for_differentions;
  handles.indices_for_differentions_recent{handles.num_chos_spec}=...
      indices_for_differentions;
  
  handles.already_saved(handles.num_chos_spec)=0;
  set(handles.save_pushbutton,'Enable','on','BackgroundColor','red',...
      'TooltipString',...
      'You haven''t saved your changes in this spectrum yet');
  set(handles.slave_popupmenu,'String',{'Original spectrum',...
      'Current spectrum','Diference spectrum',...
      'Spectrum with polynomial fit','Spectrum with repaired points',...
      'Repaired spectrum'},'Value',4)
  evrything_enable_disable(hObject, eventdata, handles, 'on')
  set(handles.metoda_popupmenu,'Enable','on');
  set(handles.spikedel_popupmenu,'Enable','on');
  set(handles.makedel_pushbutton,'Enable','on');
  set(handles.save_file_pushbutton,'Enable',enable_save_file_pushbutton);
  slave_popupmenu_Callback(hObject, eventdata, handles);
  if max_iter_reached_indicator
   errordlg_message=['Algorithm was terminatetd, because it reached ',...
       sprintf('maximum number of iterations (%d). ',handles.maxiter),...
       'It can be changed in file spikie.ini by setting value ',...
       'maxiter. If this file don''t exist, you must ',...
       'create it in the same directory, where spikie is. Also, if ',...
       'the maxiter entry misses, you must create it. ',...
       'For example you can add to ''spikie.ini'' line: maxiter=1000. ',...
       'For comments use ''%''.'];
   h_errordlg=errordlg(errordlg_message,'Reached maximum number of ',...
       'iteration');
   waitfor(h_errordlg);
  end;
end
guidata(hObject, handles)

function degree_poly_buttongroup_SelectionChangeFcn(hObject, eventdata)
handles=guidata(hObject);
switch get(eventdata.NewValue,'Tag')
 case 'poly_0_radiobutton'
  handles.poly_fit_degree=0;
 case 'poly_1_radiobutton'
  handles.poly_fit_degree=1;
 case 'poly_2_radiobutton'
  handles.poly_fit_degree=2;
 case 'poly_3_radiobutton'
  handles.poly_fit_degree=3;
end
guidata(hObject, handles)

function closedlg(str,event)
selection = questdlg('Are you sure to close?','Closing GUI','Yes','No','Yes');
switch selection,
   case 'Yes',
    handles.output=5;
    delete(gcf)
   case 'No'
     return
end

function fited_points_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fited_points_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fited_points_edit as text
%        str2double(get(hObject,'String')) returns contents of fited_points_edit as a double
[fited_points,status]=str2num(get(hObject,'String'));
if ~status || fited_points<0 || fited_points~=round(fited_points) 
 set(handles.fited_points_edit,'String',num2str(...
     handles.fited_points_for_edit),'BackgroundColor','red');
else
 set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);
 handles.fited_points_for_edit=fited_points;
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function fited_points_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fited_points_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_file_pushbutton.
function save_file_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_file_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.mode_FA==2
 W=diag(handles.W);
 data_saved=handles.data_saved*W*handles.V';
else
 data_saved=handles.data_saved;
end
adresar=save_spektra([handles.kmen_nazev,'_kor'],handles.vlnocty,...
    data_saved,1,'Where to save corrected spectra',...
    handles.current_directory,'',1,'Saving data','Type of data','txt',...
    handles.digits);
if ~isequal(adresar,0)
 handles.current_directory=adresar; % Aktualni adresar (viz "opening callback")
 set(handles.save_file_pushbutton,'Enable','off');
end
guidata(hObject, handles)


% --- Executes on button press in chosen_spec_text.
function chosen_spec_text_Callback(hObject, eventdata, handles)
% hObject    handle to chosen_spec_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in mode_display_pushbutton.
function mode_display_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to mode_display_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function chose_spec_handles_set(hObject, eventdata, handles, num_chos_spec)
handles.num_chos_spec=num_chos_spec;
handles.differentions=handles.differentions_recent{num_chos_spec};
handles.spectrum_for_differentions=...
    handles.spectrum_for_differentions_recent{num_chos_spec};
handles.indices_for_differentions=...
    handles.indices_for_differentions_recent{num_chos_spec};
handles.spectrum_chosen_modif=...
    handles.spectrum_chosen_modif_recent{num_chos_spec};
handles.vlnocty_modif=handles.vlnocty_modif_recent{num_chos_spec};
handles.spectrum_chosen=handles.data_saved(:,num_chos_spec);
handles.spectrum_chosen_orig=handles.data_orig(:,num_chos_spec);
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);
switch handles.mode
 case 1
  if handles.already_saved(num_chos_spec)
   set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
      handles.defaultBackground,'TooltipString','Will save the data');
  else
   set(handles.save_pushbutton,'Enable','on','BackgroundColor','red',...
       'TooltipString',...
       'You haven''t saved your changes in this spectrum yet');
  end;
  if handles.already_processed_spectra(num_chos_spec)
   set(handles.metoda_popupmenu,'String',handles.possible_method,...
       'Value',1);
   set(handles.method_text,'Visible','on');
   set(handles.spikefind_panel,'Visible','on','Title',...
       'Spikefinding panel:');
   set(handles.make_pushbutton,'Visible','on','Enable','on');
   set(handles.metoda_popupmenu,'Visible','on','Enable','on');
   set(handles.points_text,'Visible','on');
   set(handles.degree_text,'Visible','on');
   set(handles.points_edit,'Visible','on');
   set(handles.degree_edit,'Visible','on');
   set(handles.treshold_text,'Visible','on');
   set(handles.treshold_edit,'Visible','on');
   set(handles.probability_text,'Visible','on');
   set(handles.probability_display_text,'Visible','on');
   set(handles.spikedel_panel,'Visible','on')
   handles.indices_modif=...
       handles.indices_modif_recent{num_chos_spec};
   handles.indices_modif_int=...
       handles.indices_modif_int_recent{num_chos_spec};
  else
   handles.smoothed=0;
   set(handles.metoda_popupmenu,'String',[{'Select the method'},...
       handles.possible_method],'Value',1);
   set(handles.method_text,'Visible','on');
   set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
      handles.defaultBackground,'TooltipString','Will save the data');
   set(handles.spikefind_panel,'Visible','off','Title',...
       'Spikefinding panel:');
   set(handles.make_pushbutton,'Visible','off','Enable','off');
   set(handles.metoda_popupmenu,'Visible','on','Enable','on');
   set(handles.points_text,'Visible','off');
   set(handles.degree_text,'Visible','off');
   set(handles.points_edit,'Visible','off');
   set(handles.degree_edit,'Visible','off');
   set(handles.treshold_text,'Visible','off');
   set(handles.treshold_edit,'Visible','off');
   set(handles.probability_text,'Visible','off');
   set(handles.probability_display_text,'Visible','off');
   set(handles.spikedel_panel,'Visible','off')
  end
  switch handles.already_processed_spectra(num_chos_spec)
   case 0
    set(handles.slave_popupmenu,'Enable','off','Value',1)
    choose_interval_pushbutton_plot(hObject, eventdata, handles)
   case 1       
    set(handles.slave_popupmenu,'Enable','on','String',...
        {'Original spectrum','Current spectrum','Diference spectrum'});
    if get(handles.slave_popupmenu,'Value')>3
     set(handles.slave_popupmenu,'Value',2)
    end
    slave_popupmenu_Callback(hObject, eventdata, handles);
   case 2
    set(handles.slave_popupmenu,'Enable','on','String',...
        {'Original spectrum','Current spectrum','Difference spectrum',...
        'Spectrum with polynomial fit','Spectrum with repaired points',...
        'Repaired spectrum'})
    slave_popupmenu_Callback(hObject, eventdata, handles);
  end
 case 2
  if isempty(find(handles.chosen_spectra==num_chos_spec,1))
   set(handles.unselect_pushbutton,'Enable','off')
  else
   set(handles.unselect_pushbutton,'Enable','on')
  end
  if handles.already_processed_spectra(num_chos_spec)
   set(handles.slave_popupmenu,'Enable','on','String',...
        {'Original spectrum','Current spectrum','Difference spectrum',...
        'Spectrum with polynomial fit','Spectrum with repaired points',...
        'Repaired spectrum'})
   slave_popupmenu_Callback(hObject, eventdata, handles);
  else
   set(handles.slave_popupmenu,'Enable','off','Value',1)
   choose_interval_pushbutton_plot(hObject, eventdata, handles)
  end
end
guidata(hObject, handles); 


% --- Executes on button press in choose_interval_pushbutton.
function choose_interval_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to choose_interval_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.treshold_edit,'BackgroundColor',[1,1,1]);
set(handles.points_edit,'BackgroundColor',[1,1,1]);
set(handles.degree_edit,'BackgroundColor',[1,1,1]);
set(handles.del_points_edit,'BackgroundColor',[1,1,1]);
set(handles.fited_points_edit,'BackgroundColor',[1,1,1]);
vlnocty=handles.vlnocty;
prompt = {[sprintf('                Select intervals of wavenumbers:\n'),...
     sprintf('      (for example, if you want use union of intervals\n'),...
     sprintf('(1,100) and (450,1000), you must type 1,100,450,1000 \n'),...
     sprintf('             your spectrum is in interval (%d:%d))\n',...
     floor(vlnocty(1)),...
     ceil(vlnocty(end)))]};
dlg_title_matrix = 'Selection of interval';
num_lines = 1;
options.Resize='on';
defAns=[num2str(handles.vlnocty(handles.chosen_interval_ind{1}(1))),',',...
    num2str(handles.vlnocty(handles.chosen_interval_ind{1}(end)))];
for ii=2:length(handles.chosen_interval_ind)
 defAns=[defAns,',',num2str(handles.vlnocty(handles.chosen_interval_ind{ii}(1))),',',...
    num2str(handles.vlnocty(handles.chosen_interval_ind{ii}(end)))];
end
odpoved_chosen_interval = inputdlg(prompt,dlg_title_matrix,num_lines,{defAns},options);
%--------------------------------------------------------------------------
% Testovani, zda nebylo stisknuto cancel
%--------------------------------------------------------------------------
if ~isequal(odpoved_chosen_interval,{})
 [chosen_interval,status]=str2num(odpoved_chosen_interval{1});
 l=length(chosen_interval);
 if status==0 || round(l/2)~=l/2
 % Nepripustne hodnoty
  h_errordlg=errordlg('You don''t typed interval','Incorret input','on');
  waitfor(h_errordlg);
 else % Pripustne hodnoty mezi matice se ulozi do globalnich promennych
  handles.already_saved=ones(1,handles.pocet_spekter); % indikator ulozeni
  % dat pro jednotliva spektra
  handles.already_batch_saved=1; % indikator ulozeni dat v modu batch
   chosen_interval_ind=cell(1,l/2);
%   chosen_interval_ind={};
%   chosen_interval_ind{1}=[];
  for ii=2:2:l
   dolind=find(vlnocty>=chosen_interval(ii-1), 1 );
   horind=find(vlnocty<=chosen_interval(ii), 1, 'last' );
   chosen_interval_ind{ii/2}=dolind:horind;
   if isempty(chosen_interval_ind{ii/2})
    % Nepripustne hodnoty
    h_errordlg=errordlg('You didn''t type interval','Incorret input','on');
    waitfor(h_errordlg);
    return
   end
  end
  handles.chosen_interval_ind=chosen_interval_ind;    
  switch handles.mode
   case 1
    handles.smoothed=0;
    set(handles.metoda_popupmenu,'String',[{'Select the method'},...
        handles.possible_method],'Value',1);
    set(handles.method_text,'Visible','on');
    set(handles.save_pushbutton,'Enable','off','BackgroundColor',...
       handles.defaultBackground,'TooltipString','Will save the data');
    set(handles.spikefind_panel,'Visible','off','Title',...
        'Spikefinding panel:');
    set(handles.make_pushbutton,'Visible','off','Enable','off');
    set(handles.metoda_popupmenu,'Visible','on','Enable','on');
    set(handles.points_text,'Visible','off');
    set(handles.degree_text,'Visible','off');
    set(handles.points_edit,'Visible','off');
    set(handles.degree_edit,'Visible','off');
    set(handles.treshold_text,'Visible','off');
    set(handles.treshold_edit,'Visible','off');
    set(handles.probability_text,'Visible','off');
    set(handles.probability_display_text,'Visible','off');
    set(handles.spikedel_panel,'Visible','off');
%   switch handles.make_pushbutton_indicator(handles.num_chos_spec)
%    case 0
%     choose_interval_pushbutton_plot(hObject, eventdata, handles)
%    case 1
%     slave_popupmenu_Callback(hObject, eventdata, handles);
%   end
  end
  set(handles.slave_popupmenu,'Enable','off','Value',1);
  choose_interval_pushbutton_plot(hObject, eventdata, handles);
 end
end
guidata(hObject, handles);

function choose_interval_pushbutton_plot(hObject, eventdata, handles)
handles.plotting_function='choose_interval_pushbutton_plot';
axes(handles.main_axes);
hold off
plot(handles.vlnocty,handles.spectrum_chosen_orig,'color',[.7,.7,.7]);
hold on
for ii=1:length(handles.chosen_interval_ind)
plot(handles.vlnocty(handles.chosen_interval_ind{ii}),...
    handles.spectrum_chosen_orig(handles.chosen_interval_ind{ii}),'b');
end
for ii=1:length(handles.already_processed_points_ind{handles.num_chos_spec})
   plot(handles.vlnocty(...
       handles.already_processed_points_ind{handles.num_chos_spec}{ii}),...
       handles.spectrum_chosen_orig(...
       handles.already_processed_points_ind{handles.num_chos_spec}{ii}),...
       'xr','linewidth',2,'MarkerSize',10);
end
hold off
meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
x_min=meze(1);
x_max=meze(2);
y_min=meze(3);
y_max=meze(4);
axis(gca,[x_min,x_max,y_min,y_max]);
guidata(hObject, handles);


% --- Executes on button press in probability_display_text.
function probability_display_text_Callback(hObject, eventdata, handles)
% hObject    handle to probability_display_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in auto_zoom_pushbutton.
function auto_zoom_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to auto_zoom_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.manual_axes_indicator(handles.num_chos_spec,...
    get(handles.slave_popupmenu,'Value'))=0;
axes(handles.main_axes);
switch handles.plotting_function
 case 'load_pushbutton'
  meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
  x_min=meze(1);
  x_max=meze(2);
  y_min=meze(3);
  y_max=meze(4);
  axis(gca,[x_min,x_max,y_min,y_max]);
 case 'choose_interval_pushbutton_plot'
  meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
  x_min=meze(1);
  x_max=meze(2);
  y_min=meze(3);
  y_max=meze(4);
  axis(gca,[x_min,x_max,y_min,y_max]);
 case 'slave_popupmenu'
  slave_popupmenu_Callbeck
end
guidata(hObject, handles);


% --- Executes on button press in horizontal_zoom_pushbutton.
function horizontal_zoom_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to horizontal_zoom_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.main_axes);
used_spectrum=get(handles.slave_popupmenu,'Value');
if handles.manual_axes_indicator(handles.num_chos_spec,used_spectrum)
 switch handles.plotting_function
  case 'load_pushbutton'
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
   x_min=meze(1);
   x_max=meze(2);
   y_limits=get(gca,'YLim');
   axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
  case 'choose_interval_pushbutton_plot'
   meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
   x_min=meze(1);
   x_max=meze(2);
   y_limits=get(gca,'YLim');
   axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
  case 'slave_popupmenu'
   switch used_spectrum
    case 1
     meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
     x_min=meze(1);
     x_max=meze(2);
     y_limits=get(gca,'YLim');
     axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
    case 2
     meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
     x_min=meze(1);
     x_max=meze(2);
     y_limits=get(gca,'YLim');
     axis(gca,[x_min,x_max,y_limits,y_limits]);
    case 3
     adjust_differentions=zeros(length(handles.vlnocty),1);
     adjust_differentions(1:length(handles.differentions))=...
         handles.differentions;
     meze=spikie_axes_adjust([handles.vlnocty,adjust_differentions]);
     x_min=meze(1);
     x_max=meze(2);
     y_limits=get(gca,'YLim');
     axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
    case 4
     meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
     x_min=meze(1);
     x_max=meze(2);
     y_limits=get(gca,'YLim');
     axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
    case 5
     meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen]);
     x_min=meze(1);
     x_max=meze(2);
     y_limits=get(gca,'YLim');
     axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
    case 6
     meze=spikie_axes_adjust([handles.vlnocty,handles.spectrum_chosen_orig]);
     x_min=meze(1);
     x_max=meze(2);
     y_limits=get(gca,'YLim');
     axis(gca,[x_min,x_max,y_limits(1),y_limits(2)]);
   end
 end
end
guidata(hObject, handles);

% --- Executes on button press in vertical_zoom_pushbutton.
function vertical_zoom_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to vertical_zoom_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
used_spectrum=get(handles.slave_popupmenu,'Value');
axes(handles.main_axes);
if handles.manual_axes_indicator(handles.num_chos_spec,used_spectrum)
 switch handles.plotting_function
  case 'load_pushbutton'
   x_limits=get(gca,'XLim');
   x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
   x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
   meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
       handles.spectrum_chosen_orig(x_min_ind:x_max_ind)]);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
  case 'choose_interval_pushbutton_plot'
   x_limits=get(gca,'YLim');
   x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
   x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
   meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
       handles.spectrum_chosen_orig(x_min_ind:x_max_ind)]);
   y_min=meze(3);
   y_max=meze(4);
   axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
  case 'slave_popupmenu'
   switch used_spectrum
    case 1
     x_limits=get(gca,'YLim');
     x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
     x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
     meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
         handles.spectrum_chosen_orig(x_min_ind:x_max_ind)]);
     y_min=meze(3);
     y_max=meze(4);
     axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
    case 2
     x_limits=get(gca,'YLim');
     x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
     x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
     meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
         handles.spectrum_chosen(x_min_ind:x_max_ind)]);
     y_min=meze(3);
     y_max=meze(4);
     axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
    case 3
     adjust_differentions=zeros(length(handles.vlnocty),1);
     adjust_differentions(1:length(handles.differentions))=...
         handles.differentions;
     x_limits=get(gca,'YLim');
     x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
     x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
     meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
         adjust_differentions(x_min_ind:x_max_ind)]);
     y_min=meze(3);
     y_max=meze(4);
     axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
    case 4
     x_limits=get(gca,'YLim');
     x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
     x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
     meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
         handles.spectrum_chosen(x_min_ind:x_max_ind)]);
     y_min=meze(3);
     y_max=meze(4);
     axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
    case 5
     x_limits=get(gca,'YLim');
     x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
     x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
     meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
         handles.spectrum_chosen(x_min_ind:x_max_ind)]);
     y_min=meze(3);
     y_max=meze(4);
     axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
    case 6
     x_limits=get(gca,'YLim');
     x_min_ind=find(handles.vlnocty>=x_limits(1), 1 );
     x_max_ind=find(handles.vlnocty<=x_limits(2), 1, 'last' );
     meze=spikie_axes_adjust([handles.vlnocty(x_min_ind:x_max_ind),...
         handles.spectrum_chosen_orig(x_min_ind:x_max_ind)]);
     y_min=meze(3);
     y_max=meze(4);
     axis(gca,[x_limits(1),x_limits(2),y_min,y_max]);
   end
 end
end
guidata(hObject, handles);

% --- Executes on button press in manual_zoom_pushbutton.
function manual_zoom_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to manual_zoom_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
used_spectrum=get(handles.slave_popupmenu,'Value');
axes(handles.main_axes);
x_limits=get(gca,'XLim');
y_limits=get(gca,'YLim');
[status,x_min,x_max,y_min,y_max]=...
    spikie_axes_limits(x_limits(1),x_limits(2),y_limits(1),y_limits(2));
if status
 axis(gca,[x_min,x_max,y_min,y_max]);
 handles.manual_axes_limits(handles.num_chos_spec,4*used_spectrum-3:...
     4*used_spectrum)=[x_min,x_max,y_min,y_max];
 handles.manual_axes_indicator(handles.num_chos_spec,used_spectrum)=1;
end
guidata(hObject, handles);

% --- Executes on button press in interactive_zoom_pushbutton.
function interactive_zoom_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to interactive_zoom_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.main_axes);
used_spectrum=get(handles.slave_popupmenu,'Value');
zoom_handle=zoom(gca);
zoom reset
if handles.interactive_zoom_indicator
 set(zoom_handle, 'Enable', 'off');
 handles.interactive_zoom_indicator=0;
else
 set(zoom_handle, 'Enable', 'on');
 handles.interactive_zoom_indicator=1;
end
set(zoom_handle, 'RightClickAction', 'InverseZoom',...
    'ActionPostCallback',{@main_axes_zoom_ActionPostCallbec,handles});
guidata(hObject, handles);

% --- Executes on button press in invert_pushbutton.
function invert_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to invert_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num_chos_spec=handles.num_chos_spec;
handles.data_orig(:,num_chos_spec)=...
    -handles.data_orig(:,num_chos_spec);
if handles.mode_FA==2
 handles.V(:,num_chos_spec)=-handles.V(:,num_chos_spec);
end
handles.data_new(:,num_chos_spec)=...
    -handles.data_new(:,num_chos_spec);
handles.data_saved(:,num_chos_spec)=...
    -handles.data_saved(:,num_chos_spec);
handles.spectrum_chosen=handles.data_saved(:,num_chos_spec);
handles.spectrum_chosen_orig=handles.data_orig(:,num_chos_spec);
handles.already_processed_spectra(num_chos_spec)=0;
handles.already_processed_points_ind{num_chos_spec}={}; % cell
% array obsahujici upravene body
handles.already_processed_points_ind{num_chos_spec}{1}=[];
handles.now_processed_points_ind{num_chos_spec}={}; % cell array
% obsahujici upravene, ale jeste neulozene body
handles.now_processed_points_ind{num_chos_spec}{1}=[];
handles.fited_points{num_chos_spec}={};
handles.fited_points{num_chos_spec}{1}=[];
handles.new_points{num_chos_spec}={};
handles.new_points{num_chos_spec}{1}=[];
handles.new_points_ind{num_chos_spec}={};
handles.new_points_ind{num_chos_spec}{1}=[];
handles.spectrum_chosen_modif_recent{num_chos_spec}={};
handles.vlnocty_modif_recent{num_chos_spec}={};
   
handles.make_pushbutton_indicator(num_chos_spec)=0;
% nastaveni indikatoru provedeni SavGol filtru pro potreby vykresleni
% grafu po zmacknuti tlacitka choose interval
handles.indices_modif_recent{num_chos_spec}=[]; % Prealokace
% pole obsahujiciho pro kazde spektrum vektor, ve kterem jsou
% ulozeny indexy mezi intervalu vlnoctu - vzdy dvojice po sobe
% nasledujicich cisel uvadi dolni a horni mez - na kterych je spektrum
% vyhlazene SavGol filtrem. Je to potreba z toho duvodu, ze SavGol filtr
% nevyhlazuje od kraje pouziteho intervalu, ale o pul hodnoty Points
% dale, kdyz jsou vsak vybrane poditervaly, na kterych se pracuje, tak
% program vyhladi co nejvice bodu z intervalu i za cenu toho, ze sahne do
% jeste neupraveneho intervalu
handles.indices_modif_int_recent{num_chos_spec}=[];
% Prealokace pole, obsahujiciho pro kazde spektrum vektor obsahujici
% indexy vsech pouzitych vlnoctu pro SavGol. Duvod pro zavedeni toho
% vektoru krome duvodu zminenych u handles.indices_modif_recent je
% zrychleni programu, aby se pro pouziti vykreslovani grafu nemusely tato
% cisla pokazde pocitat zvlast
handles.already_saved(num_chos_spec)=1; % indikator ulozeni
% dat pro jednotliva spektra
handles.differentions_recent{num_chos_spec}=[];
handles.spectrum_for_differentions_recent{num_chos_spec}=[];
handles.indices_for_differentions_recent{num_chos_spec}=[];
chose_spec_handles_set(hObject, eventdata, handles, num_chos_spec);
handles=guidata(hObject);
guidata(hObject,handles);

function main_axes_zoom_ActionPostCallbec(hObject, eventdata, handles)
used_spectrum=get(handles.slave_popupmenu,'Value');
x_limits=get(gca,'XLim');
y_limits=get(gca,'YLim');
handles.manual_axes_limits(handles.num_chos_spec,4*used_spectrum-3:...
    4*used_spectrum)=[x_limits(1),x_limits(2),y_limits(1),y_limits(2)];
handles.manual_axes_indicator(handles.num_chos_spec,used_spectrum)=1;
guidata(hObject,handles)

function evrything_enable_disable(hObject, eventdata, handles, what)
set(handles.make_pushbutton,'Enable',what);
set(handles.save_pushbutton,'Enable',what);
set(handles.save_file_pushbutton,'Enable',what);
set(handles.load_pushbutton,'Enable',what);
set(handles.choose_interval_pushbutton,'Enable',what);
set(handles.mode_pushbutton,'Enable',what);
set(handles.chose_spec_pushbutton,'Enable',what);
set(handles.up_pushbutton,'Enable',what);
set(handles.down_pushbutton,'Enable',what);
set(handles.auto_zoom_pushbutton,'Enable',what);
set(handles.horizontal_zoom_pushbutton,'Enable',what);
set(handles.vertical_zoom_pushbutton,'Enable',what);
set(handles.manual_zoom_pushbutton,'Enable',what);
set(handles.interactive_zoom_pushbutton,'Enable',what);
set(handles.invert_pushbutton,'Enable',what);
set(handles.points_edit,'Enable',what);
set(handles.degree_edit,'Enable',what);
set(handles.treshold_edit,'Enable',what);
set(handles.del_points_edit,'Enable',what);
set(handles.fited_points_edit,'Enable',what);
set(handles.slave_popupmenu,'Enable',what);
set(handles.poly_0_radiobutton,'Enable',what);
set(handles.poly_1_radiobutton,'Enable',what);
set(handles.poly_2_radiobutton,'Enable',what);
set(handles.poly_3_radiobutton,'Enable',what);

%set(handles.op_mode_panel,'Visible',what);

% set(handles.zoom_panel,'Visible',what);
% set(handles.spikefind_panel,'Visible',what);
% set(handles.spikedel_panel,'Visible',what);
guidata(hObject, handles);


% --- Executes on button press in unselect_pushbutton.
function unselect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to unselect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind=find(handles.chosen_spectra==handles.num_chos_spec);
l_chosen_spectra=length(handles.chosen_spectra);
if l_chosen_spectra==1
 h_warndlg=warndlg(['This is last selected spectrum. You can''t ',...
     'unselect it']);
 waitfor(h_warndlg);
elseif ind==1
 handles.chosen_spectra=handles.chosen_spectra(ind+1:end);
 set(handles.unselect_pushbutton,'Enable','off')
elseif ind==l_chosen_spectra
 handles.chosen_spectra=handles.chosen_spectra(1:ind-1);
 set(handles.unselect_pushbutton,'Enable','off')
else
 handles.chosen_spectra=[handles.chosen_spectra(1:ind-1),...
     handles.chosen_spectra(ind+1:end)];
 set(handles.unselect_pushbutton,'Enable','off')
end
guidata(hObject, handles);


% --- Executes on button press in mode_FA_pushbutton.
function mode_FA_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to mode_FA_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

draw_FA_dlg=questdlg(['How do you want to draw results of factor ',...
    'analysis'],...
 '','sub. vs. coeff.','sing. val. + res. err.','cancel','cancel');
if ~isequal(draw_FA_dlg,'') 
 switch draw_FA_dlg
  case 'sub. vs. coeff.'
   spikie_FA_results(handles.digits,handles.kmen_nazev,3,...
       handles.vlnocty,{handles.data_saved},2,2,1:handles.pocet_spekter,...
       1,handles.V);
  case 'sing. val. + res. err.'
   spikie_singV_resE(1,handles.W,handles.E); 
  case 'cancel'
   
 end
end
