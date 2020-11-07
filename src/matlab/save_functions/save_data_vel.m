function save_data_vel(initial,flickorreturn)
%function save_data_vel.m 
%input: 
%output: 
%saves velocity data

global run_id 
global u v 

%the default extension is .mat

filename = ['postprocessing/velocity_',run_id];

T = evalc(['u_' flickorreturn ' = u']);
T2 = evalc(['v_' flickorreturn ' = v']);


if (initial == 1)
    save(filename, 'u_*','v_*');
elseif (initial == 0)
    save(filename, 'u_*', 'v_*', '-append');
end
      


