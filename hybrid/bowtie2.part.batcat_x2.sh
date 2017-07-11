#!/bin/bash

#SBATCH --job-name="bowtie2"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w catwoman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/journal/hybrid/bowtie2_%j.log 
#SBATCH -C "Opteron"

IN=$1
repeat=$2
TAG="bowtie2"
num_threads=32
#counters="cache-misses,cycles,instructions,cs,migrations,faults"
counters="cache-misses,cycles,instructions,cs,migrations,faults,bus-cycles,idle-cycles-frontend,idle-cycles-backend,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses,LLC-loads,LLC-stores,LLC-prefetches,dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,iTLB-loads,iTLB-load-misses,branch-loads,branch-load-misses"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"
mkdir $main_dir/results/$TAG

echo $SLURM_JOB_NODELIST

#NUMA: Partitioning Strategy
instance_1="numactl --membind=0-3 --physcpubind=0-31"
instance_2="numactl --membind=4-7 --physcpubind=32-63"




#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bowtie-2.2.9_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets/2"
local_index_path="/tmp/data/indexes"


log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/journal/hybrid"


echo "> Benchmarks for Bowtie2 2.2.9: $IN"
echo $SLURM_JOB_NODELIST


echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance1.t32"
echo $OUT_T2
perf stat -e $counters -c -r $repeat $instance_1 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.1.fastq -S $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.1.fastq -S $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
pid_inst1=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance2.t32"
echo $OUT_T3
perf stat -e $counters -c -r $repeat $instance_2 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.2.fastq -S $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt 
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.2.fastq -S $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &

echo "#################################################################"


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
