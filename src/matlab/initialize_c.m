function [parameters, simulation] = initialize_c(paths, parameters, simulation)
%function initialize_c.m 
%input: initc - string stating which initialization is desired
%output: 
%sets c initially

%global c x y xlength ylength
%global far_right_hair
%global cplusx_dbc diffusionrhsbc_flick

[xx,yy] = ndgrid(simulation.x, simulation.y);

if strcmp(parameters.initc,'exp_right')
    x1 = 0.2; 
    x2 = 1.4;
    c_Linf = 4; 
    simulation.c = 1*exp((-c_Linf*((2*(xx-parameters.xlength/2-0.55)/(x2-x1))).^2));
elseif strcmp(parameters.initc,'exp_right_small') %THIS ONE 
    %NOTE THAT THIS IS NOW THE SAME FOR SMALL AND LARGE CASES 
    %width = 1.2;
    %c_Linf = 7; 
    %exp_center = 1.45;
    %c_max = 0.25; 
    
    width = parameters.stinkwidth; 
    %width = 0.05; 
    %%dist_frh = 0.0125;
    %dist_frh = 0.005;
    
    %if parameters.far_right_hair <= 0.005990
    	%exp_center = 0.005990+width/2; %far_right_hair + dist_frh + width/2; 
    %else
		exp_center = parameters.far_right_hair + width/2 + ...
            10*parameters.hairs_data_filename_interior.givenradius; %far_right_hair + dist_frh + width/2; 
	%end
    c_Linf = 7; 
    c_max_constant = parameters.initconc; 
    parameters.c_max = c_max_constant/parameters.ylength; 
    
    simulation.c = ((xx >= exp_center-width/2)&(xx <= exp_center+width/2)).*parameters.c_max.*exp((-c_Linf*((2*(xx-exp_center)/width)).^2));
    parameters.c_max
    parameters.c_total = sum(sum(simulation.c));
    simulation.c_total = parameters.c_total;
    parameters.c_total
    
    parameters.cplusx_dbc = 0; 
    parameters.diffusionrhsbc_flick = 'noflux'; 
elseif strcmp(parameters.initc,'exp_right_small_v2') %THIS ONE 
    %NOTE THAT THIS IS NOW THE SAME FOR SMALL AND LARGE CASES 
    %width = 1.2;
    %c_Linf = 7; 
    %exp_center = 1.45;
    %c_max = 0.25; 
    
    width = 0.1; 
    xlength_air = 1.240234375000000;
    %%dist_frh = 0.0125;
    %dist_frh = 0.005;
    
    exp_center = parameters.far_right_hair+width/2; %far_right_hair + dist_frh + width/2; 
    c_Linf = 7; 
    c_max_constant = 0.1; 
    aa = sqrt(pi)*erf(sqrt(c_Linf))/4/sqrt(c_Linf);
    bb = xlength_air-exp_center+0.06*20;
    %c_max = (c_max_constant/ylength)*(bb/0.1/aa+1)/2/2;
    parameters.c_max = (c_max_constant/parameters.ylength)*(bb/0.1/aa+1)/2;
    
    simulation.c = ((xx >= exp_center-width/2)&(xx <= exp_center+width/2)).*parameters.c_max.*exp((-c_Linf*((2*(xx-exp_center)/width)).^2));
    parameters.c_max
    parameters.c_total = sum(sum(simulation.c));
    parameters.c_total
    
    parameters.cplusx_dbc = 0; 
    parameters.diffusionrhsbc_flick = 'noflux'; 
    
elseif strcmp(parameters.initc,'exp_right_small_smdom') %THIS ONE 
    %NOTE THAT THIS IS NOW THE SAME FOR SMALL AND LARGE CASES 
    %width = 1.2;
    %c_Linf = 7; 
    %exp_center = 1.45;
    %c_max = 0.25; 
    
    parameters.stinkwidth = width; 
    %%dist_frh = 0.0125;
    %dist_frh = 0.005;
    
    exp_center = parameters.far_right_hair+width/2; %far_right_hair + dist_frh + width/2; 
    c_Linf = 7; 
    c_max_constant = 0.1; 
    parameters.c_max = c_max_constant/parameters.ylength; 
    
    simulation.c = ((xx >= exp_center-width/2)&(xx <= exp_center+width/2)).*parameters.c_max.*exp((-c_Linf*((2*(xx-exp_center)/width)).^2));
    parameters.c_max
    max(max(simulation.c))
    
    parameters.cplusx_dbc = 0; 
    parameters.diffusionrhsbc_flick = 'noflux'; 
    
elseif strcmp(parameters.initc,'exp_right_large') %THIS ONE - NOT USING THIS ONE  
    %width = 0.12;
    %c_Linf = 7; 
    %exp_center = 0.145;
    %c_max = 0.25; 
    
    width = 0.1; 
    dist_frh = 0.0125;
    exp_center = parameters.far_right_hair + dist_frh + width/2; 
    c_Linf = 7; 
    c_max_constant = 0.1; 
    parameters.c_max = c_max_constant/parameters.ylength; 
    
    simulation.c = ((xx >= exp_center-width/2)&(xx <= exp_center+width/2)).*parameters.c_max.*exp((-c_Linf*((2*(xx-exp_center)/width)).^2));  
    parameters.c_max
    max(max(simulation.c))
    
    parameters.cplusx_dbc = 0;
    parameters.diffusionrhsbc_flick = 'noflux'; 
    

else
    error('initc is not a valid choice!');
end
 
%c = cos(xx*pi) + 1;     
%C = exp(-(2*pi*xx-pi).^2) + exp(-(2*pi*yy-pi).^2); 
%C = exp(-(xx-pi).^2) + exp(-(yy-pi).^2); 
%C = exp(-(xx-pi).^2).*(1+cos(yy)); 
%C = cos(yy) + 1; 
%C = exp(-(xx-pi).^2);
