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


%saving data finally
pcount = pcount+1;  
save_data(0); 
list_print_times(pcount) = t; 
fprintf('printing %g %g \n',t,pcount)
save_printdata(); 
cleanup(); 
 