function setup_hairs() 

global hairs_data_filename hairs_data_returnfilename hairs_data_filename_interior
global pathbase_data hairNum run_id
global xshift_piv_data yshift_piv_data
global x y 
global ptindex_hairs hairs_c hairs_center allhairs_center shift_hairs
global far_right_hair   
%global return_ptindex_hairs return_hairs_c return_hairs_center

%NOTES: SK 2018_01_22
%COMMENTED ALL RETURN HAIR STUFF OUT 
%AND THEREFORE ALSO NO NEED TO SHIFT SINCE ONLY FLICK 
%ASSUMED GIVEN RADIUS OF HAIRS 

[xx,yy] = ndgrid(x,y);

%hairs filename
flickdata = load([hairs_data_filename '.mat']);  
% [flickdata.p] = convert_hairdata(pathbase_data,hairNum,str2double(run_id));


%loads the location of the hairs
flick_hairs = eval(['flickdata.' hairs_data_filename_interior.filename '.' hairs_data_filename_interior.hairs]); 

%initializes the concentration absorbed by each hair
hairs_c = struct([]);

%if a radius is given for each hairs and the location of the hairs just
%gives the center of each hair 
if (hairs_data_filename_interior.givenradius)
   
    %%NO LONGER TRUE  
    %%we assume here that the hairs in the flick and return have the same size and shape
    %%but the code is written such that the location of the center of all
    %%hairs could be different 
    
    %if (length(flick_hairs)~=length(return_hairs))
    %    error('number of hairs is different in flick and return') 
    %end

    %we use the information from the flick hairs 
    %radius of the hairs from params file -> now in meters 
     
    hairs_radius = hairs_data_filename_interior.conversion_factor*eval(['flickdata.'  hairs_data_filename_interior.filename '.' hairs_data_filename_interior.radius]);
    %hairs_radius = 4*hairs_radius
    
    %find indices of points inside the hairs 
    for i=1:length(flick_hairs)
        distance_to_hair_squared = 0;
        x_hairs = 0;
        y_hairs = 0; 
        x_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).x + xshift_piv_data(1);
        y_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).y + yshift_piv_data(1); 
        distance_to_hair_squared = (xx-x_hairs).^2 + (yy-y_hairs).^2;
        %linear indices in matrix c 
        [ptindex_hairs{i}]= find(distance_to_hair_squared <= hairs_radius^2); 
        %finishes initialization of the concentration absorbed by each hair
        hairs_c{i} = zeros(length(ptindex_hairs{i}),1); 
        hairs_center(i,:) = [x_hairs, y_hairs];
    end
    %finding the farthest right point on any hair based on just the flick hairs
    far_right_hair = max(hairs_center(:,1))+hairs_radius; 
    
%     %we use the information from the return hairs
%     %radius of the hairs from params file -> given in cm and need in mm 
%     return_hairs_radius = hairs_data_filename_interior.conversion_factor*eval(['returndata.' hairs_data_filename_interior.filename '.' hairs_data_filename_interior.radius]);
%     %hairs_radius = 4*hairs_radius
%      
%     %find indices of points inside the hairs 
%     for i=1:length(return_hairs)
%         return_distance_to_hair_squared = 0;
%         return_x_hairs = 0;
%         return_y_hairs = 0; 
%         return_x_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).x + xshift_piv_data(2);
%         return_y_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).y + yshift_piv_data(2); 
%         return_distance_to_hair_squared = (xx-return_x_hairs).^2 + (yy-return_y_hairs).^2;
%         %linear indices in matrix c 
%         [return_ptindex_hairs{i}]= find(return_distance_to_hair_squared <= return_hairs_radius^2); 
%         %finishes initialization of the concentration absorbed by each hair
%         return_hairs_c{i} = zeros(length(return_ptindex_hairs{i}),1); 
%         return_hairs_center(i,:) = [return_x_hairs, return_y_hairs];
%     end
    
% elseif (~hairs_data_filename_interior.givenradius)
%     
%     if (length(flick_hairs)~=length(return_hairs))
%         error('number of hairs is different in flick and return') 
%     end
%     
%     %NO LONGER TRUE     
%     %we assume here that the hairs in the flick and return have the same size and shape
%     %but the code is written such that the location of the center of all
%     %hairs could be different 
%     
%     %we just use the information from the flick hairs for far_right_hair
%     far_right_hair = 0; 
%     
%     %for i=1:length(flick_hairs)
%     %we now do not use the 4 farthest right hairs because they are not biologically relevant
%     counter = 1; 
%     for i=[1:6,8,9,11,12,14,16]
%         x_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).x + xshift_piv_data(1);
%         y_hairs = hairs_data_filename_interior.conversion_factor*flick_hairs(i).y + yshift_piv_data(1); 
%         
%         [ptindex_hairs{counter}] = find(inpolygon(xx,yy,x_hairs,y_hairs)==1); 
%         hairs_c{counter} = zeros(length(ptindex_hairs{counter}),1); 
%         
%         %as long as convex hull
%         hairs_center(counter,:) = [mean(x_hairs), mean(y_hairs)];
%         
%         %finding the farthest right point on any hair
%         far_right_hair = max([far_right_hair;x_hairs]);
%         
%         counter = counter+1;         
%     end
%     
%     %for i=1:length(flick_hairs)
%     %we now do not use the 4 farthest right hairs because they are not biologically relevant
%     counter = 1; 
%     for i=[1:6,8,9,11,12,14,16]
%         return_x_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).x + xshift_piv_data(2);
%         return_y_hairs = hairs_data_filename_interior.conversion_factor*return_hairs(i).y + yshift_piv_data(2); 
%         
%         %linear indices in matrix c 
%         [return_ptindex_hairs{counter}] = find(inpolygon(xx,yy,return_x_hairs,return_y_hairs)==1); 
%         return_hairs_c{counter} = zeros(length(return_ptindex_hairs{counter}),1); 
%         
%         %as long as convex hull
%         return_hairs_center(counter,:) = [mean(return_x_hairs), mean(return_y_hairs)];
%         
%         counter = counter+1; 
%         
%     end
    
    
    
end
    


% figure(1)
% hold on
% plot(xx,yy,'bx')
% for i=1:length(flick_hairs)
%     plot(xx(ptindex_hairs{i}),yy(ptindex_hairs{i}),'ro')
%     plot(hairs_center(i,1),hairs_center(i,2),'gx')
%     if (hairs_data_filename_interior.givenradius)
%         viscircles(hairs_center(i,:),hairs_radius,'EdgeColor','k','LineWidth',1)
%     elseif (~hairs_data_filename_interior.givenradius)
%         plot(hairs_data_filename_interior.conversion_factor*hairs(i).x + xshift_piv_data,hairs_data_filename_interior.conversion_factor*hairs(i).y + yshift_piv_data,'k')
%         plot(hairs_data_filename_interior.conversion_factor*hairs(i).x + xshift_piv_data,hairs_data_filename_interior.conversion_factor*hairs(i).y + yshift_piv_data,'k*')
%     end
% end
% pause

    
