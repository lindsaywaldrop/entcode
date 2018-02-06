close all
clear all
clc

path_name=pwd; %Path name to the folder of interest
starting_time=10000; %First time step to be included in data analysis
time_step=1000; %Interval between outputted time steps (this should match the interval in the input2d file)
final_time=800000; %Final time step to be included in data analysis

timestep=10^-5;
n=1;
Re = 1000;

time=(starting_time:time_step:final_time)*timestep; 

for k=starting_time:time_step:final_time
    if time(n)<10000*timestep
        path_name2 = 'E:/MyDocuments/IBAMR/MyIBAMR/Laura/Alben_jellyfish/Run4Paper/Curvature_jelly_betam0p2_Re500/hier_data_IB2d/X.0';
    end
    if time(n)>9000*timestep
    path_name2 = 'E:/MyDocuments/IBAMR/MyIBAMR/Laura/Alben_jellyfish/Run4Paper/Curvature_jelly_betam0p2_Re500/hier_data_IB2d/X.';
    end
    
    [posx, posy] = positionread(path_name2, k);
    posytop(n)=posy(1);
    n=n+1;
end
    n1=length(posytop);
    figure(1)
    plot(time(1:n1),posytop)
    xlabel('Time')
    ylabel('Position')
    title(strcat({'Re = '}, num2str(Re)))
    
    for i=1:(n1-1)
        velocity(i)=(posytop(i+1)-posytop(i))/(timestep*time_step);
    end
    figure(2)   
    plot(time(1:(n1-1)),velocity)
    xlabel('Time')
    ylabel('Velocity')
    title(strcat({'Re = '}, num2str(Re)));
   % saveas(gcf, 'Force_over_time', 'png')