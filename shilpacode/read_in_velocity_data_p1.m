function read_in_velocity_data_p1(dl)
%function read_in_velocity_data_p1.m 
%input: 
%output: 
%sets xlength and ylength based on the experimental piv data

%this function sets it so that the computational 
%domain for c sits inside the piv exp data

%NOTES: SK 2017_11_16
%COMMENTED ALL RETURN STUFF OUT 

global xlength ylength Nx Ny dx dy
global piv_data_filename piv_data_filename_interior piv_data_returnfilename
global xshift_piv_data yshift_piv_data
global Nxcoarse 
global allhairs_center shift_hairs 


%filenames
flickdata = load(['pivdata/' piv_data_filename '.mat']);
%returndata = load(['pivdata/' piv_data_returnfilename '.mat']);

%finding the endpts for x_length and y_length (data is in m) 
flick_xpiv = eval(['flickdata.' piv_data_filename_interior.x]);     
flick_ypiv = eval(['flickdata.' piv_data_filename_interior.y]);

%return_xpiv = eval(['returndata.' piv_data_filename_interior.filename '.' piv_data_filename_interior.x]);  
%return_ypiv = eval(['returndata.' piv_data_filename_interior.filename '.' piv_data_filename_interior.y]);

if  strcmp(dl,'auto')
    xLmin = piv_data_filename_interior.conversion_factor*max(flick_xpiv(:,1));
    xLmax = piv_data_filename_interior.conversion_factor*min(flick_xpiv(:,end));
    yLmin = piv_data_filename_interior.conversion_factor*max(flick_ypiv(1,:)); 
    yLmax = piv_data_filename_interior.conversion_factor*min(flick_ypiv(end,:)); 
else
    xLmin = dl(1); 
    xLmax = dl(2); 
    yLmin = dl(3); 
    yLmax = dl(4); 
end 

%return_xLmin = piv_data_filename_interior.conversion_factor*max(return_xpiv(:,1));
%return_xLmax = piv_data_filename_interior.conversion_factor*min(return_xpiv(:,end));
%return_yLmin = piv_data_filename_interior.conversion_factor*max(return_ypiv(1,:)); 
%return_yLmax = piv_data_filename_interior.conversion_factor*min(return_ypiv(end,:)); 

%shifting the return velocities based on the center of all the hairs
%return_xLmin_shifted = return_xLmin - shift_hairs(1); 
%return_xLmax_shifted = return_xLmax - shift_hairs(1);
%return_yLmin_shifted = return_yLmin - shift_hairs(2); 
%return_yLmax_shifted = return_yLmax - shift_hairs(2);

%setting x_length and y_length 
%xLmin = max(flick_xLmin,return_xLmin_shifted);
%xLmax = min(flick_xLmax,return_xLmax_shifted); 
%yLmin = max(flick_yLmin,return_yLmin_shifted);
%yLmax = min(flick_yLmax,return_yLmax_shifted); 
xlength = xLmax - xLmin; 
ylength = yLmax - yLmin; 

%flick_xlength = piv_data_filename_interior.conversion_factor*(min(flick_xpiv(:,end))-max(flick_xpiv(:,1)));
%flick_ylength = piv_data_filename_interior.conversion_factor*(min(flick_ypiv(end,:))-max(flick_ypiv(1,:)));

%return_xlength = piv_data_filename_interior.conversion_factor*(min(return_xpiv(:,end))-max(return_xpiv(:,1)));
%return_ylength = piv_data_filename_interior.conversion_factor*(min(return_ypiv(end,:))-max(return_ypiv(1,:)));

%xlength = min(flick_xlength,return_xlength);
%ylength = min(flick_ylength,return_ylength);

coarsedx = xlength/Nxcoarse;
coarsedy = coarsedx;

Nycoarse = floor(ylength/coarsedy);
Nycoarse_shift = coarsedy*(ylength/coarsedy - floor(ylength/coarsedy))/2;

dx = xlength/Nx;
dy = dx;

%minus 4 allows for extrap for weno2
xlength = (Nxcoarse-4)*coarsedx;
ylength = (Nycoarse-4)*coarsedy;

%flickdata shift 
xshift_piv_data(1) = -xLmin-2*coarsedx;
yshift_piv_data(1) = -yLmin-2*coarsedy-Nycoarse_shift;

%returndata shift 
%xshift_piv_data(2) = -xLmin-2*coarsedx-shift_hairs(1);
%yshift_piv_data(2) = -yLmin-2*coarsedy-Nycoarse_shift-shift_hairs(2);

