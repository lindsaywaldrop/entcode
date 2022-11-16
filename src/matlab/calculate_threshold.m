function [total_captured_new, new_capture] = calculate_threshold(total_captured_old, simulation)

this_step = 0;

for k = 1:length(simulation.ptindex_hairs)
    this_step = this_step + sum(simulation.c(simulation.ptindex_hairs{k}));
end

total_captured_new = total_captured_old + this_step;

new_capture = (total_captured_new - total_captured_old)/(simulation.dt);
