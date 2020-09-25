function crabs(filenumber)
%function crabs.m 
%input: filenumber - string
%output: 
%main file - calls all the timestepping steps for this program

%initialize
set_vars
%saving data initially
save_data(1); 

%FLICK
[u,v] = get_velocities(dt_flick/2,t,explicit_vel,'flick'); 
save_data_vel(1,'flick');

%time-stepping
%could speed this up by taking out the if else statements from the for loop

%advection - first step
advect_c(dt_flick/2,'dirichlet','weno');

for timestep = 1:t_steps_flick
   
  %diffusion  
  %if first timestep then initialze the diffusion matrix   
  if (timestep == 1) 
      diffusion_c(dt_flick,1,diffusionrhsbc_flick);
  else
      diffusion_c(dt_flick,0,diffusionrhsbc_flick); 
  end
  concentration_absorbed_by_hairs();
  
  %advection
  %if not at the last timestep then step with dt but if at the last
  %timestep then step only dt/2    
  if (timestep ~= t_steps_flick)
     advect_c(dt_flick,'dirichlet','weno');
  elseif (timestep == t_steps_flick) 
     advect_c(dt_flick/2,'dirichlet','weno');
  end
  
  t = t + dt_flick; 
  t_steps = t_steps + 1; 
  
  %saving data
  if (mod(t_steps,print_time)==0) 
    pcount = pcount + 1; 
    save_data(0);     
    list_print_times(pcount) = t; 
    fprintf('printing %g %g \n',t,pcount)
  end

end

% %RETURN
% [u,v] = get_velocities(dt_return/2,t,explicit_vel,'return'); 
% save_data_vel(0,'return');
% 
% %time-stepping
% %could speed this up by taking out the if else statements from the for loop
% 
% 
% %advection - first step
% if (t_steps_return >= 1)
%     advect_c(dt_return/2,'dirichlet','weno');
% end
%     
% for timestep = 1:t_steps_return
%    
%   %diffusion  
%   %if first timestep then initialze the diffusion matrix   
%   if (timestep == 1) 
%       diffusion_c(dt_return,1,'noflux');
%   else
%       diffusion_c(dt_return,0,'noflux'); 
%   end
%   concentration_absorbed_by_hairs_return();
%   
%   %advection
%   %if not at the last timestep then step with dt but if at the last
%   %timestep then step only dt/2    
%   if (timestep ~= t_steps_return)
%      advect_c(dt_return,'dirichlet','weno');
%   elseif (timestep == t_steps_return) 
%      advect_c(dt_return/2,'dirichlet','weno');
%   end
%   
%   t = t + dt_return; 
%   t_steps = t_steps + 1; 
%   
%   %saving data
%   if (mod(t_steps,print_time)==0) 
%     pcount = pcount + 1; 
%     save_data(0);     
%     list_print_times(pcount) = t; 
%     fprintf('printing %g %g \n',t,pcount)
%   end
% 
% end

% %REST
% [u,v] = get_velocities(dt_rest/2,t,explicit_vel,'rest'); 
% save_data_vel(0,'rest');
% 
% %time-stepping
% %could speed this up by taking out the if else statements from the for loop
% 
% %advection - first step
% %advect_c(dt_rest/2,'dirichlet','weno');
% 
% for timestep = 1:t_steps_rest
%    
%   %diffusion  
%   %if first timestep then initialze the diffusion matrix   
%   if (timestep == 1) 
%       diffusion_c(dt_rest,1,'noflux');
%   else
%       diffusion_c(dt_rest,0,'noflux'); 
%   end
%   concentration_absorbed_by_hairs_return();
%   
%   %advection
%   %if not at the last timestep then step with dt but if at the last
%   %timestep then step only dt/2    
%   %if (timestep ~= t_steps_rest)
%   %   advect_c(dt_rest,'dirichlet','weno');
%   %elseif (timestep == t_steps_rest) 
%   %   advect_c(dt_rest/2,'dirichlet','weno');
%   %end
%   
%   t = t + dt_rest; 
%   t_steps = t_steps + 1; 
%   
%   %saving data
%   if (mod(t_steps,print_time_rest)==0) 
%     pcount = pcount + 1; 
%     save_data(0);     
%     list_print_times(pcount) = t; 
%     fprintf('printing %g %g \n',t,pcount)
%   end
% 
% end

%saving data finally
pcount = pcount+1;  
save_data(0); 
list_print_times(pcount) = t; 
fprintf('printing %g %g \n',t,pcount)
save_printdata(); 
cleanup(); 
 