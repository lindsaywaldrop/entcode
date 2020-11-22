function entsniff(topdir,hairNum,fluid,filenumbers,clpool)
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
global files files0 hairNum fluid topdir

GridSize = 4096;
final_time = 30000;

j = length(filenumbers);
for ii = 1:j
   files{ii} = sprintf('%d', filenumbers(ii));
   files0{ii} = sprintf('%04d', filenumbers(ii));
end

% Setting paths to necessary files
pathbase_piv = strcat(topdir, '/results/ibamr/', num2str(hairNum), 'hair_runs/')
pathbase_data = strcat(topdir, '/data/')
pathbase_results = strcat(topdir, '/results/odorcapture/',num2str(hairNum),'hair_array/',fluid,'/')
fluid

save(strcat(topdir,'/src/matlab/','temp_global_variable.mat'),'pathbase_data','pathbase_piv','pathbase_results',...
    'GridSize','final_time','hairNum','fluid');

if clpool == 1
    
    for i=1:length(files)
        % i=3
        % tic
        disp(['Simulation number: ',files{i}])
        disp('   ')
        
 		% Setting up hair info files
        if isfile(strcat(pathbase_data,'/hairinfo-files/',num2str(hairNum),...
			 'hair_files/hairinfo',files{i},'.mat'))==0
			 delete(strcat(pathbase_data,'/hairinfo-files/',num2str(hairNum),...
			 'hair_files/hairinfo',files{i},'.mat'))
		end
        
        disp(['Setting up hair info files for ',files{i}])
		convert_hairdata(pathbase_data,hairNum,str2double(files{i}))
    
        if isfile(strcat(pathbase_piv,'viz_IB2d',files{i},'.mat'))==0
            delete strcat(pathbase_piv,'viz_IB2d',files{i},'.mat')
        end
        
		% Interpolates velocity fields and saves.
        disp(['Interpolating velocity fields for ', files{i}])
        entsniffinterp(i, files, pathbase_piv, GridSize, final_time);
        disp('    ')

        % Run Shilpa's code
        disp(['starting simulation for ', files0{i}])
        crabs(topdir,files0{i})
    
        cleanup()
    
        % timing(i)=toc
    end
    
elseif clpool > 1
    
    mycluster = parpool(clpool);
	addAttachedFiles(mycluster,{strcat(topdir,'/src/matlab/','temp_global_variable.mat')})
    
    parfor i = 1:length(files)
        % tic
        disp(['Simulation number: ',files{i}])
        disp('   ')
        
        % Setting up hair info files
        if isfile(strcat(pathbase_data,'/hairinfo-files/',num2str(hairNum),...
						 'hair_files/hairinfo',files{i},'.mat'))==0
			 delete(strcat(pathbase_data,'/hairinfo-files/',num2str(hairNum),...
			 			 'hair_files/hairinfo',files{i},'.mat'))
		end
        
        disp(['Setting up hair info files for ',files{i}])
		convert_hairdata(pathbase_data,hairNum,str2double(files{i}))
    
        if isfile(strcat(pathbase_piv,'viz_IB2d',files{i},'.mat'))==0
            delete strcat(pathbase_piv,'viz_IB2d',files{i},'.mat')
        end
        
		% Interpolates velocity fields and saves.
        disp(['Interpolating velocity fields for ', files{i}])
        entsniffinterp(i, files, pathbase_piv, GridSize, final_time);
        disp('    ')


        % Run Shilpa's code
        disp(['starting simulation for ', files0{i}])
        crabs(topdir,files0{i})
    
        cleanup()
    
        % timing(i)=toc
    end
else 
    disp('Error: Not a valid value for clpool!')
end

delete 'src/matlab/temp_global_variable.mat'

end
