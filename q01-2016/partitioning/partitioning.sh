#!/bin/bash

repeats=1
number_runs=5
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

 
#echo "Submitting ALN on BATCAT: "
#run $number_runs sbatch aln.part.batcat.sh $file $repeats

#echo "Submitting ALN on PENGUIN: "
#run $number_runs sbatch aln.part.penguin.sh $file $repeats

echo "Submitting MEM on BATCAT: "

run $number_runs sbatch mem.part.batcat.sh $file $repeats

echo "Submitting MEM on PENGUIN: "
run $number_runs sbatch mem.part.penguin.sh $file $repeats

#echo "Submitting BOWTIE2 on BATCAT: "
#run $number_runs sbatch bowtie2.part.batcat.sh $file $repeats

#echo "Submitting BOWTIE2 on PENGUIN: "
#run $number_runs sbatch bowtie2.part.penguin.sh $file $repeats

#echo "Submitting GEM on BATCAT: "
#run $number_runs sbatch gem.part.batcat.sh $file $repeats

#echo "Submitting GEM on PENGUIN: "
#run $number_runs sbatch gem.part.penguin.sh $file $repeats

#echo "Submitting GEM on BATCAT  - Interleave: "
#run $number_runs sbatch gem2.part.batcat.sh $file $repeats

#echo "Submitting GEM on PENGUIN - Interleave: "
#run $number_runs sbatch gem2.part.penguin.sh $file $repeats

#echo "Submitting SNAP on BATCAT: "
#run $number_runs sbatch snap.part.batcat.sh $file $repeats

#echo "Submitting SNAP on PENGUIN: "
#run $number_runs sbatch snap.part.penguin.sh $file $repeats

#echo "Submitting SNAP on BATCAT - Interleave: "
#run $number_runs sbatch snap2.part.batcat.sh $file $repeats

#echo "Submitting SNAP on PENGUIN - Interleave: "
#run $number_runs sbatch snap2.part.penguin.sh $file $repeats

#echo "Submitting NOVO on BATCAT: "
#run $number_runs sbatch novo2.part.batcat.sh $file $repeats

#echo "Submitting NOVO on PENGUIN: "
#run $number_runs sbatch novo2.part.penguin.sh $file $repeats



