function [maxiter,digits]=spikie_load_parameters(hObject, eventdata, handles)
maxiter=handles.maxiter;
digits=handles.digits;
ii=1;
try
 file=fopen(handles.inifilename);
 line=fgets(file);
 while line~=-1
  if strfind(line,'%')
   k=strfind(line,'%');
   line=line(1:k-1);
  end
  if ~isempty(strfind(line,'maxiter'))
   ind=find(line=='=');
   [maxiterin,status]=str2num(line(ind+1:end));
   if status && length(maxiterin)==1 && round(maxiterin)==maxiterin
    maxiter=maxiterin;
   end
  end
  if ~isempty(strfind(line,'digits'))
   ind=find(line=='=');
   [digitsin,status]=str2num(line(ind+1:end));
   if status && length(digitsin)==1 && round(digitsin)==digitsin
    if digitsin>16
     digits=16;
    else
     digits=digitsin;
    end
   end
  end
  ii=ii+1;
  if ii>1e3
   break
  end
  line=fgets(file);
 end
 fclose(file);
end