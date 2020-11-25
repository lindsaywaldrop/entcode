function save_printdata(paths, parameters, simulation)
%function save_printdata.m 
%input:  
%output: 
%saves printing information data

%global run_id pcount list_print_times t_steps print_time pathbase_results

%the default extension is .mat
filename = [paths.pathbase_results, 'simdata_', parameters.run_id];
save (filename, 'simulation.pcount', 'simulation.list_print_times','simulation.t_steps',...
		'simulation.print_time');
