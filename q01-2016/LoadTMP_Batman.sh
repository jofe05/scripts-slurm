#!/bin/bash

#SBATCH --job-name="Setting_Env"
#SBATCH -w batman
#SBATCH --time=1:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/%j.log 
#SBATCH --mem=20GB

echo "Accessing TMP folder"
cd /tmp

echo "Creating directories"
mkdir data
cd data
mkdir indexes
mkdir datasets
cd datasets
mkdir na12878

main_dir="/scratch/077-hpca4se-bioinf/jlenis" 
echo "Copying data"
cp -r $main_dir/data/indexes/* /tmp/data/indexes
#cp -r $main_dir/data/indexes/HG_index_BWA_default /tmp/data/indexes
#cp $main_dir/data/datasets/H.Sapiens.HiSeqSE.Sim.10M.fastq /tmp/data/datasets
cp -r $main_dir/data/datasets/gcat/reads/gcat_set_039/* /tmp/data/datasets
cp -r /scratch/077-hpca4se-bioinf/jlenis/data/datasets/na12878/* /tmp/data/datasets
