%script run_crabs.m 
%calls crabs.m and allows us to run many different parameters files at once 

clear all
close all

filenumbers{1} = '0300';
%filenumbers{2} = '0304'; 
%filenumbers{3} = '0086'; 
%filenumbers{4} = '0087'; 
%filenumbers{5} = '0071'; 
%filenumbers{6} = '0076'; 
%filenumbers{7} = '0077'; 
%filenumbers{8} = '0078'; 
%filenumbers{9} = '0079'; 
%filenumbers{10} = '0073'; 
%filenumbers{11} = '0074';
%filenumbers{12} = '0075';
% filenumbers{13} = '0013';
% filenumbers{14} = '0014'; 
% filenumbers{15} = '0015'; 
% filenumbers{16} = '0016'; 
%filenumbers{17} = '3039'; 
%filenumbers{17} = '0285'; 
%filenumbers{18} = '0286';
%filenumbers{19} = '0291'; 
%filenumbers{20} = '0292';
%filenumbers{21} = '0293'; 
%filenumbers{22} = '0294'; 
%filenumbers{23} = '0295'; 
%filenumbers{24} = '0296';
%filenumbers{25} = '0294'; 
%filenumbers{26} = '0295'; 
%filenumbers{27} = '0296';
%filenumbers{28} = '0297';
%filenumbers{29} = '0268';

format long
for i=1:length(filenumbers)
  save filenumbersfile i filenumbers
  clear all
  load filenumbersfile
  delete filenumbersfile.mat
  tic
  crabs(filenumbers{i}) 
  toc
end





