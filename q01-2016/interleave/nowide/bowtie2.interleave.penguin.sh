#!/bin/bash

#SBATCH --job-name="BOWTIE2-Interleave"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w penguin
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/interleave/bowtie2_%j.log 


IN=$1
repeat=$2
TAG="BOWTIE2-Interleave"
num_threads=8
counters="cache-misses,cycles,instructions,cs,migrations,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"
mkdir $main_dir/results/$TAG

#NUMA: Interleave Strategy
socket_1="numactl --interleave=0 --physcpubind=0,4,8,12,16,20,24,28"
socket_2="numactl --interleave=0,1 --physcpubind=0,4,8,12,16,20,24,28,1,5,9,13,17,21,25,29"
socket_4="numactl --interleave=0,1 --physcpubind=0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61"
socket_6="numactl --interleave=0-2 --physcpubind=0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62"
socket_all="numactl --interleave=0-3 --physcpubind=0-63"


#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bowtie2-2.2.6_penguin"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets"
local_index_path="/tmp/data/indexes"


echo "> Benchmarks for Bowtie2 2.2.6: $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"

OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T1
bowtie2 -p 64 -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.fastq -S $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t8"
echo $OUT_T2
perf stat   -c -r $repeat $socket_1 bowtie2 -p 8 -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.fastq -S $results_path/$OUT_T2.sam

echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t16"
echo $OUT_T3
perf stat   -c -r $repeat $socket_2 bowtie2 -p 16 -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.fastq -S $results_path/$OUT_T3.sam

echo "#################################################################"
echo "# Test multi-threading - 32 threads - T4 "
echo "#################################################################"

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t32"
echo $OUT_T4
perf stat   -c -r $repeat $socket_4 bowtie2 -p 32 -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.fastq -S $results_path/$OUT_T4.sam

echo "#################################################################"
echo "# Test multi-threading - 48 threads - T5"
echo "#################################################################"

OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t48"
echo $OUT_T5
perf stat   -c -r $repeat $socket_6 bowtie2 -p 48 -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.fastq -S $results_path/$OUT_T5.sam

echo "#################################################################"
echo "# Test multi-threading - 64 threads - T6"
echo "#################################################################"

OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
echo $OUT_T6

perf stat   -c -r $repeat $socket_all bowtie2 -p 64 -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.fastq -S $results_path/$OUT_T6.sam

#Deleting results 

################################################################
#rm $results_path/$OUT_T1.sam  
#rm $results_path/$OUT_T2.sam
#rm $results_path/$OUT_T3.sam
#rm $results_path/$OUT_T4.sam
#rm $results_path/$OUT_T5.sam
#rm $results_path/$OUT_T6.sam  

#Returning to original path
cd $original_path
