#!/bin/bash

#SBATCH --job-name="NOVO-Scalability"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w penguin
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/scalability/novo_%j.log 


IN=$1
repeat=$2
TAG="NOVO-Scalability"
num_threads=8
counters="cache-misses,cycles,instructions,cs,migrations,faults,bus-cycles,idle-cycles-frontend,idle-cycles-backend"
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
./novoalign -c 64 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t8"
echo $OUT_T2
perf stat -e $counters -a --per-socket  -c -r $repeat ./novoalign -c 8 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T2.sam


echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t16"
echo $OUT_T3

perf stat -e $counters -a --per-socket  -c -r $repeat ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T3.sam

echo "#################################################################"
echo "# Test multi-threading - 32 threads - T4 "
echo "#################################################################"

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t32"
echo $OUT_T4

perf stat -e $counters -a --per-socket  -c -r $repeat ./novoalign -c 32 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T4.sam

echo "#################################################################"
echo "# Test multi-threading - 48 threads - T5"
echo "#################################################################"

OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t48"
echo $OUT_T5

perf stat -e $counters -a --per-socket  -c -r $repeat ./novoalign -c 48 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T5.sam

echo "#################################################################"
echo "# Test multi-threading - 64 threads - T6"
echo "#################################################################"
echo $OUT_T6
OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"

perf stat -e $counters -a --per-socket  -c -r $repeat ./novoalign -c 64 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.fastq -o SAM > $results_path/$OUT_T6.sam

echo "#################################################################"
echo "# Test multi-threading - 64 threads - T6"
echo "#################################################################"

#Deleting results 

################################################################
rm $results_path/$OUT_T1.sam  
rm $results_path/$OUT_T2.sam
rm $results_path/$OUT_T3.sam
rm $results_path/$OUT_T4.sam
rm $results_path/$OUT_T5.sam
rm $results_path/$OUT_T6.sam  

#Returning to original path
cd $original_path
