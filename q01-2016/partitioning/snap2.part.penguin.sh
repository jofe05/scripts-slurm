#!/bin/bash

#SBATCH --job-name="SNAP-Part"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w penguin
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning/snap_%j.log 


#This version is for snap with 32 threads but interleaved

IN=$1
repeat=$2
TAG="SNAP-Part"
num_threads=32
counters="cache-misses,cycles,instructions,cs,migrations,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

mkdir $main_dir/results/$TAG


#NUMA: Part Strategy
instance_1="numactl --interleave=0,1 --physcpubind=0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61"
instance_2="numactl --interleave=2,3 --physcpubind=2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63"


#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/snap-beta.18_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
log_path="$main_dir/logs/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets/2"
local_index_path="/tmp/data/indexes"


log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning"

echo "> Benchmarks for snap-beta.18: $IN"
echo $SLURM_JOB_NODELIST


echo "#################################################################"
echo "# Test multi-threading - 32 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance1.t32"
echo $OUT_T2

perf stat -e $counters -c -r $repeat $instance_1 ./snap-aligner single $local_index_path/HG_index_snap $local_dataset_path/$IN.1.fastq -t $num_threads -o $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 ./snap-aligner single $local_index_path/HG_index_snap $local_dataset_path/$IN.1.fastq -t $num_threads -o $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &

pid_inst1=$!
echo "#################################################################"
echo "# Test multi-threading - 32 threads - T2"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance2.t32"
echo $OUT_T3

perf stat -e $counters -c -r $repeat $instance_2 ./snap-aligner single $local_index_path/HG_index_snap $local_dataset_path/$IN.2.fastq -t $num_threads -o $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 ./snap-aligner single $local_index_path/HG_index_snap $local_dataset_path/$IN.2.fastq -t $num_threads -o $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &




while [ -e /proc/$pid_inst1]; do sleep 0.1; done
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
