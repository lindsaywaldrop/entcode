function entsniff(startrun,endrun)
% entsniff.m
%
% Script for running code on Bridges
%
%	This script imports SAMRAI data into Matlab, interpolates to a
%	uniform grid. Only the final time step (set by user) is imported.
%
%   Note: This script relies on Eric Tytell's Matlab code for importing samrai data! 
%	This package needs to be installed for this to work properly!
% 
% 	GridSize = IBAMR fluid grid size
%	final_time = final time step of simulation, or time step of interest.
% 	n = total number of simulations
%	pathbase = where runs are located

%Change directory
cd('/pylon5/ca4s8kp/lwaldrop/entcode/')

% Add paths to relevant matlab analysis scripts
addpath(genpath('/pylon5/ca4s8kp/lwaldrop/entcode/'))

GridSize = 4096;        %Size of the finest grid
final_time=25000;      %Final time step to be included in data analysis
%n=1233; %Number of simulations

pathbase1='/pylon2/ca4s8kp/lwaldrop/entcode_finished/';
pathbase2='/pylon2/ca4s8kp/lwaldrop/hairinfo_files/';

for i=startrun:endrun
    %i=3
tic
    clear V Vinterp x y
    file1=['viz_IB2d',num2str(i)];
    path1=[pathbase1,file1];
    
    disp(['Simulation number: ',num2str(i)])
    
    %Make this the pathname for the visit data
	path_name1 = [path1,'/visit_dump.',num2str(final_time)];
    
    %This reads the samrai data and interpolates it.
    [x,y,Vinterp,V] = importsamrai(path_name1,'interpolaten',[GridSize GridSize]);
    
    % Loads hairdata
    load([pathbase2,'hairinfo',num2str(i),'.mat'])
    
    % Run Shilpa's code here.
    j = i.^2;
    disp(num2str(j))
    
    % Saves data relevant to next step in workflow.
    % save([pathbase,'/matfiles/',file,'.mat'],'V','Vinterp','x','y','GridSize','final_time')
toc
end
