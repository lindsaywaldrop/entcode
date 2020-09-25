function concentration_absorbed_by_hairs()

global ptindex_hairs hairs_c
global c 
 
for i=1:length(ptindex_hairs)
    %tracking how much concentration is absorbed by each point in each hair
    hairs_c{i} = hairs_c{i} + c(ptindex_hairs{i});
    %setting the concentration inside the hairs = 0
    c(ptindex_hairs{i}) = 0; 
end
