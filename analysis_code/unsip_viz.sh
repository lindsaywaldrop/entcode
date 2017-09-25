#!/bin/bash


for i in `seq 1 1233`; do 
test -d viz_IB2d${i} && echo "File found" || echo "File ${i} not found."
#test -f viz_IB2d${i}.zip && echo "File found" || echo "File ${i} no found."
done