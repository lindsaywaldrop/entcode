function [p] = generate_grid2d(GtD,dist,theta,setn,np,N)
% Generates grid for use with Constraint IB Method IBAMR
%
% GtD = gap to diameter ratio between hairs
% dist = distance from antennule
% theta = angle of center hair with positive x-axis
%
%

% Sets initial parameters
L = 2.0;                            % length of computational domain (m)
%N = 4096;                            % number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = 1*L/N                           % Cartesian mesh width (m)
% Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
%        vertex pts too far apart: flow thru boundary, too close: numerical weirdness
NFINEST = 5;  % NFINEST = 4 corresponds to a uniform grid spacing of h=1/64

hdia = 0.01;     % Diameter of hair
adia = 0.1;     % Diameter of flagellum
p.hdia=hdia;

theta = (theta/180)*pi;      % Angle off positive x-axis in radians
%GtD = 1.1;      % Gap width to diameter ratio
%dist = 0.1;     % Distance between antennule and hair 
mindGap = 0.5*adia+0.5*hdia+dist;  % Calculate distance between hair centers
width = GtD*hdia+hdia;
p.width=width;

hair1Centerx = mindGap*cos(theta);
hair1Centery = mindGap*sin(theta);
p.hair1Centerx = hair1Centerx;
p.hair1Centery = hair1Centery;

hair2Centerx = hair1Centerx-width*sin(theta)
hair2Centery = hair1Centery+width*cos(theta)
p.hair2Centerx = hair2Centerx;
p.hair2Centery = hair2Centery;

hair3Centerx = hair1Centerx+width*sin(theta)
hair3Centery = hair1Centery-width*cos(theta)
p.hair3Centerx = hair3Centerx;
p.hair3Centery = hair3Centery;

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

% Generate grid of points


x_grid = linspace(-L,L,np*L/dx);
y_grid = linspace(-L,L,np*L/dx);
[gridpts_x,gridpts_y] = meshgrid(x_grid,y_grid);

% Antennule
aN = round((adia*pi)/dx)+1;
[aH,xa,ya] = circle([0,0],0.5*adia,aN,'.');
hold on
xlim([-0.5*L,0.5*L])
ylim([-0.5*L,0.5*L])

antIn = inpolygon(gridpts_x,gridpts_y,xa,ya);

ant_x = gridpts_x(antIn);
ant_y = gridpts_y(antIn);

plot(ant_x,ant_y,'.')



% Step 4: Write out the beam point information
% beam_fid = fopen(['ant_2d_' num2str(N) '_' num2str(setn) '.beam'], 'w');
% 
% baN = aN;
% 
% fprintf(beam_fid, '%d\n', baN+1);
% 
% for s = 0:baN-3
%    fprintf(beam_fid, '%d %d %d %1.16e\n', s, s+1, s+2, kappa_target);
% end
% 
% fprintf(beam_fid, '%d %d %d %1.16e\n', baN-3, baN-2, 0, kappa_target);
% fprintf(beam_fid, '%d %d %d %1.16e\n', baN-2, baN-1, 0, kappa_target);
% fprintf(beam_fid, '%d %d %d %1.16e\n', baN-1, 0, 1, kappa_target);
% 
% fclose(beam_fid);


% Hair 1 (center)
hN = round((hdia*pi)/dx)+1;
[hH1,xh1,yh1] = circle([hair1Centerx,hair1Centery],0.5*hdia,hN,'.');

h1In = inpolygon(gridpts_x,gridpts_y,xh1,yh1);

h1_x = gridpts_x(h1In);
h1_y = gridpts_y(h1In);

plot(h1_x,h1_y,'.')

p.h1_x = h1_x;
p.h1_y = h1_y;

% Hair 2 (top)
[hH2,xh2,yh2] = circle([hair2Centerx,hair2Centery],0.5*hdia,hN,'.');

h2In = inpolygon(gridpts_x,gridpts_y,xh2,yh2);

h2_x = gridpts_x(h2In);
h2_y = gridpts_y(h2In);

plot(h2_x,h2_y,'.')

p.h2_x = h2_x;
p.h2_y = h2_y;


% Hair 3 (bottom)
[hH3,xh3,yh3] = circle([hair3Centerx,hair3Centery],0.5*hdia,hN,'.');

h3In = inpolygon(gridpts_x,gridpts_y,xh3,yh3);

h3_x = gridpts_x(h3In);
h3_y = gridpts_y(h3In);

plot(h3_x,h3_y,'.')

p.h3_x = h3_x;
p.h3_y = h3_y;



hold off


% Write out vertex points

%vertex_fid = fopen('hairs.vertex', 'w');
vertex_fid = fopen(['hairs',num2str(setn),'.vertex'], 'w');

totpoints = length(ant_x)+length(h1_x)+length(h2_x)+length(h3_x)

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', totpoints);
% Step 2: Write out the vertex information
for j = 1:length(ant_x)
  fprintf(vertex_fid, '%1.16e %1.16e\n', ant_x(j), ant_y(j));
end

for j = 1:length(h1_x)
  fprintf(vertex_fid, '%1.16e %1.16e\n', h1_x(j), h1_y(j));
end

for j = 1:length(h2_x)
  fprintf(vertex_fid, '%1.16e %1.16e\n', h2_x(j), h2_y(j));
end

for j = 1:length(h3_x)
  fprintf(vertex_fid, '%1.16e %1.16e\n', h3_x(j), h3_y(j));
end
%end
%hold off
fclose(vertex_fid);


% Step 3: Write out the target point information
% target_fid = fopen(['ant_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');
% 
% fprintf(target_fid, '%d\n', length(ant_x));
% 
% for s = 0:length(ant_x)-1
%    fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
% end
% 
% fclose(target_fid);
% 
% 
% 
% target_fid = fopen(['hair1_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');
% 
% fprintf(target_fid, '%d\n', length(h1_x));
% 
% for s = 0:length(h1_x)-1
%    fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
% end
% 
% fclose(target_fid);
% 
% target_fid = fopen(['hair2_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');
% 
% fprintf(target_fid, '%d\n', length(h2_x));
% 
% for s = 0:length(h2_x)-1
%    fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
% end
% 
% fclose(target_fid);
% 
% 
% target_fid = fopen(['hair3_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');
% 
% fprintf(target_fid, '%d\n', length(h3_x));
% 
% for s = 0:length(h3_x)-1
%    fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
% end
% 
% fclose(target_fid);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



