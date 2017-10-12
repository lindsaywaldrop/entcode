% makehairs.m

data = load('HairArray_para_1233.dat');

%handle the data

Gap = data(:,2);
angle = data(:,1);

% Generate hair files

for i = 1:size(data,1)
 
   [p] = generate_grid2d(Gap(i),0.02,angle(i),i);
    
end
