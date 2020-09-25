function [ vol_flow,u_max,sim_time ] = flappy_end_analysis
%	This function imports SAMRAI data into Matlab, interpolates to a
%	uniform grid, reads in the lagrangian positions, and calculates the
%	volumetric flow rate and maximum velocity at the end of the tube.
%   
% GridSize = IBAMR fluid grid size
% vol_flow = volumetric flow rate at end of tube at each time  
% u_max = maximum flow velocity at the end of the tube at each time
% sim_time = the corresponding simulation times


close all
clear all
clc

GridSize = 512;        %Size of the finest grid
starting_time=10000;   %First time step to be included in data analysis
time_step=5000;        %Interval between outputted time steps (this should match the interval in the input2d file)
final_time=20000;      %Final time step to be included in data analysis
Ntimes = ceil((final_time-starting_time)/time_step)+1; %number of time steps to be analyzed
u_max = zeros(Ntimes,1);        %vector to hold the max flow speed at each time
vol_flow = zeros(Ntimes,1);     %vector to hold the volumetric flow rate
sim_time = zeros(Ntimes,1);     % vector to hold the simulation time

timestep=10^-5; %dt used in IBAMR
n=1; %used for counting
Lmin=-0.5; %Top of the fluid grid
Lmax=0.5; %Bottom of the fluid grid

for k=starting_time:time_step:final_time
    
    %Make this the pathname for the visit data
    path_name1 = ['../../viz_IB2d/visit_dump.' num2str(k)];
    %Make sure this gives the pathname for the position data (hier_data)
    path_name2 = '../../hier_data_IB2d/X.';
    
    %This returns the x and y positions of the boundary
    [posx, posy] = positionread(path_name2, k);
    %This reads the samrai data and interpolates it.
    [x,y,Vinterp,V] = importsamrai(path_name1,'interpolaten',[GridSize GridSize]);
    
    %This calculates the volumetric flow rate through the floppy end of the
    %tube
    [VFlow,Umax,i1, i2, j1, j2] = vol_flow_rate(x,y,Vinterp,posx,posy,GridSize,Lmin,Lmax);
    vol_flow(n) = VFlow;    %store the volumetric flow rates
    u_max(n) = Umax;        %store the maximum velocities
    sim_time(n) = (starting_time+(n-1)*(time_step))*timestep;   %store the simulation times
    n = n+1;
    
    %make a graph to check you are taking the right velocities
    figure(1)
    hold off
    plot(posx,posy,'.')
    hold on
    plot(x(j2:j1,i1),y(j2:j1,i1),'.')
    pause
end


end

