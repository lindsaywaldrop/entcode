%This script makes a grid of 10 vorticity plots. You must set the time
%ranges to plot the correct 10.
%The script uses a function from Tytell's matlab. Be sure this function and
%positionread.m are in the same folder.

close all
clear all
clc

starting_time=700000; %First time step to be included in data analysis
time_step=10000; %Interval between outputted time steps (this should match the interval in the input2d file)
final_time=790000; %Final time step to be included in data analysis

timestep=10^-5; %dt used in IBAMR
GridSize=512; %IBAMR fluid grid size
BoundarySize=10; %Number of boundary points
n=1; %used for counting
Lmin=-4; %Top of the fluid grid
Lmax=4; %Bottom of the fluid grid

time=(starting_time:time_step:final_time)*timestep; 

for k=starting_time:time_step:final_time
    
    %Make this the pathname for the visit data
    path_name1 = ['E:/MyDocuments/IBAMR/MyIBAMR/Laura/Alben_jellyfish/Run4Paper/Curvature_jelly_betam0p2_Re500/viz_IB2d/visit_dump.' num2str(k)];
    %Make sure this gives the pathname for the position data (hier_data)
    path_name2 = 'E:/MyDocuments/IBAMR/MyIBAMR/Laura/Alben_jellyfish/Run4Paper/Curvature_jelly_betam0p2_Re500/hier_data_IB2d/X.';
    
    %This returns the x and y positions of the boundary
    [posx, posy] = positionread(path_name2, k);
    %This reads the samrai data and interpolates it.
    [x,y,Vinterp,V] = importsamrai(path_name1,'interpolaten',[GridSize GridSize]);

    %This does a minimal amount of smoothing to make things look better
    %near the boundary.
    Omega_s=smooth2a(Vinterp.Omega,2,2);
    
    %y_shift will shift the y coordinate so that the first boundary point
    %is always at y=0.
    y_shift = posy(1,1);
    posy = posy-y_shift;
    y = y-y_shift;
    %y1 is going to be used to copy the vorticity data to fill in the
    %bottom of the domain.
    y1 = y-(Lmax-Lmin); 
    
    %This creates a 5x2 figure of vorticity plots
    figure(2)
    subplot(2,5,n);
    pcolor(x,y,Omega_s);
    hold on
    pcolor(x,y1,Omega_s);
    plot(posx, posy, '.k');
    shading interp;
    DefineCmap1;
    colormap(CMap1);
    axis equal;
    axis([-0.8 0.8 -2.2 0.2]);
    caxis([-10 10])
    title(strcat({'t = '}, num2str(time(n))));
    hold off
    n=n+1;
end
    
     
    
   % saveas(gcf, 'Force_over_time', 'png')