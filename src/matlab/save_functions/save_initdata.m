function save_initdata(paths, parameters, simulation)
%function save_initdata.m 
%input: 
%output: 
%saves fixed parameters/variables initially

%global pathbase_results run_id 
%global dx dy Nx Ny xlength ylength x y 
%global explicit_vel 
%global D
%global dt dt_flick t_final_flick 

%the default extension is .mat
filename = [paths.pathbase_results, 'initdata_', parameters.run_id, '.mat'];
save(filename, 'parameters');

filename = [paths.pathbase_results, 'simdata_', parameters.run_id, '.mat'];
save(filename, 'simulation');
