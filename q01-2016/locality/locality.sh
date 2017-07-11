#!/bin/bash

file="NIST7086_CGTACTAG_L002_R2_001"

#echo "Submitting jobs for BWA-MEM: Batman/Catwoman"
#sbatch mem.locality.batcat.sh $file 5 

#echo "Submitting jobs for BWA-MEM: Penguin"
#sbatch mem.locality.penguin.sh $file 5 

#echo "Submitting jobs for BWA-ALN: Batman/Catwoman"
#sbatch aln.locality.batcat.sh $file 5 

#echo "Submitting jobs for BWA-ALN: Penguin"
#sbatch aln.locality.penguin.sh $file 5 

#echo "Submitting jobs for Bowtie2: Batman/Catwoman"
#sbatch bowtie2.locality.batcat.sh $file 5 

#echo "Submitting jobs for Bowtie2: Penguin"
#sbatch bowtie2.locality.penguin.sh $file 5

#echo "Submitting jobs for Snap: Batman/Catwoman"
#sbatch snap.locality.batcat.sh $file 5 

#echo "Submitting jobs for Snap: Penguin"
#sbatch snap.locality.penguin.sh $file 5

echo "Submitting jobs for Novo: Batman/Catwoman"
sbatch novo.locality.batcat.sh $file 1

#echo "Submitting jobs for Novo: Penguin"
#sbatch novo.locality.penguin.sh $file 1

#echo "Submitting jobs for Gem: Batman/Catwoman"
#sbatch gem.locality.batcat.sh $file 5

#echo "Submitting jobs for Gem: Penguin"
#sbatch gem.locality.penguin.sh $file 5

