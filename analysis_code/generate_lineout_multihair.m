function [p,l]=generate_lineout(dist,theta)

% Sets initial parameters
L = 2.0;                            % length of computational domain (m)

hdia = 0.01;     % Diameter of hair
adia = 0.1;     % Diameter of flagellum

theta = (theta/180)*pi;      % Angle off positive x-axis in radians
%GtD = 1.1;      % Gap width to diameter ratio
%dist = 0.1;     % Distance between antennule and hair 
mindGap = 0.5*adia+0.5*hdia+dist;  % Calculate distance between hair centers
width = 1.0;

hair1Centerx = mindGap*cos(theta);
hair1Centery = mindGap*sin(theta);

p.endx = hair1Centerx-width*sin(theta);
p.endy = hair1Centery+width*cos(theta);

p.startx = hair1Centerx+width*sin(theta);
p.starty = hair1Centery-width*cos(theta);

plot(hair1Centerx,hair1Centery)
hold on
plot([p.startx,p.endx],[p.starty,p.endy])

l=sqrt((p.endx-p.startx)^2+(p.endy-p.starty)^2)
end
