#!/bin/bash

cd scalability
sbatch hip_mem.normal.batcat.sh gcat_set_039_1 1 

cd ../interleave
sbatch hip_mem.interleave.batcat.sh gcat_set_039_1 1

cd ../locality
sbatch hip_mem.locality.batcat.sh gcat_set_039_1 1 

cd ../localloc
sbatch hip_mem.locality.batcat.sh gcat_set_039_1 1


