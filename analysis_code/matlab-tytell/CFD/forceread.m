function [fx, fy] = forceread(path_name2,k)

%this function takes the path name and the number of time steps and returns
%vectors holding the forces in the x and y directions along the boundary

fileID = fopen([path_name2 num2str(k)]);
C=textscan(fileID,'%f','HeaderLines',3,'delimiter',' ','commentstyle','P'); %Scans the file for numbers (skipping 'Processor' lines) and puts them in a cell called C
A=C{1}; %Converts cell C to matrix A
%division by two of the force corrects for factor of two error
%in IBAMR
fx=(A(1:2:end));  %This is the horizontal force (odd numbered entries in vector C)
fy=(A(2:2:end)); %This is the vertical force (even numbered entries in vector C)
fclose(fileID);
clear A
clear C


  



