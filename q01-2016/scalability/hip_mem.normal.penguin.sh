#!/bin/bash

#SBATCH --job-name="MEM-Scalability"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w penguin
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/scalability/hip_%j.log 


IN=$1
repeat=$2
TAG="MEM-Scalability"
num_threads=8
counters="cycles,instructions,cs,migrations,faults,minor-faults,major-faults,alignment-faults,bus-cycles,idle-cycles-frontend,idle-cycles-backend,cache-misses,LLC-loads,LLC-load-misses,LLC-stores,dTLB-loads,dTLB-load-misses,iTLB-loads,iTLB-load-misses,branch-loads,branch-load-misses,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-prefetches,L1-dcache-prefetch-misses,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

mkdir $main_dir/results/$TAG

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bwa-0.7.12_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
log_path="$main_dir/logs/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets"
local_index_path="/tmp/data/indexes"

tool="perf stat -e $counters -a -C 0-63"
tool2="/usr/bin/time --verbose"


echo "> Benchmarks for BWA 0.7.12: $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"

OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T1
bwa mem -t 64 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t8"
echo $OUT_T2
$tool bwa mem -t 8 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T2.sam

echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t16"
echo $OUT_T3
$tool bwa mem -t 16 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T3.sam

echo "#################################################################"
echo "# Test multi-threading - 32 threads - T4 "
echo "#################################################################"

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t32"
echo $OUT_T4
$tool bwa mem -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T4.sam

echo "#################################################################"
echo "# Test multi-threading - 48 threads - T5"
echo "#################################################################"

OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t48"
echo $OUT_T5
$tool bwa mem -t 48 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T5.sam

echo "#################################################################"
echo "# Test multi-threading - 64 threads - T6"
echo "#################################################################"
echo $OUT_T6
OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"

$tool bwa mem -t 64 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T6.sam

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
