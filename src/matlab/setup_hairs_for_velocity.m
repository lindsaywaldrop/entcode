function setup_hairs_for_velocity(hairNum) 

global hairs_data_filename hairs_data_filename_interior 
global allhairs_center pathbase_piv pathbase_data
global dthairfactor run_id hairNum domainlimits

%NOTES: SK 2017_11_16
%COMMENTED ALL RETURN HAIR STUFF OUT 
%AND THEREFORE ALSO NO NEED TO SHIFT SINCE ONLY FLICK 
%ASSUMED GIVEN RADIUS OF HAIRS 

%hairs filename
flickdata_temp = load(strcat(pathbase_data, '/hairinfo-files/', num2str(hairNum), ...
	'hair_files/', hairs_data_filename, '.mat'));  
flickdata = eval(['flickdata_temp.' hairs_data_filename_interior.filename]);

flickdata = modify_hair_data(flickdata,hairs_data_filename_interior.numofhairs); 
eval([hairs_data_filename_interior.filename, '=flickdata']); 
save([pathbase_data,'hairinfo-files/',num2str(hairNum),'hair_files/',...
    hairs_data_filename '.mat'],hairs_data_filename_interior.filename); 

%loads the location of the hairs
flick_hairs = eval(['flickdata.' hairs_data_filename_interior.hairs])

% Set domain limits based on hairs
xLmin = min([flick_hairs.x]) - 0.05;
xLmax = max([flick_hairs.x]) + 0.15;
yLmin = min([flick_hairs.y]) - 0.05;
yLmax = max([flick_hairs.y]) + 0.05;
domainlimits = [xLmin, xLmax, yLmin, yLmax];

if (hairs_data_filename_interior.givenradius)
    
     for i=1:length(flick_hairs)
        %flick hairs centerlocation
        flick_x_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).x;
        flick_y_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).y;
        flick_hairs_center(i,:) = [flick_x_hairs, flick_y_hairs];
        
     end
     
 
      allhairs_center(1,:) = mean(flick_hairs_center);
      dthairfactor = eval(['flickdata.' hairs_data_filename_interior.radius]); 
        
 end