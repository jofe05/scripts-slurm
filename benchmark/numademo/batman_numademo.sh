#!/bin/bash

#SBATCH --job-name="numademo"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -c 64
#SBATCH -w batman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/numademo/batman_numademo_%j.log 


SIZE="1000m"
SIZE=$1
TAG="numademo"

mkdir $main_dir/results/$TAG

echo $SLURM_JOB_NODELIST

#Changing working directory
original_path=`pwd`

log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/numademo"

echo "> Benchmarks: NUMADEMO SIZE: $SIZE"
echo $SLURM_JOB_NODELIST
OUTPUT="$SLURM_JOB_NODELIST.$TAG.$SIZE.$SLURM_JOB_ID"
echo $OUTPUT

echo "#################################################################"
echo "# TEST BENCHMARK: NUMADEMO"
echo "#################################################################"

for i in memset memcpy forward backward stream random2 ptrchase;
do
numademo -c $SIZE $i > $log_path/$OUTPUT.$i.csv
done

#Deleting results 

################################################################
#Returning to original path
cd $original_path
