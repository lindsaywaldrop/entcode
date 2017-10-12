function [p,c,l]=generate_lineout(GtD,dist,theta)

% Sets initial parameters
L = 2.0;                            % length of computational domain (m)

hdia = 0.01;     % Diameter of hair
adia = 0.1;     % Diameter of flagellum

theta = (theta/180)*pi;      % Angle off positive x-axis in radians
%GtD = 1.1;      % Gap width to diameter ratio
%dist = 0.1;     % Distance between antennule and hair 
mindGap = 0.5*adia+0.5*hdia+dist;  % Calculate distance between hair centers
width = 1.0;
gapwidth = GtD*hdia+hdia;

c.hair1x = mindGap*cos(theta);
c.hair1y = mindGap*sin(theta);

c.hair2x = c.hair1x-gapwidth*sin(theta);
c.hair2y = c.hair1y+gapwidth*cos(theta);

c.hair3x = c.hair1x+gapwidth*sin(theta);
c.hair3y = c.hair1y-gapwidth*cos(theta);

p.endx = c.hair1x-width*sin(theta);
p.endy = c.hair1y+width*cos(theta);

p.startx = c.hair1x+width*sin(theta);
p.starty = c.hair1y-width*cos(theta);

c.gapwidth = gapwidth;

plot(c.hair1x,c.hair1y)
hold on
plot([p.startx,p.endx],[p.starty,p.endy])

l=sqrt((p.endx-p.startx)^2+(p.endy-p.starty)^2)
end
