#!/bin/bash

repeats=1
number_runs=2
file="gcat_set_039_1"
#file="NIST7086_CGTACTAG_L002_R2_001"

 
#function run
run() {
    number=$1
    shift
    for i in `seq $number`; do
      $@
    done
}


echo "Submitting NOVO on BATCAT: "
run $number_runs sbatch novo2.part.batcat.sh $file $repeats

echo "Submitting NOVO on PENGUIN: "
run $number_runs sbatch novo2.part.penguin.sh $file $repeats



