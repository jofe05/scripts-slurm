#!/bin/bash

echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
sbatch mem.locality.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-MEM: Penguin"
sbatch mem.locality.penguin.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-ALN: Batman/Catwoman"
sbatch aln.locality.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for BWA-ALN: Penguin"
sbatch aln.locality.penguin.sh gcat_set_039_1 5 

echo "Submitting jobs for Bowtie2: Batman/Catwoman"
sbatch bowtie2.locality.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for Bowtie2: Penguin"
sbatch bowtie2.locality.penguin.sh gcat_set_039_1 5

echo "Submitting jobs for Snap: Batman/Catwoman"
sbatch snap.locality.batcat.sh gcat_set_039_1 5 

echo "Submitting jobs for Snap: Penguin"
sbatch snap.locality.penguin.sh gcat_set_039_1 5

echo "Submitting jobs for Novo: Batman/Catwoman"
sbatch novo.locality.batcat.sh gcat_set_039_1 5

echo "Submitting jobs for Novo: Penguin"
sbatch novo.locality.penguin.sh gcat_set_039_1 5

#echo "Submitting jobs for Gem: Batman/Catwoman"
#sbatch gem.locality.batcat.sh gcat_set_039_1 5

#echo "Submitting jobs for Gem: Penguin"
#sbatch gem.locality.penguin.sh gcat_set_039_1 5

