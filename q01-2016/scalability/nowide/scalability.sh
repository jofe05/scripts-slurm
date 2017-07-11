#!/bin/bash

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
sbatch mem.normal.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-MEM: Penguin"
sbatch mem.normal.penguin.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-ALN: Batman/Catwoman"
sbatch aln.normal.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-ALN: Penguin"
sbatch aln.normal.penguin.sh gcat_set_039_1 5 

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
sbatch bowtie2.normal.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for Bowtie2: Penguin"
sbatch bowtie2.normal.penguin.sh gcat_set_039_1 5

echo "Submitting jobs for Snap: Batman/Catwoman"
sbatch snap.normal.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for Snap: Penguin"
sbatch snap.normal.penguin.sh gcat_set_039_1 5

echo "Submitting jobs for Novo: Batman/Catwoman"
sbatch novo.normal.batcat.sh gcat_set_039_1 5

echo "Submitting jobs for Novo: Penguin"
sbatch novo.normal.penguin.sh gcat_set_039_1 5

#echo "Submitting jobs for Gem: Batman/Catwoman"
#sbatch gem.normal.batcat.sh gcat_set_039_1 5

#echo "Submitting jobs for Gem: Penguin"
#sbatch gem.normal.penguin.sh gcat_set_039_1 5

