function [new_points,new_points_ind,fited_points,spectrum]=spikie_find_to_delete(ind,...
    del_around,half_fited_points,degree_fit,vlnocty,spectrum)
%new_points=spikie_find_to_delete(spectrum,ind,spectrum)
%Tato funkce hleda intervaly ulozene v cellarray to_delete,
%kde kazda polozka obsahuje [min,max] meze intervalu, ktery obklopuje
%spike obsahujici body s indexy ind. Celkova velikost spektra je
%length_spectrum.

lind=length(ind);
l=length(spectrum);
to_delete={};
to_delete{1}=[];
new_points=[];
new_points_ind={};
new_points_ind{1}=[];
fited_points=[];
if ~isempty(ind)
 if lind==1
  if ind-del_around<1
    down=1;
  else
    down=ind-del_around;
  end
  if ind+del_around>l
    up=l;
  else
    up=ind+del_around;
  end
  to_delete{1}=[down,up];
 else
  pp=0;
  indicator=0;
  for ii=1:lind-1
   if indicator==0
    if ind(ii)-del_around<1
      down=1;
    else
      down=ind(ii)-del_around;
    end
   end
   if ind(ii+1)-ind(ii)<=2*del_around+1
    indicator=1;
   else
    pp=pp+1;
    indicator=0;
    if ind(ii)+del_around>l
      up=l;
    else
      up=ind(ii)+del_around;
    end
    to_delete{pp}=[down,up]; 
   end
  end
  if indicator~=1
   if ind(lind)-del_around<1
    down=1;
   else
   down=ind(lind)-del_around;
   end
  end
  if ind(lind)+del_around>l
   up=l;
  else
   up=ind(lind)+del_around;
  end
  pp=pp+1;
  to_delete{pp}=[down,up];
 end
 
%%%%%%%%%%%%%
%fitovani
%%%%%%%%%%%%
  l_to_delete=length(to_delete);
  down=vlnocty(end);
  to_delete_int=to_delete{1};
  if to_delete_int(2)==1 && l_to_delete==1
   %pripad, kdy je spike hned zpocatku spektra
   if to_delete_int(2)+half_fited_points>l
    up=l;
   else
    up=to_delete_int(2)-half_fited_points;
   end
   fitint{1}=[to_delete_int(2)+1:up];
  elseif to_delete_int(2)==l && l_to_delete==1
   %pripad, kdy je spike presne na konci spektra
   if to_delete_int(1)-half_fited_points<1
    down=1;
   else
    down=to_delete_int(1)-half_fited_points;
   end
   fitint{1}=[down:to_delete_int(1)-1];
  else
   %pripad, kdy neni spike ani pocatecnim ani konecnym bodem spektra
   if to_delete_int(1)-half_fited_points<1
    down=1;
   else
    down=to_delete_int(1)-half_fited_points;
   end
   if l_to_delete==1
    if to_delete_int(2)+half_fited_points>l
     up=l;
    else
     up=to_delete_int(2)+half_fited_points;
    end
   else
    if to_delete_int(2)<to_delete{2}(1)
     if to_delete_int(2)+half_fited_points>l 
      up=l;
     else
      up=to_delete_int(2)+half_fited_points;
     end
    end
   end    
   if l_to_delete==1
    fitint{1}=[down:to_delete_int(1)-1,to_delete_int(2)+1:up];
   end
  end
 if l_to_delete~=1
  pp=1;
  my_counter=1;
  for ii=2:1:l_to_delete
   to_delete_int=to_delete{ii-1};
   if to_delete{ii}(1)>to_delete_int(2)
    if to_delete_int(2)+half_fited_points>l 
      up=l;
    else
      up=to_delete_int(2)+half_fited_points;
    end
    fitint{my_counter}=[down:to_delete{pp}(1)-1,to_delete_int(2)+1:up];
    to_delete_int=to_delete{ii};
    if to_delete_int(1)-half_fited_points<1
     down=1;
    else
     down=to_delete_int(1)-half_fited_points;
    end
    pp=ii;
    my_counter=my_counter+1;
   end
  end
  to_delete_int=to_delete{end};
  if to_delete_int(2)+half_fited_points>l
   up=l;
  else
   up=to_delete_int(2)+half_fited_points;
  end
  fitint{my_counter}=[down:to_delete{pp}(1)-1,to_delete_int(2)+1:up];
 end
 %Posunuti fitovacich intervalu v pripade, ze protinaji nektery vedlejsi
 %spike
 for ii=1:length(fitint)
  fitint_test=fitint{ii};
  middle=(to_delete{ii}(1)+to_delete{ii}(2))/2;
  for jj=1:length(to_delete)
   my_intersect=intersect(fitint_test,to_delete{jj});
   if ~isempty(my_intersect)
    if my_intersect(1)<middle
     kk=find(fitint_test>to_delete{jj}(2), 1 );
     if to_delete{jj}(1)-kk+1<1
      fitint_test=[1:to_delete{jj}(1)-1,fitint_test(kk:end)];
     else
      fitint_test=[to_delete{jj}(1)-kk+1:to_delete{jj}(1)-1,fitint_test(kk:end)];
     end
     for ll=jj-1:-1:1
      my_intersect=intersect(fitint_test,to_delete{ll});
      if ~isempty(my_intersect)
       kk=find(fitint_test>to_delete{ll}(2), 1 );
       if to_delete{ll}(1)-kk+1<1
        fitint_test=[1:to_delete{ll}(1)-1,fitint_test(kk:end)];
       else
        fitint_test=[to_delete{ll}(1)-kk+1:to_delete{ll}(1)-1,fitint_test(kk:end)];
       end
      end
     end
    else
     kk=find(fitint_test<to_delete{jj}(1), 1, 'last' );
     if to_delete{jj}(2)+length(fitint_test)-kk>l
      fitint_test=[fitint_test(1:kk),to_delete{jj}(2)+1:l];
     else
      fitint_test=[fitint_test(1:kk),to_delete{jj}(2)+1:to_delete{jj}(2)+length(fitint_test)-kk];
     end
    end
   end
  end
  to_delete_int=to_delete{ii};
  middle=(vlnocty(fitint_test(1))+...
      vlnocty(fitint_test(end)))/2;
  polynome=polyfit(vlnocty(fitint_test)-middle,spectrum(fitint_test),degree_fit);
  new_points{ii}=[vlnocty(to_delete_int(1):to_delete_int(2)),...
      polyval(polynome,vlnocty((to_delete_int(1):...
      to_delete_int(2)))-middle)];
  new_points_ind{ii}=[to_delete_int(1):to_delete_int(2)];
  fited_points{ii}=[vlnocty(fitint_test(1):fitint_test(end)), polyval(polynome,vlnocty(fitint_test(1):fitint_test(end))-middle)];
  spectrum(to_delete_int(1):to_delete_int(2))=new_points{ii}(:,2);
 end
end