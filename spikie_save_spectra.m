function adresar=spikie_save_spectra(filename,xscale,spectra,directory_query,...
directory_title,start_directory,user_directory,filetype_query,...
filetype_title,filetype_string,extension,pocet_cifer)
%--------------------------------------------------------------------------
% Ulozeni jedne sady spekter  
%--------------------------------------------------------------------------
% Syntaxe funkce: adresar=save_spektra(filename,xscale,spectra,
% directory_query,directory_title,start_directory,user_directory,
% filetype_query,filetype_title,filetype_string,extension) 
%--------------------------------------------------------------------------
% Vstupni parametry:
% filename -> jmeno souboru se sadou spekter
% xscale -> spolecna x-ova skala spekter (prvni sloupec datoveho souboru) 
% spectra -> intenzity spekter (druhy az posledni sloupec datoveho souboru)
% directory_query -> pro hodnotu 1 je dotaz na adresar pro ulozeni spekter, 
% pro ostatni hodnoty bez dotazu
% directory_title -> "title" dialogoveho okna pro vyber adresare
% start_directory -> vychozi adresar dialogoveho okna pro vyber adresare
% user_directory -> v pripade, ze neni adresar vybran pomoci dialog. okna
% (directory_query=0), pak je adresar pro ulozeni spekter specifikovan 
% pomoci retezce user_directory
% filetype_query -> pro hodnotu 1 je dotaz na typ souboru (binarni mat file
% nebo textovy soubor), pro ostatni hodnoty bez dotazu
% filetype_title -> "title" dialogoveho okna pro vyber typu souboru
% filetype_string -> otazka v dialog. okne pro vyber typu souboru
% extension -> extenze text. souboru (binarni soubory maji pouze extenzi mat)
% pocet_cifer -> pocet cifer za desetinnou teckou pro spektra
%--------------------------------------------------------------------------
% Vystupni parametry:
% adresar -> cesta kam se spektra ulozi. Pokud pri vyberu adresare pomoci
% dialog. okna (directory_query=1) doslo k chybe (stisknuti cancel), tak se
% spektra neulozi a promenna adresar nabyva numericke hodnoty 0
%--------------------------------------------------------------------------
% Poznamka: Retezce v directory_title a start_directory se ignoruji pro
% directory_query=0 (staci zadat prazdne retezce). V tomto pripade musi 
% uzivatel zadat user_directory. Analogicky se ignoruji retezce
% filetype_title a filetype_string pro filetype_query=0 (spektra se ulozi
% jako text. soubor) 

format_specifikace=['%' num2str(9+pocet_cifer) '.' num2str(pocet_cifer),'E '];

if directory_query % Vyber adresare pro ulozeni spekter pomoci dialog. okna  
 adresar = uigetdir(start_directory,directory_title);
else
 adresar=user_directory; % Adresar pro ulozeni spekter specifikuje uzivatel    
end
if directory_query==0 || (directory_query && ~isequal(adresar,0))%Testovani
 % zda nedoslo ke stisku cancel pri vyberu adresare pomoci dialog. okna
 if filetype_query % Vyber typu souboru pomoci dialog. okna 
  save_type = questdlg(filetype_string,filetype_title,'MAT','TEXT','MAT');
 else
  save_type='TEXT'; % Soubor, ktery se nevybira pomoci dialog. okna, se
  % ulozi jako textovy
 end
 switch save_type
  %------------------------------------------------------------------------   
  case 'TEXT' % Ulozeni spekter jako textovy soubor
  %------------------------------------------------------------------------    
   spec_spectra=fullfile(adresar,strcat(filename,'.',extension)); % soubor
   % i s cestou pro ulozeni a extenzi definovanou uzivatelem ("txt","data",
   %...atd)
   pocet_bodu=size(spectra,1); % pocet bodu v kazdem spektru
   pocet_spekter=size(spectra,2); % pocet spekter
   fid_spectra = fopen(spec_spectra,'wt');
   for m=1:1:pocet_bodu % Cyklus pres vsechny vlnocty 
    fprintf(fid_spectra, '%-8.4f ', xscale(m)); % Vlnocty (1. sloupec) 
    for n=1:1:pocet_spekter  % Hodnoty pro dany vlnocet pro vsechna spektra   
     fprintf(fid_spectra,format_specifikace, spectra(m,n));
    end
    fprintf(fid_spectra,'\n'); 
   end
   state_spectra=fclose(fid_spectra);
   if (state_spectra == -1)
    error('nemuzu uzavrit soubor')
   end
  %------------------------------------------------------------------------ 
  case 'MAT' % Ulozeni spekter jako binarni soubor mat
   %-----------------------------------------------------------------------
   spec_spectra=fullfile(adresar,strcat(filename,'.mat')); % soubor i 
   % s cestou pro ulozeni
   data=[xscale spectra]; % spektra=vlnocty + intenzity 
   save(spec_spectra,'data');
  otherwise
   adresar=0; % spektra se neulozí    
 end
end % if (testovani, zda nedoslo ke stisku cancel)

 