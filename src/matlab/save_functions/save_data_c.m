function save_data_c(initial)
%function save_data_c.m 
%input: initial - if this is the first time data is being saved 
%output: 
%saves c data

global run_id pcount pathbase_results
global c


T = evalc(['c_' num2str(pcount) ' = c']);

%the default extension is .mat
filename = [pathbase_results,'c_',run_id];

if (initial == 1) %if this is the first time saving then create the file
  save(filename, 'c_*');
elseif (initial == 0) %if not the first time then append to the file
   save(filename, 'c_*', '-append');
end


