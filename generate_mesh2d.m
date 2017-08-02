function [p] = generate_mesh2d(GtD,dist,theta,setn)
% Sets initial parameters
L = 0.5;                            % length of computational domain (m)
N = 512;                            % number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = (L/N)/(3)                           % Cartesian mesh width (m)
% Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
%        vertex pts too far apart: flow thru boundary, too close: numerical weirdness
NFINEST = 64;  % NFINEST = 4 corresponds to a uniform grid spacing of h=1/64

hdia = 0.01;     % Diameter of hair
adia = 0.1;     % Diameter of flagellum

theta = (theta/180)*pi;      % Angle off positive x-axis in radians
%GtD = 1.1;      % Gap width to diameter ratio
%dist = 0.1;     % Distance between antennule and hair 
mindGap = 0.5*adia+0.5*hdia+dist;  % Calculate distance between hair centers
width = GtD*hdia+hdia;

hair1Centerx = mindGap*cos(theta);
hair1Centery = mindGap*sin(theta);

hair2Centerx = hair1Centerx-width*sin(theta);
hair2Centery = hair1Centery+width*cos(theta);

hair3Centerx = hair1Centerx+width*sin(theta);
hair3Centery = hair1Centery-width*cos(theta);

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

% Antennule
aN = round((adia*pi)/dx)+1;
[aH,xa,ya] = circle([0,0],0.5*adia,aN,'.');
hold on
xlim([-L,L])
ylim([-L,L])

vertex_fid = fopen(['ant_2d_' num2str(N) '_' num2str(setn) '.vertex'], 'w');

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', aN);
% Step 2: Write out the vertex information
for j = 1:aN
  fprintf(vertex_fid, '%1.16e %1.16e\n', xa(j), ya(j));
end
%end
%hold off
fclose(vertex_fid);

% Step 3: Write out the target point information
target_fid = fopen(['ant_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');

fprintf(target_fid, '%d\n', aN);

for s = 0:aN-1
   fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
end

fclose(target_fid);

% Step 4: Write out the beam point information
beam_fid = fopen(['ant_2d_' num2str(N) '_' num2str(setn) '.beam'], 'w');

baN = aN;

fprintf(beam_fid, '%d\n', baN+1);

for s = 0:baN-3
   fprintf(beam_fid, '%d %d %d %1.16e\n', s, s+1, s+2, kappa_target);
end

fprintf(beam_fid, '%d %d %d %1.16e\n', baN-3, baN-2, 0, kappa_target);
fprintf(beam_fid, '%d %d %d %1.16e\n', baN-2, baN-1, 0, kappa_target);
fprintf(beam_fid, '%d %d %d %1.16e\n', baN-1, 0, 1, kappa_target);

fclose(beam_fid);


% Hair 1 (center)
hN = round((hdia*pi)/dx)+1;
[hH1,xh1,yh1] = circle([hair1Centerx,hair1Centery],0.5*hdia,hN,'.');

vertex_fid = fopen(['hair1_2d_' num2str(N) '_' num2str(setn) '.vertex'], 'w');

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', hN);
% Step 2: Write out the vertex information
for j = 1:hN
  fprintf(vertex_fid, '%1.16e %1.16e\n', xh1(j), yh1(j));
end
%end
%hold off
fclose(vertex_fid);

% Step 3: Write out the target point information
target_fid = fopen(['hair1_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');

fprintf(target_fid, '%d\n', hN);

for s = 0:hN-1
   fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
end

fclose(target_fid);



% Hair 2 (top)
[hH2,xh2,yh2] = circle([hair2Centerx,hair2Centery],0.5*hdia,hN,'.');

vertex_fid = fopen(['hair2_2d_' num2str(N) '_' num2str(setn) '.vertex'], 'w');

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', hN);
% Step 2: Write out the vertex information
for j = 1:hN
  fprintf(vertex_fid, '%1.16e %1.16e\n', xh2(j), yh2(j));
end
%end
%hold off
fclose(vertex_fid);

% Step 3: Write out the target point information
target_fid = fopen(['hair2_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');

fprintf(target_fid, '%d\n', hN);

for s = 0:hN-1
   fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
end

fclose(target_fid);


% Hair 3 (bottom)
[hH3,xh3,yh3] = circle([hair3Centerx,hair3Centery],0.5*hdia,hN,'.');

vertex_fid = fopen(['hair3_2d_' num2str(N) '_' num2str(setn) '.vertex'], 'w');

% first line is the number of vertices in the file
fprintf(vertex_fid, '%d\n', hN);
% Step 2: Write out the vertex information
for j = 1:hN
  fprintf(vertex_fid, '%1.16e %1.16e\n', xh3(j), yh3(j));
end
%end
%hold off
fclose(vertex_fid);

% Step 3: Write out the target point information
target_fid = fopen(['hair3_2d_' num2str(N) '_' num2str(setn) '.target'], 'w');

fprintf(target_fid, '%d\n', hN);

for s = 0:hN-1
   fprintf(target_fid, '%d %1.16e\n', s, kappa_target*dx/(dx^2));
end

fclose(target_fid);

hold off

p=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



