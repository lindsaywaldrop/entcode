%make_hairs.m
clear all
close all
load('hermit_hairs.mat');
load('ant.mat');
%load('model.mat');
model.x = ant.x;
model.y = ant.y;

L = 0.1;                            % length of computational domain (m)
N = 512;                            % number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = (L/N)/(2);                           % Cartesian mesh width (m)
% Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
%        vertex pts too far apart: flow thru boundary, too close: numerical weirdness

NFINEST = 64;  % NFINEST = 4 corresponds to a uniform grid spacing of h=1/64


%dx = L/(16*1.5*NFINEST);
% 
% num_nodesh = ceil(perimh/(0.5*dx)/4)*4+1;
% num_nodese = ceil(perime/(0.5*dx)/4)*4+1;
% num_nodes = num_nodesh + 2*num_nodese + 1;
%tapered_stiffness = false;
%stiffness = 1.0/num_layers;
kappa_target = 1.0e-2;        % target point penalty spring constant (Newton)
% This is the spring stiffness between the target points and vertex points. The stiffness between
%          the points is inversely proportional to the number of target/vertex points, so use
%          the minimum value of stiffness you can to reduce computational time.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All of the Hairs  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
num = length(hairs);

for k = 1:num % Loop calculates points and writes files for each hair.

clear points

num_nodes = length(hairs(1,k).x);
n = 0;
perim_total = 0;
% Step 1: create the points.
for i = 2:num_nodes
    clear perim
    clear numpts
    x1 = hairs(1,k).x(i-1,1);
    y1 = hairs(1,k).y(i-1,1);
    x2 = hairs(1,k).x(i,1);
    y2 = hairs(1,k).y(i,1);
    perim = abs(pdist([x1 y1;x2 y2],'euclidean'));
    perim_total = perim_total+perim;
    
    numpts=ceil(perim/dx)
    n = numpts+n;
    points(1,i-1).x = linspace(x1,x2,numpts);
    points(1,i-1).y = linspace(y1,y2,numpts);
    
end
perim_total = perim_total + abs(pdist([hairs(1,k).x(1,1) hairs(1,k).y(1,1);hairs(1,k).x(end,1) hairs(1,k).y(end,1)],'euclidean'))
n


vertex_fid = fopen(['hair',num2str(k),'_2d_' num2str(N) '.vertex'], 'w');

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', n);
hold on
% Step 2: Write out the vertex information
for l = 1:num_nodes-1
    plot(points(1,l).x,points(1,l).y,'r.-')
    for j = 1:length(points(1,l).x-1)
    fprintf(vertex_fid, '%1.16e %1.16e\n', points(1,l).x(j), points(1,l).y(j));
    end
end
%end
%hold off
fclose(vertex_fid);

% Step 3: Write out the target point information
target_fid = fopen(['hair',num2str(k),'_2d_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', n);

ds = perim_total/(n-1);

for s = 0:n-1
   fprintf(target_fid, '%d %1.16e\n', s, kappa_target*ds/(ds^2));
end

fclose(target_fid);

end



%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Antennule 
%

clear points

num_nodes = length(model.x);
n = 0;
perim_total = 0;
% Step 1: create the points.
for i = 2:num_nodes
    clear perim
    clear numpts
    x1 = model.x(i-1,1);
    y1 = model.y(i-1,1);
    x2 = model.x(i,1);
    y2 = model.y(i,1);
    perim = abs(pdist([x1 y1;x2 y2],'euclidean'));
    perim_total = perim_total+perim;
    
    numpts=ceil(perim/dx)
    n = numpts+n;
    points(1,i-1).x = linspace(x1,x2,numpts);
    points(1,i-1).y = linspace(y1,y2,numpts);
    
end
perim_total = perim_total + abs(pdist([model.x(1,1) model.y(1,1);model.x(end,1) model.y(end,1)],'euclidean'))
n

    clear perim
    clear numpts
    x1 = model.x(i,1);
    y1 = model.y(i,1);
    x2 = model.x(1,1);
    y2 = model.y(1,1);
    perim = abs(pdist([x1 y1;x2 y2],'euclidean'));
    perim_total = perim_total+perim;
    
    numpts=ceil(perim/dx)
    n = numpts+n;
    points(1,i).x = linspace(x1,x2,numpts);
    points(1,i).y = linspace(y1,y2,numpts);


vertex_fid = fopen(['ant_2d_' num2str(N) '.vertex'], 'w');

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', n);
hold on
% Step 2: Write out the vertex information
for l = 1:num_nodes-1
    plot(points(1,l).x,points(1,l).y,'k.-')
    for j = 1:length(points(1,l).x-1)
    fprintf(vertex_fid, '%1.16e %1.16e\n', points(1,l).x(j), points(1,l).y(j));
    end
end

fclose(vertex_fid);


% Step 3: Write out the target point information
target_fid = fopen(['ant_2d_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', n);

ds = perim_total/(n-1);

for s = 0:n-1
   fprintf(target_fid, '%d %1.16e\n', s, kappa_target*ds/(ds^2));
end

fclose(target_fid);
%end
%hold off


% center = [-0.0187,0.005987];
% xr = 0.0366*1.5/2;
% yr = 0.0217*1.5/2;
% length = 2*pi; %Length of the space curve segment.
% 
% t = 0:dx:length; % sets up values of t for plotting the full space curve segment.
% 
% % Calulates coordinates for plotting space curve and estimates based on
% % parametric equations for the space curve.
% 
% x = xr.*cos(t)+center(1,1);
% y = yr.*sin(t)+center(1,2);
% plot(x,y,'go')
