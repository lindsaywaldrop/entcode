function save_initdata()
%function save_initdata.m 
%input: 
%output: 
%saves fixed parameters/variables initially

global pathbase_results run_id 
global dx dy Nx Ny xlength ylength x y 
global explicit_vel 
global D
global dt dt_flick t_final_flick 

%the default extension is .mat
filename = [pathbase_results,'initdata_',run_id,'.mat'];
save(filename, 'dx','dy', 'Nx', 'Ny', 'xlength', ...
     'ylength', 'x', 'y','run_id', 'explicit_vel', 'D',...
     'dt','dt_flick','t_final_flick');

