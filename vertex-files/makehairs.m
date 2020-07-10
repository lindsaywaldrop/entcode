% makehairs.m

data = load('HairArray_para_1233.dat');

%handle the data

Gap = data(:,2);
angle = data(:,1);

% Generate hair files

%for i = 1:size(data,1)
% for i = 1:8
% %i=749; 
%    [p] = generate_grid2d(Gap(i),0.02,angle(i),i,3,4096);
%     save(['hairinfo',num2str(i),'.mat'],'p')
% end


for i = 1:8
%i=1; 
   [p] = generate_grid2d_multihair(Gap(i),i,8);
    save(['hairinfo',num2str(i),'.mat'],'p')
end