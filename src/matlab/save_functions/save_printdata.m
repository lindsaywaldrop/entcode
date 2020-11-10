function save_printdata()
%function save_printdata.m 
%input:  
%output: 
%saves printing information data

global run_id pcount list_print_times t_steps print_time pathbase_results

%the default extension is .mat
filename = [pathbase_results,'initdata_',run_id];
save (filename, 'pcount', 'list_print_times','t_steps','print_time','-append');