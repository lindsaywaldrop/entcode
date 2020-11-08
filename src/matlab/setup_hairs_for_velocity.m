function setup_hairs_for_velocity(hairNum) 

global hairs_data_filename hairs_data_filename_interior 
global allhairs_center pathbase_piv pathbase_data
global dthairfactor run_id hairNum

%NOTES: SK 2017_11_16
%COMMENTED ALL RETURN HAIR STUFF OUT 
%AND THEREFORE ALSO NO NEED TO SHIFT SINCE ONLY FLICK 
%ASSUMED GIVEN RADIUS OF HAIRS 

%hairs filename
flickdata_temp = load(strcat(pathbase_data, '/hairinfo-files/', num2str(hairNum), ...
	'hair_files/', hairs_data_filename, '.mat'));  
%[flickdata_temp.p] = convert_hairdata(pathbase_data,hairNum,str2double(run_id));
flickdata = eval(['flickdata_temp.' hairs_data_filename_interior.filename]);
%returndata = load(['pivdata/' hairs_data_returnfilename '.mat']); 

flickdata = modify_hair_data(flickdata,hairs_data_filename_interior.numofhairs); 
eval([hairs_data_filename_interior.filename, '=flickdata']); 
save([pathbase_data,'hairinfo-files/',num2str(hairNum),'hair_files/',...
    hairs_data_filename '.mat'],hairs_data_filename_interior.filename); 

%loads the location of the hairs
flick_hairs = eval(['flickdata.' hairs_data_filename_interior.hairs]); 
%return_hairs = eval(['returndata.' hairs_data_filename_interior.filename '.' hairs_data_filename_interior.hairs]); 

if (hairs_data_filename_interior.givenradius)
    
     for i=1:length(flick_hairs)
        %flick hairs centerlocation
        flick_x_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).x;
        flick_y_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).y;
        flick_hairs_center(i,:) = [flick_x_hairs, flick_y_hairs];
        
     end
     
 
      allhairs_center(1,:) = mean(flick_hairs_center);

      %     %how much we shift the return hairs (and domain by) 

      dthairfactor = eval(['flickdata.' hairs_data_filename_interior.radius]); 
        
 end