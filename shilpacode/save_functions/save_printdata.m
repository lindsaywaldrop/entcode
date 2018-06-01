function save_printdata()
%function save_printdata.m 
%input:  
%output: 
%saves printing information data

global run_id pcount list_print_times t_steps print_time

%the default extension is .mat
filename = ['postprocessing/initdata_',run_id];
save (filename, 'pcount', 'list_print_times','t_steps','print_time','-append');
