% generate_analysis_input.m

data = load('HairArray_para_1233.dat');

%handle the data
angle = data(:,1);

% Generate hair files
vertex_fid = fopen('lineout_analysis.txt', 'w');

for i = 1:size(data,1)
    
   [p,l] = generate_lineout(0.02,angle(i));
   fprintf(vertex_fid, '%i\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n', i, p.startx, p.starty, p.endx, p.endy);
    
end
fclose(vertex_fid);


