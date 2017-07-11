#!/bin/bash

#SBATCH --job-name="Setting_Env"
#SBATCH -w penguin
#SBATCH --time=1:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis_new/logs/env/%j.log 
#SBATCH --mem=20GB

echo "Accessing TMP folder"
cd /tmp
rm -r /tmp/data

echo "Creating directories"
mkdir data
cd data
mkdir indexes
mkdir datasets
cd datasets

main_dir="/scratch/077-hpca4se-bioinf/jlenis_new" 
echo "Copying data"
cp -r $main_dir/data/indexes/HG_* /tmp/data/indexes
cp -r /scratch/077-hpca4se-bioinf/jlenis_new/data/datasets/* /tmp/data/datasets

