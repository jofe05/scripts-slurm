#!/bin/bash

#file="NIST7086_CGTACTAG_L002_R2_001"
file="gcat_set_039_1"


#!/bin/bash

number_runs=10

#function run
run() {
    number=$1
    shift
    for i in `seq $number`; do
      $@
    done
}



echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.interleave.batcat.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.interleave.penguin.sh $file 1 

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.interleave.batcat.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.interleave.penguin.sh $file 1

echo "Submitting jobs for Snap: Batman/Catwoman"
run $number_runs sbatch snap.interleave.batcat.sh $file 1 

echo "Submitting jobs for Snap: Penguin"
run $number_runs sbatch snap.interleave.penguin.sh $file 1

echo "Submitting jobs for Gem: Batman/Catwoman"
run $number_runs sbatch gem.interleave.batcat.sh $file 1

echo "Submitting jobs for Gem: Penguin"
run $number_runs sbatch gem.interleave.penguin.sh $file 1

