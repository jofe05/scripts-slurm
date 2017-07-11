#!/bin/bash

#SBATCH --job-name="Setting_Env"
#SBATCH -w penguin
#SBATCH --time=1:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/env/%j.log 
#SBATCH --mem=80GB

echo "Accessing TMP folder"
cd /tmp
rm -r /tmp/data

echo "Creating directories"
mkdir data
cd data
mkdir indexes
mkdir indexes/HG_index_bowtie2
mkdir datasets
cd datasets

main_dir="/scratch/077-hpca4se-bioinf/jlenis" 
echo "Copying data"
cp -r $main_dir/data/indexes/HG_index_bowtie2/* /tmp/data/indexes/HG_index_bowtie2/
cp -r /scratch/077-hpca4se-bioinf/jlenis/data/datasets/* /tmp/data/datasets
