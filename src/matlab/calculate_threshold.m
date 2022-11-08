function [total_captured_new, new_capture] = calculate_threshold(total_captured_old, simulation)

this_step = 0;
total_captured_old = total_captured_old/simulation.c_total;

for k = 1:length(simulation.ptindex_hairs)
    this_step = this_step + sum(simulation.hairs_c{k})/simulation.c_total;
end

total_captured_new = total_captured_old + this_step;

new_capture = (total_captured_new - total_captured_old)/(simulation.dt);
