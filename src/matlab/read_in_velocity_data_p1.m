function read_in_velocity_data_p1(dl)
%function read_in_velocity_data_p1.m 
%input: 
%output: 
%sets xlength and ylength based on the experimental piv data

%this function sets it so that the computational 
%domain for c sits inside the piv exp data

%NOTES: SK 2017_11_16
%COMMENTED ALL RETURN STUFF OUT 

global xlength ylength Nx Ny dx dy pathbase_piv
global piv_data_filename piv_data_filename_interior
global xshift_piv_data yshift_piv_data
global Nxcoarse 

strcat(pathbase_piv,piv_data_filename,'.mat')

%filenames
flickdata = load([pathbase_piv piv_data_filename '.mat']);

%finding the endpts for x_length and y_length (data is in m) 
flick_xpiv = eval(['flickdata.' piv_data_filename_interior.x]);     
flick_ypiv = eval(['flickdata.' piv_data_filename_interior.y]);


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

%setting x_length and y_length 

xlength = xLmax - xLmin; 
ylength = yLmax - yLmin; 


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




