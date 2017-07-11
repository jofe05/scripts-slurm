#!/bin/bash

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
sbatch mem.interleave.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-MEM: Penguin"
sbatch mem.interleave.penguin.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-ALN: Batman/Catwoman"
sbatch aln.interleave.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-ALN: Penguin"
sbatch aln.interleave.penguin.sh gcat_set_039_1 5 

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
sbatch bowtie2.interleave.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for Bowtie2: Penguin"
sbatch bowtie2.interleave.penguin.sh gcat_set_039_1 5

echo "Submitting jobs for Snap: Batman/Catwoman"
sbatch snap.interleave.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for Snap: Penguin"
sbatch snap.interleave.penguin.sh gcat_set_039_1 5

echo "Submitting jobs for Novo: Batman/Catwoman"
sbatch novo.interleave.batcat.sh gcat_set_039_1 5

echo "Submitting jobs for Novo: Penguin"
sbatch novo.interleave.penguin.sh gcat_set_039_1 5

#echo "Submitting jobs for Gem: Batman/Catwoman"
#sbatch gem.interleave.batcat.sh gcat_set_039_1 5

#echo "Submitting jobs for Gem: Penguin"
#sbatch gem.interleave.penguin.sh gcat_set_039_1 5

