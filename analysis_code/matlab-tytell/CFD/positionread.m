function [posx, posy] = positionread(path_name2,k)
      
fileID = fopen([path_name2 num2str(k)]);
C=textscan(fileID,'%f','HeaderLines',3,'delimiter',' ','commentstyle','P'); %Scans the file for numbers (skipping 'Processor' lines) and puts them in a cell called C
A=C{1}; %Converts cell C to matrix A
%division by two of the force corrects for factor of two error
%in IBAMR
posx=(A(1:2:end));  %This is the horizontal force (odd numbered entries in vector C)
posy=(A(2:2:end)); %This is the vertical force (even numbered entries in vector C)
fclose(fileID);
clear A
clear C


  



