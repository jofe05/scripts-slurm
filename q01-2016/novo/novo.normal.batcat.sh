#!/bin/bash

#SBATCH --job-name="NOVO-Scalability"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w catwoman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/scalability/novo_%j.log 


IN=$1
repeat=$2
TAG="NOVO-Scalability"
num_threads=8
counters="cache-misses,cycles,instructions,cs,migrations,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

mkdir $main_dir/results/$TAG

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/novocraft"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
log_path="$main_dir/logs/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets"
local_index_path="/tmp/data/indexes"


echo "> Benchmarks for NovoAlign: $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"

OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T1
perf stat -e $counters -a --per-socket  -c -r $repeat ./novoalign -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T1.sam


#Deleting results 

################################################################
rm $results_path/$OUT_T1.sam  

#Returning to original path
cd $original_path
