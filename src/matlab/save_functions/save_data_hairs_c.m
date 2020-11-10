function save_data_hairs_c(initial)
%function save_data_hairs_c.m 
%input: initial - if this is the first time data is being saved 
%output: 
%saves hairs_c data

global run_id pcount pathbase_results
global ptindex_hairs hairs_c hairs_center


T = evalc(['hairs_c_' num2str(pcount) ' = hairs_c']);

%the default extension is .mat
filename = [pathbase_results,'hairs_c_',run_id];

if (initial == 1) %if this is the first time saving then create the file
  save(filename, 'hairs_c_*','ptindex_hairs','hairs_center');
elseif (initial == 0) %if not the first time then append to the file
   save(filename, 'hairs_c_*', '-append');
end