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
cd('/Users/Bosque/Documents/MATLAB/shilpa2/')

% Add paths to relevant matlab analysis scripts
addpath(genpath('/Users/Bosque/Documents/MATLAB/matlab-tytell/'))
addpath(genpath('/Users/Bosque/Documents/MATLAB/shilpa2/'))

GridSize = 4096;        %Size of the finest grid
final_time=25000;      %Final time step to be included in data analysis
%n=1233; %Number of simulations

pathbase1='/Users/Bosque/Documents/MATLAB/shilpa2/pivdata/';
pathbase2='/Users/Bosque/Documents/MATLAB/shilpa2/pivdata/';

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
    
    % Saves data relevant to next step in workflow.
    save([pathbase1,file1,'.mat'],'V','Vinterp','x','y','GridSize','final_time')
    clear x y Vinterp V
    
    % Run Shilpa's code
    filename=sprintf('%04d',i);
    crabs(filename)

    clear filename
    
toc
end