% xshift_piv_data(1) = -piv_data_filename_interior.conversion_factor*max(flick_xpiv(:,1))-2*coarsedx-(flick_xlength-min(flick_xlength,return_xlength))/2;
% yshift_piv_data(1) = -piv_data_filename_interior.conversion_factor*max(flick_ypiv(1,:))-2*coarsedy-Nycoarse_shift-(flick_ylength-min(flick_ylength,return_ylength))/2;
% 
% %another way to compute the shift - maybe makes more senese 
% %xshift_piv_data_2(1) = -piv_data_filename_interior.conversion_factor*max(flick_xpiv(:,1))-(flick_xlength-xlength)/2;
% %yshift_piv_data_2(1) = -piv_data_filename_interior.conversion_factor*max(flick_ypiv(1,:))-(flick_ylength-ylength)/2;
% 
% %returndata shift 
% xshift_piv_data(2) = -piv_data_filename_interior.conversion_factor*max(return_xpiv(:,1))-2*coarsedx-(return_xlength-min(flick_xlength,return_xlength))/2;
% yshift_piv_data(2) = -piv_data_filename_interior.conversion_factor*max(return_ypiv(1,:))-2*coarsedy-Nycoarse_shift-(return_ylength-min(flick_ylength,return_ylength))/2;
% 
% %returndata shift 

%for convergence tests this is better to set manually or as set above
% xlength = 2.1250;
% ylength = 1.8750;
% 
% Nx = round(xlength/dx);
% Ny = round(ylength/dy);



% %plotting 
% figure(1) 
% hold on
% plot(piv_data_filename_interior.conversion_factor*flick_xpiv,piv_data_filename_interior.conversion_factor*flick_ypiv,'b*')
% plot(allhairs_center(1,1),allhairs_center(1,2),'r*')
% plot([xLmin,xLmin,xLmax,xLmax,xLmin],[yLmin,yLmax,yLmax,yLmin,yLmin],'k','LineWidth',2)
% %pause
% %close all
% 
% %figure(2)
% %hold on
% %plot(piv_data_filename_interior.conversion_factor*return_xpiv,piv_data_filename_interior.conversion_factor*return_ypiv,'g*')
% %plot(allhairs_center(2,1),allhairs_center(2,2),'r*')
% 
% %figure(3)
% %hold on
% %plot(piv_data_filename_interior.conversion_factor*flick_xpiv,piv_data_filename_interior.conversion_factor*flick_ypiv,'b*')
% %plot(allhairs_center(1,1),allhairs_center(1,2),'r*','MarkerSize',10)
% %plot(piv_data_filename_interior.conversion_factor*return_xpiv-shift_hairs(1),piv_data_filename_interior.conversion_factor*return_ypiv-shift_hairs(2),'go')
% %plot(allhairs_center(2,1)-shift_hairs(1),allhairs_center(2,2)-shift_hairs(2),'ro','MarkerSize',10)
% %plot([xLmin,xLmin,xLmax,xLmax,xLmin],[yLmin,yLmax,yLmax,yLmin,yLmin],'k','LineWidth',2)
% 
% figure(2)
% hold on
% plot(piv_data_filename_interior.conversion_factor*flick_xpiv+xshift_piv_data(1),piv_data_filename_interior.conversion_factor*flick_ypiv+yshift_piv_data(1),'b*')
% plot(allhairs_center(1,1)+xshift_piv_data(1),allhairs_center(1,2)+yshift_piv_data(1),'r*','MarkerSize',10)
% %plot(piv_data_filename_interior.conversion_factor*return_xpiv+xshift_piv_data(2),piv_data_filename_interior.conversion_factor*return_ypiv+yshift_piv_data(2),'go')
% %plot(piv_data_filename_interior.conversion_factor*flick_xpiv+xshift_piv_data(1),piv_data_filename_interior.conversion_factor*flick_ypiv+yshift_piv_data(1),'b*')
% %plot(allhairs_center(2,1)+xshift_piv_data(2),allhairs_center(2,2)+yshift_piv_data(2),'ro','MarkerSize',10)
% plot([xLmin,xLmin,xLmax,xLmax,xLmin]+xshift_piv_data(1),[yLmin,yLmax,yLmax,yLmin,yLmin]+yshift_piv_data(1),'m','LineWidth',2)
% plot([0,0,xlength,xlength,0],[0,ylength,ylength,0,0],'k','LineWidth',2)
% 
% 
% 
% 



