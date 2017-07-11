#!/bin/bash

#SBATCH --job-name="index"
#SBATCH -w batman
#SBATCH --time=24:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/indexall_%j.log 
#SBATCH --mem=120GB
#SBATCH -c 64
#SBATCH --exclusive


echo "Creating index:  Bowtie2"

#cd /scratch/077-hpca4se-bioinf/jlenis/apps/mappers/bowtie-2.2.9_batcat

#./bowtie2-build ../../../data/index/genome/hsapiens_v37.fa hsapiens_v37_bowtie2

echo  "Creating index:  BWA"

#cd /scratch/077-hpca4se-bioinf/jlenis/apps/mappers/bwa-0.7.15_batcat

#./bwa index ../../../data/index/genome/hsapiens_v37.fa hsapiens_v37_bwa

echo "Creating index:  SNAP"

#cd /scratch/077-hpca4se-bioinf/jlenis/apps/mappers/snap-1.0beta.18_batcat

#./snap-aligner index  ../../../data/index/genome/hsapiens_v37.fa ../../../data/index/snap_index

echo "Creating index:  GEM"

cd /scratch/077-hpca4se-bioinf/jlenis/apps/mappers/gem-3.0_batcat/bin

./gem-indexer -i ../../../../data/index/genome/hsapiens_v37.fa -o ../../../../data/index/gem3_index
