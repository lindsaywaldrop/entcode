%This script will read in force data from hier_data_IB2d and will determine
%the average dimensionless force acting on the structure over time.

close all
clear all
clc

starting_time=1000; %First time step to be included in data analysis
time_step=1000; %Interval between outputted time steps (this should match the interval in the input2d file)
final_time=2000000; %Final time step to be included in data analysis

timestep=10^-5; %dt used by IBAMR, this allows you to calculate the simulation time
n=1; %used to count
time=(starting_time:time_step:final_time)*timestep; 

%parameters for dimensionless force calculation
rho = 1000; %fluid density from IBAMR input file
U0 = 0.1; %flow velocity relative to boundary in x-direction
U1 = 0.0; %flow velocity relative to boundary in y-direction
length = 0.1; %length of boundary
mu = 4; %fluid viscosity from IBAMR input file
Re = rho*sqrt(U0^2+U1^2)*length/mu;  %calculates Re to be used as a label

for k=starting_time:time_step:final_time
    if time(n)<10000*timestep %you have to check if there is a 0 before the number, and then add it.
        %make this the correct pathname for your directory
        path_name2 = '/Users/lauramiller/Desktop/hier_data_IB2d/F.0';
    end
    if time(n)>9000*timestep
        %make this the correct pathname for your directory
        path_name2 = '/Users/lauramiller/Desktop/hier_data_IB2d/F.';
    end
    
    %read in the forces
    [fx, fy] = forceread(path_name2, k);
    %calculate dimensionless force by adding all forces along the boundary
    %Note there is a factor 2 correction for some IBAMR error!
    avefx(n)=-2*sum(fx)/(rho*sqrt(U0^2+U1^2)^2*length);
    avefy(n)=-2*sum(fy)/(rho*sqrt(U0^2+U1^2)^2*length);
    n=n+1;
end
    
    %graph dimensionless force vs. time
    figure(1)
    hold off
    plot(time,avefx)
    hold on
    plot(time,avefy, ':k')
    xlabel('Time')
    ylabel('Dimensionless Force')
    title(strcat({'Re = '}, num2str(Re)))
    legend('Dimensionless Drag', 'Dimensionless Lift')
    
    