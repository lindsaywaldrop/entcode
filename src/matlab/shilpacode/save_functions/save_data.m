function save_data(initial)
%function save_data.m 
%input: initial - if this is the first time data is being saved 
%output: 
%saves data 

if (initial == 1) 
  save_initdata(); 
end

save_data_c(initial); 
save_data_hairs_c(initial);