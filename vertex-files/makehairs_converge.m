% makehairs.m


%handle the data
N=4096;
numPts = [0.5,1,2,3,4,5];
% Generate hair files

for i = 1:size(numPts,2)
 
   [p] = generate_grid2d(10,0.02,0,i,numPts(i),N);
    
end
