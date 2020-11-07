function save_initdata()
%function save_initdata.m 
%input: 
%output: 
%saves fixed parameters/variables initially

global run_id dx dy Nx Ny xlength ylength x y 
global explicit_vel 
global D
global dt dt_flick dt_rest dt_return
global t_final_flick t_final_rest t_final_return

%the default extension is .mat
filename = ['postprocessing/initdata_',run_id];
save(filename, 'dx','dy', 'Nx', 'Ny', 'xlength', ...
     'ylength', 'x', 'y','run_id', 'explicit_vel', 'D',...
     'dt','dt_flick','dt_rest','dt_return',...
     't_final_flick','t_final_rest','t_final_return');

