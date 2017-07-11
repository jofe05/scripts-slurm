#!/bin/bash

file="NIST7086_CGTACTAG_L002_R2_001"
#file="gcat_set_039_1"

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





#### HYBRID_x2 ####
echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.part.batcat_x2.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.part.penguin_x2.sh $file 1 

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.part.batcat_interleave_x2.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.part.penguin_interleave_x2.sh $file 1 

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.part.batcat_localalloc_x2.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.part.penguin_localalloc_x2.sh $file 1 



#### HYBRID_x2 ####
echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.part.batcat_x2.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.part.penguin_x2.sh $file 1

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.part.batcat_interleave_x2.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.part.penguin_interleave_x2.sh $file 1

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.part.batcat_localalloc_x2.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.part.penguin_localalloc_x2.sh $file 1



