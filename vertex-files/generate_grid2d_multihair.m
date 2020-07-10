function [p] = generate_grid2d_multihair(GtD,setn,numHairs)
% Generates grid for use with Constraint IB Method IBAMR
%
% GtD = gap to diameter ratio between hairs
% dist = distance from antennule
% theta = angle of center hair with positive x-axis
%
%

hdia = 0.01;     % Diameter of hair
adia = 0.1;     % Diameter of flagellum
p.hdia=hdia;

width = GtD*hdia+hdia;
p.width=width;

hairData=readmatrix(['hairs',num2str(setn),'.csv']);
hairVertices=readmatrix(['hairs',num2str(setn),'.vertex'],'FileType','text');

ant=hairData(1,1);
n=0;
for j=1:numHairs
    eval(['p.hair',num2str(j),'Centerx = hairData(2,',num2str(j+1),');']);
    eval(['p.hair',num2str(j),'Centery = hairData(3,',num2str(j+1),');']);
    for k=1:hairData(1,j+1)
        n=n+1;
        eval(['p.h',num2str(j),'_x(',num2str(k),',1) = hairVertices(',num2str(ant+n),',1);']);
        eval(['p.h',num2str(j),'_y(',num2str(k),',1) = hairVertices(',num2str(ant+n),',2);']);
    end
end







