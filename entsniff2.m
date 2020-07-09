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
cd('/pylon5/bi561lp/lwaldrop/entcode/shilpacode/')

% Add paths to relevant matlab analysis scripts
addpath(genpath('/pylon5/bi561lp/lwaldrop/entcode/shilpacode/'))
addpath(genpath('/pylon5/bi561lp/lwaldrop/entcode/'))

global pathbase1 pathbase2 GridSize final_time files files0
GridSize=4096;
final_time=30000;
%assignin('base','GridSize',4096)        %Size of the finest grid
%assignin('base','final_time',30000)      %Final time step to be included in data analysis
%n=1233; %Number of simulations
j = (endrun-startrun);
for ii=0:j
   files{ii+1}=sprintf('%d',startrun+ii);
   files0{ii+1}=sprintf('%04d',startrun+ii);
end

assignin('base','files',files)
assignin('base','files0',files0)
%assignin('base','pathbase1','/pylon5/bi561lp/lwaldrop/entcode/shilpacode/pivdata/')
pathbase1='/pylon5/bi561lp/lwaldrop/entcode/shilpacode/pivdata/';
pathbase2='/pylon5/bi561lp/lwaldrop/entcode/shilpacode/postprocessing/';
%save('work.mat','GridSize','final_time','files','files0','pathbase1')

mycluster=parpool(8)

length(files)

parfor i=1:length(files)
    %i=3
    tic
    disp(['Simulation number: ',num2str(i)])
    disp('   ')

    % Interpolates velocity fields and saves.
    disp(['Interpolating velocity fields for ',files{i}])
    entsniffinterp(i,files,pathbase1,GridSize,final_time);
    disp('    ')

    % Run Shilpa's code
    disp(['starting simulation for ',files0{i}])
    crabs(files0{i})
    
    cleanupent(pathbase1,pathbase2)
    
    timing(i)=toc
end
