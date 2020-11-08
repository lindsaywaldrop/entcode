%script set_vars.m
%initializes the variables for the program

global pathbase_data hairNum
global xlength ylength Nx Ny dx dy x y u v
global dthairfactor dt dt_flick t_final_flick t_steps_flick t_steps
%global dt dt_flick dt_rest dt_return t_final_flick t_final_rest t_final_return t_steps_flick t_steps_rest t_steps_return t_steps
global list_print_times t pcount print_time run_id
global D initc
global c c_diff_matrix_l c_diff_matrix_u c_diff_RHS c_diff_matrix usegmres
global explicit_vel piv_data_filename piv_data_filename_interior piv_data_returnfilename
global xshift_piv_data yshift_piv_data
global handle_hairs hairs_data_filename hairs_data_filename_interior hairs_data_returnfilename
%only used in read_in_velocity_data_p2.m and advect_c.m
global uplusx_piv uminusx_piv uplusy_piv uminusy_piv
global vplusx_piv vminusx_piv vplusy_piv vminusy_piv
global uplus2x_piv uminus2x_piv vplus2ypiv vminus2ypiv
%only used in read_in_velocity_data_p1.m and read_in_velocity_data_p2.m
global Nxcoarse
%only used in advect_c if using weno
global weno_eps
%only used in dealing with the hairs in setup_hairs.m and
%conecentration_absorbed_by_hairs
global ptindex_hairs hairs_c hairs_center allhairs_center shift_hairs far_right_hair
global return_ptindex_hairs return_hairs_c return_hairs_center
%c bc on the right wall if using dirichlet bcs - always used for advection
%and for diffusion if specified 
global cplusx_dbc diffusionrhsbc_flick

%setting the path so matlab can find all the functions
% addpath('./save_functions')
 
%read in the parameters
run_id = filenumber
cd(strcat(pathbase_data,'parameters/'))
run odorcapture_params.m

cd(strcat(pathbase_data,'hairinfo-files/',num2str(hairNum),'hair_files/'))
%set x_length and y_length here if based on experimental data otherwise in
%params file manually
if strcmp(explicit_vel,'piv_data')
   if (handle_hairs)
       disp('setup_hairs')
        setup_hairs_for_velocity()
   end
   disp('read_in_velocities')
   read_in_velocity_data_p1(domainlimits)
end

%initializes Nx and Ny 
Nx = round(xlength/dx)
Ny = round(ylength/dy)

%should already be an int from read_in_velocity_data_p1.m
if (abs(Nx*dx-xlength)>1e-15) || (abs(Ny*dy-ylength)>1e-15)
    error('domain setting in set_vars.m')
end

%initialize x and y 
x(1:Nx+1,1)=(0:Nx)*dx; 
y(1:Ny+1,1)=(0:Ny)*dy; 
%for periodic/noflux bc 
%x(1:Nx,1)=(0:Nx-1)*dx; 
%y(1:Ny+1,1)=(0:Ny)*dy; 

%initializing time stepping variables
dt = min(0.9*dx/dtfactor,dthairfactor^2/4/D); 
if exist('dtmultiplier')
    dt = dtmultiplier*dt; 
end
%dt_rest = min(0.9*dx,dthairfactor^2/4/D); 

%flick time
if exist('t_final_factor_flick','var')
   t_final_flick = dt*t_final_factor_flick;
end
t_steps_flick = ceil(t_final_flick/dt);
dt_flick = t_final_flick/t_steps_flick;

t = 0; 
pcount = 1; 
list_print_times = 0;  
t_steps = 0; 

%initialize u and v 
u = zeros(Nx+1,Ny+1);
v = zeros(Nx+1,Ny+1); 
%for periodic/noflux bc
%u = zeros(Nx,Ny+1);
%v = zeros(Nx,Ny+1); 

%printing informaton about grids
%fprintf('\t dx = %4.16f\n\t dy = %4.16f\n\t dt = %4.25f\n\t dt_rest = %4.25f\n ', dx, dy, dt, dt_rest);
%fprintf('\t Grid (Nx by Ny) : %d by %d\n', Nx, Ny);
%fprintf('\t final times: flick: %4.16f\t rest: %4.16f\t return: %4.16f\n', t_final_flick, t_final_rest, t_final_return);
%fprintf('\t number of tsteps: flick: %d\t rest: %d\t return: %d\n',t_steps_flick,t_steps_rest,t_steps_return);
%fprintf('\t xlength by ylength: %4.16f by %4.16f\n',xlength,ylength); 

fprintf('\t dx = %4.16f\n\t dy = %4.16f\n\t dt = %4.25f\n ', dx, dy, dt_flick);
fprintf('\t Grid (Nx by Ny) : %d by %d\n', Nx, Ny);
fprintf('\t final times: flick: %4.16f\n', t_final_flick);
fprintf('\t number of tsteps: flick: %d\n',t_steps_flick);
fprintf('\t xlength by ylength: %4.16f by %4.16f\n',xlength,ylength); 

if (handle_hairs)
    setup_hairs()
end

%initialize the concentration
initialize_c(initc)

