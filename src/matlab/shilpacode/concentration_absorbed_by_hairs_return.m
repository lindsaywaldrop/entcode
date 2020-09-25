function concentration_absorbed_by_hairs_return()

global return_ptindex_hairs return_hairs_c
global c 
 
for i=1:length(return_ptindex_hairs)
    %tracking how much concentration is absorbed by each point in each hair
    return_hairs_c{i} = return_hairs_c{i} + c(return_ptindex_hairs{i});
    %setting the concentration inside the hairs = 0
    c(return_ptindex_hairs{i}) = 0; 
end

