function my_union=spikie_union(first,second)
l_first=length(first);
l_second=length(second);

if l_first>1
 first_counter=zeros(1,l_first+1);
 for ii=2:l_first+1
   first_counter(ii)=first_counter(ii-1)+length(first{ii-1});
 end
 A=zeros(1,first_counter(end));
 for ii=1:l_first
  if first_counter(ii+1)-first_counter(ii)
   A(first_counter(ii)+1:first_counter(ii+1))=first{ii};
  end
 end
elseif l_first==1
 A=first{1};
else
 A=[];
end
if l_second>1
 second_counter=zeros(1,l_second+1);
 for ii=2:l_second+1
   second_counter(ii)=second_counter(ii-1)+length(second{ii-1});
 end
 B=zeros(1,second_counter(end));
 for ii=1:l_second
  if second_counter(ii+1)-second_counter(ii)
   B(second_counter(ii)+1:second_counter(ii+1))=second{ii};
  end
 end
elseif l_second==1
 B=second{1};
else
 B=[];
end
help_union=union(A,B);
my_counter=1;
for ii=1:length(help_union)-1
 if help_union(ii+1)-help_union(ii)>1
  my_counter=my_counter+1;
 end
end
my_union=cell(1,my_counter);
index_for_array=1;
bottom_index=1;
for ii=1:length(help_union)-1
 if help_union(ii+1)-help_union(ii)>1
  my_union{index_for_array}=help_union(bottom_index:ii);
  bottom_index=ii+1;
  index_for_array=index_for_array+1;
 end
end
my_union{end}=help_union(bottom_index:end);