function entsniff(topdir,hairNum,filenumbers,clpool)
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
cd(topdir)

% Add paths to relevant matlab analysis scripts
addpath(genpath(strcat(topdir,'/src/matlab')))

global pathbase_piv pathbase_data pathbase_results GridSize final_time 
global files files0 hairNum
GridSize = 4096;
final_time = 30000;
%assignin('base','GridSize',4096)        %Size of the finest grid
%assignin('base','final_time',30000)      %Final time step to be included in data analysis

j = length(filenumbers);
for ii = 1:j
   files{ii} = sprintf('%d', filenumbers(ii));
   files0{ii} = sprintf('%04d', filenumbers(ii));
end

%assignin('base','files',files)
%assignin('base','files0',files0)
%assignin('base','pathbase1','/pylon5/bi561lp/lwaldrop/shilpa/pivdata/')
% Setting paths to necessary files
pathbase_piv = strcat(topdir, '/results/ibamr/', num2str(hairNum), 'hair_runs/');
pathbase_data = strcat(topdir, '/data/');
pathbase_results = strcat(topdir, '/results/odorcapture/',num2str(hairNum),'hair_array/');
%save('work.mat','GridSize','final_time','files','files0','pathbase1')

save('temp_global_variable','pathbase_data','pathbase_piv','pathbase_results',...
    'GridSize','final_time','hairNum');

mycluster = parpool(clpool);

parfor i = 1:length(files)
% for i=1:length(files)
    % i=3
    % tic
    disp(['Simulation number: ',files{i}])
    disp('   ')
    
    % Setting up hair info files
    if isfile([pathbase_data,'/hairinfo-files/',num2str(hairNum),...
            'hair_files/hairinfo',num2str(i),'.mat'])==0
        disp(['Setting up hair info files for ',files{i}])
        convert_hairdata(pathbase_data,hairNum,i)
    end
    
    if isfile([pathbase_piv,'viz_IB2d',num2str(i),'.mat'])==0
        % Interpolates velocity fields and saves.
        disp(['Interpolating velocity fields for ', files{i}])
        entsniffinterp(i, files, pathbase_piv, GridSize, final_time);
        disp('    ')
    end

    % Run Shilpa's code
    disp(['starting simulation for ', files0{i}])
    crabs(files0{i})
    
    cleanupent(pathbase_piv, pathbase_results)
    
    % timing(i)=toc
end

delete('temp_global_variable');