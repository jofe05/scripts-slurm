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





echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.part.batcat.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.part.penguin.sh $file 1 

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.part.batcat_interleave.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.part.penguin_interleave.sh $file 1 

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
run $number_runs sbatch mem.part.batcat_localalloc.sh $file 1 

echo "Submitting jobs for BWA-MEM: Penguin"
run $number_runs sbatch mem.part.penguin_localalloc.sh $file 1 


echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.part.batcat.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.part.penguin.sh $file 1

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.part.batcat_interleave.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.part.penguin_interleave.sh $file 1

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
run $number_runs sbatch bowtie2.part.batcat_localalloc.sh $file 1 

echo "Submitting jobs for Bowtie2: Penguin"
run $number_runs sbatch bowtie2.part.penguin_localalloc.sh $file 1


echo "Submitting jobs for Snap: Batman/Catwoman"
run $number_runs sbatch snap.part.batcat.sh $file 1 

echo "Submitting jobs for Snap: Penguin"
run $number_runs sbatch snap.part.penguin.sh $file 1

echo "Submitting jobs for Snap: Batman/Catwoman"
run $number_runs sbatch snap.part.batcat_interleave.sh $file 1 

echo "Submitting jobs for Snap: Penguin"
run $number_runs sbatch snap.part.penguin_interleave.sh $file 1

echo "Submitting jobs for Snap: Batman/Catwoman"
run $number_runs sbatch snap.part.batcat_localalloc.sh $file 1 

echo "Submitting jobs for Snap: Penguin"
run $number_runs sbatch snap.part.penguin_localalloc.sh $file 1



echo "Submitting jobs for Gem: Batman/Catwoman"
run $number_runs sbatch gem.part.batcat.sh $file 1

echo "Submitting jobs for Gem: Penguin"
run $number_runs sbatch gem.part.penguin.sh $file 1

echo "Submitting jobs for Gem: Batman/Catwoman"
run $number_runs sbatch gem.part.batcat_interleave.sh $file 1

echo "Submitting jobs for Gem: Penguin"
run $number_runs sbatch gem.part.penguin_interleave.sh $file 1

echo "Submitting jobs for Gem: Batman/Catwoman"
run $number_runs sbatch gem.part.batcat_localalloc.sh $file 1

echo "Submitting jobs for Gem: Penguin"
run $number_runs sbatch gem.part.penguin_localalloc.sh $file 1
