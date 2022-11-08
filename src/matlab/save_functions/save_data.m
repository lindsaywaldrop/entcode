function save_data(paths, parameters, simulation, initial)
%function save_data.m 
%input: initial - if this is the first time data is being saved 
%output: 
%saves data 

if (initial == 1) 
  save_initdata(paths, parameters, simulation); 
  save_data_c(paths, parameters, simulation, initial); 
end

if (parameters.plot == 1)
  save_data_c(paths, parameters, simulation, initial); 
end

save_data_hairs_c(paths, parameters, simulation, initial);