#!/bin/bash

#SBATCH --job-name="MEM-Part"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w batman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning/mem_%j.log 


IN=$1
repeat=$2
TAG="MEM-Part"
num_threads=8
counters="cache-misses,cycles,instructions,cs,migrations,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

#NUMA: Partitioning Strategy
instance_1="numactl --membind=0 --physcpubind=0-7"
instance_2="numactl --membind=1 --physcpubind=8-15"
instance_3="numactl --membind=2 --physcpubind=16-23"
instance_4="numactl --membind=3 --physcpubind=24-31"
instance_5="numactl --membind=4 --physcpubind=32-39"
instance_6="numactl --membind=5 --physcpubind=40-47"
instance_7="numactl --membind=6 --physcpubind=48-55"
instance_8="numactl --membind=7 --physcpubind=56-63"

mkdir $main_dir/results/$TAG

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bwa-0.7.12_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets/8"
local_index_path="/tmp/data/indexes"

log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning"

echo "> Benchmarks for BWA 0.7.12: $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"

#OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
#echo $OUT_T1
#bwa mem -t 64 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance1.t8"
echo $OUT_T2
perf stat -e $counters -c -r $repeat $instance_1 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
pid_inst1=$!
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance2.t8"
echo $OUT_T3
perf stat -e $counters -c -r $repeat $instance_2 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
pid_inst2=$!
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance3.t8"
echo $OUT_T4
perf stat -e $counters -c -r $repeat $instance_3 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst3=$!
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_3 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"


OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance4.t8"
echo $OUT_T5
perf stat -e $counters -c -r $repeat $instance_4 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.4.fastq > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
pid_inst4=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance5.t8"
echo $OUT_T6
perf stat -e $counters -c -r $repeat $instance_5 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.5.fastq > $results_path/$OUT_T6.sam 2> $log_path/$OUT_T6.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
pid_inst5=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T7="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance6.t8"
echo $OUT_T7
perf stat -e $counters -c -r $repeat $instance_6 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.6.fastq > $results_path/$OUT_T7.sam 2> $log_path/$OUT_T7.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_3 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst6=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T8="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance7.t8"
echo $OUT_T8
perf stat -e $counters -c -r $repeat $instance_7 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.7.fastq > $results_path/$OUT_T8.sam 2> $log_path/$OUT_T8.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_3 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst7=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T9="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance8.t8"
echo $OUT_T9
perf stat -e $counters -c -r $repeat $instance_8 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.8.fastq > $results_path/$OUT_T9.sam 2> $log_path/$OUT_T9.txt
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_4 bwa mem -t $num_threads $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.4.fastq > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt

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
