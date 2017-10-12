% generate_analysis_input.m

data = load('HairArray_para_1233.dat');

%handle the data
angle = data(:,1);
Gap = data(:,2);

% Generate hair files
vertex_fid = fopen('lineout_analysis.txt', 'w');

for i = 1:size(data,1)
    
   [p,c,l] = generate_lineout(Gap(i),0.02,angle(i));
   fprintf(vertex_fid, '%i\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n', ...
       i, p.startx, p.starty, p.endx, p.endy, ...
       c.hair1x, c.hair1y, c.hair2x, c.hair2y, c.hair3x, c.hair3y, c.gapwidth);
    
end
fclose(vertex_fid);


