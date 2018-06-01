function setup_hairs_for_velocity() 

global hairs_data_filename hairs_data_returnfilename hairs_data_filename_interior
global allhairs_center shift_hairs
global dthairfactor 

%NOTES: SK 2017_11_16
%COMMENTED ALL RETURN HAIR STUFF OUT 
%AND THEREFORE ALSO NO NEED TO SHIFT SINCE ONLY FLICK 
%ASSUMED GIVEN RADIUS OF HAIRS 

%hairs filename
flickdata_temp = load(['pivdata/' hairs_data_filename '.mat']);  
flickdata = eval(['flickdata_temp.' hairs_data_filename_interior.filename]);
%returndata = load(['pivdata/' hairs_data_returnfilename '.mat']); 

flickdata = modify_hair_data(flickdata,hairs_data_filename_interior.numofhairs); 
eval([hairs_data_filename_interior.filename, '=flickdata']); 
save(['pivdata/' hairs_data_filename '.mat'],hairs_data_filename_interior.filename); 

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
     
 
     
%      for i=1:length(return_hairs)
%         
%         %return hairs location
%         return_x_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).x;
%         return_y_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).y;
%         return_hairs_center(i,:) = [return_x_hairs, return_y_hairs];    
%       
%     end
%     
      allhairs_center(1,:) = mean(flick_hairs_center);
%      allhairs_center(2,:) = mean(return_hairs_center);
%     
%     %how much we shift the return hairs (and domain by) 
%     shift_hairs = allhairs_center(2,:)-allhairs_center(1,:);

      dthairfactor = eval(['flickdata.' hairs_data_filename_interior.radius]); 
    
    
% elseif(~hairs_data_filename_interior.givenradius)
%     
%     for i=1:length(flick_hairs)
%         %flick hairs location
%         flick_x_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).x;
%         flick_y_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).y;
%         %as long as convex hull
%         flick_hairs_center(i,:) = [mean(flick_x_hairs), mean(flick_y_hairs)];
%     end
%     
%     for i=1:length(return_hairs)
%         
%         %return hairs location
%         return_x_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).x;
%         return_y_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).y;
%         %as long as convex hull
%         return_hairs_center(i,:) = [mean(return_x_hairs), mean(return_y_hairs)];
%         
%     end
%     
%     allhairs_center(1,:) = mean(flick_hairs_center);
%     allhairs_center(2,:) = mean(return_hairs_center);
%     
%     %how much we shift the return hairs (and domain by) 
%     shift_hairs = allhairs_center(2,:)-allhairs_center(1,:);
%     
 end