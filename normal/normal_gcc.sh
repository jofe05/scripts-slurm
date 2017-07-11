#!/bin/bash

#file="NIST7086_CGTACTAG_L002_R2_001"
file="gcat_set_039_1"


#!/bin/bash

number_runs=1

#function run
run() {
    number=$1
    shift
    for i in `seq $number`; do
      $@
    done
}



echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.normal.batcat.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
# run $number_runs sbatch mem.normal.penguin.sh $file 1 


