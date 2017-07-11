#!/bin/bash

#SBATCH --job-name="MEM-Part"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w penguin
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/journal/partitioning/mem_%j.log 


IN=$1
repeat=$2
TAG="MEM-Part"
num_threads=8
#counters="cache-misses,cycles,instructions,cs,migrations,faults"
counters="cache-misses,cycles,instructions,cs,migrations,faults,bus-cycles,idle-cycles-frontend,idle-cycles-backend,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses,LLC-loads,LLC-stores,LLC-prefetches,dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,iTLB-loads,iTLB-load-misses,branch-loads,branch-load-misses"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

echo $SLURM_JOB_NODELIST

#NUMA: Partitioning Strategy
instance_1="numactl --membind=0 --physcpubind=0,4,8,12,16,20,24,28"
instance_2="numactl --membind=0 --physcpubind=32,36,40,44,48,52,56,60"
instance_3="numactl --membind=1 --physcpubind=1,5,9,13,17,21,25,29"
instance_4="numactl --membind=1 --physcpubind=33,37,41,45,49,53,57,61"
instance_5="numactl --membind=2 --physcpubind=2,6,10,14,18,22,26,30"
instance_6="numactl --membind=2 --physcpubind=34,38,42,46,50,54,58,62"
instance_7="numactl --membind=3 --physcpubind=3,7,11,15,19,23,27,31"
instance_8="numactl --membind=3 --physcpubind=35,39,43,47,51,55,59,63"

mkdir $main_dir/results/$TAG

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bwa-0.7.15_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets/8"
local_index_path="/tmp/data/indexes"

log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/journal/partitioning"

echo "> Benchmarks for BWA 0.7.12: $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"

#OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
#echo $OUT_T1
#./bwa mem -t 64 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance1.t8"
echo $OUT_T2
perf stat -e $counters -c -r $repeat $instance_1 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
pid_inst1=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance2.t8"
echo $OUT_T3
perf stat -e $counters -c -r $repeat $instance_2 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
pid_inst2=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance3.t8"
echo $OUT_T4
perf stat -e $counters -c -r $repeat $instance_3 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_3 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst3=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance4.t8"
echo $OUT_T5
perf stat -e $counters -c -r $repeat $instance_4 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.4.fastq > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
pid_inst4=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance5.t8"
echo $OUT_T6
perf stat -e $counters -c -r $repeat $instance_5 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.5.fastq > $results_path/$OUT_T6.sam 2> $log_path/$OUT_T6.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
pid_inst5=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T7="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance6.t8"
echo $OUT_T7
perf stat -e $counters -c -r $repeat $instance_6 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.6.fastq > $results_path/$OUT_T7.sam 2> $log_path/$OUT_T7.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_3 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst6=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T8="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance7.t8"
echo $OUT_T8
perf stat -e $counters -c -r $repeat $instance_7 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.7.fastq > $results_path/$OUT_T8.sam 2> $log_path/$OUT_T8.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_3 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst7=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T9="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance8.t8"
echo $OUT_T9
perf stat -e $counters -c -r $repeat $instance_8 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.8.fastq > $results_path/$OUT_T9.sam 2> $log_path/$OUT_T9.txt
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_4 ./bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.4.fastq > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt

echo "#################################################################"

while [ -e /proc/$pid_inst1]; do sleep 0.1; done
while [ -e /proc/$pid_inst2]; do sleep 0.1; done
while [ -e /proc/$pid_inst3]; do sleep 0.1; done
while [ -e /proc/$pid_inst4]; do sleep 0.1; done
while [ -e /proc/$pid_inst5]; do sleep 0.1; done
while [ -e /proc/$pid_inst6]; do sleep 0.1; done
while [ -e /proc/$pid_inst7]; do sleep 0.1; done
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
