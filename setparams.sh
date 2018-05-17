#!/bin/bash

# For loop that will write files
# for i in `seq -f "%04g" 1 10`;
for i in `seq 1 1233`;
do
name1=viz_IB2d${i}
name2=hairinfo${i}
# Writes file to replace line 
awk -v var="$name1" 'NR==42 {$0="piv_data_filename = \47"'"var"'"\47; "} 1' template_params_air.m > params_temp.m
awk -v var="$name2" 'NR==63 {$0="hairs_data_filename = \47"'"var"'"\47; "} 1' params_temp.m > params_$i.m

# Cleans up folder
rm params_temp.m

echo $i

printf -v j "%04d" $i

mv params_$i.m params_$j.m

done
