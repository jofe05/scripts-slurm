#!/bin/bash

#SBATCH --job-name="snap_localalloc"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH -w catwoman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/journalUpgrade/normal/snap_localalloc_batcat_%j.log 
#SBATCH -C "Opteron"

#Module loading
module load likwid/4.0.1

#Input variables
IN=$1
repeat=$2

#Setting initial variable
TAG="snap_normal"
counters="cache-misses,instructions,migrations,cs,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"
mkdir -p "$main_dir/results/journalUpgrade/$TAG"

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/snap-1.0beta.18_batcat"
cd $mapper_path


echo "> Loading Mapper: $mapper_path"

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/journalUpgrade/$TAG"
log_path="$main_dir/logs/journalUpgrade/$TAG"
tools_path="$main_dir/software/tools"

local_dataset_path="/tmp/data/datasets"
local_index_path="/tmp/data/indexes"

#NUMA: Localalloc Strategy
socket_1="numactl --localalloc --physcpubind=0-7"
socket_2="numactl --localalloc --physcpubind=0-15"
socket_4="numactl --localalloc --physcpubind=0-31"
socket_6="numactl --localalloc --physcpubind=0-47"
socketall="numactl --localalloc --physcpubind=0-63"

echo "> Benchmarks for snap-beta.18: $IN"
echo $SLURM_JOB_NODELIST

\time -v likwid-memsweeper

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T1
./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.fastq -t 64 -o $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# DUMMY INDEX LOADING - 8 threads"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T1="DUMMY.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t8"
echo $OUT_T1
perf stat -e $counters $socket_1 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.DUMMY.fastq -t 8 -o $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t8"
echo $OUT_T2

perf stat -e $counters $socket_1 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.fastq -t 8 -o $results_path/$OUT_T2.sam

echo "#################################################################"
echo "# DUMMY INDEX LOADING - 16 threads"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T1="DUMMY.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t16"
echo $OUT_T1
perf stat -e $counters $socket_2 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.DUMMY.fastq -t 16 -o $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t16"
echo $OUT_T3

perf stat -e $counters $socket_2 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.fastq -t 16 -o $results_path/$OUT_T3.sam

echo "#################################################################"
echo "# DUMMY INDEX LOADING - 32 threads"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T1="DUMMY.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t32"
echo $OUT_T1
perf stat -e $counters $socket_4 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.DUMMY.fastq -t 32 -o $results_path/$OUT_T1.sam


echo "#################################################################"
echo "# Test multi-threading - 32 threads - T4 "
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t32"
echo $OUT_T4

perf stat -e $counters $socket_4 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.fastq -t 32 -o $results_path/$OUT_T4.sam

echo "#################################################################"
echo "# DUMMY INDEX LOADING - 48 threads"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T1="DUMMY.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t48"
echo $OUT_T1
perf stat -e $counters $socket_6 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.DUMMY.fastq -t 48 -o $results_path/$OUT_T1.sam


echo "#################################################################"
echo "# Test multi-threading - 48 threads - T5"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t48"
echo $OUT_T5

perf stat -e $counters $socket_6 ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.fastq -t 48 -o $results_path/$OUT_T5.sam

echo "#################################################################"
echo "# DUMMY INDEX LOADING - 64 threads"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T1="DUMMY.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T1
perf stat -e $counters $socketall ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.DUMMY.fastq -t 64 -o $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 64 threads - T6"
echo "#################################################################"
echo "Execution starting on:"
date

OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T6
perf stat -e $counters $socketall ./snap-aligner single $index_path/HG_index_snap $dataset_path/$IN.fastq -t 64 -o $results_path/$OUT_T6.sam


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
