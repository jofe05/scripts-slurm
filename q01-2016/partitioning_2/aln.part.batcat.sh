#!/bin/bash

#SBATCH --job-name="ALN-Part"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w batman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning/aln_%j.log 


IN=$1
repeat=$2
TAG="ALN-Part"
num_threads=8
counters="cache-misses,cycles,instructions,cs,migrations,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

instance_1="numactl --membind=0-3 --physcpubind=0-31"
instance_2="numactl --membind=4-7 --physcpubind=32-63"

mkdir $main_dir/results/$TAG

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bwa-0.7.12_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"
local_dataset_path="/tmp/data/datasets"
local_index_path="/tmp/data/indexes"

log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning"

echo "> Benchmarks for BWA 0.7.12: $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Warm up - 64 threads - T1"
echo "#################################################################"

#OUT_T1="WarmUp.$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.t64"
#echo $OUT_T1
#bwa aln -t 64 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.fastq > $results_path/$OUT_T1.sam

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance1.t16"
echo $OUT_T2
perf stat -e $counters -c -r $repeat $instance_1 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_1 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.1.fastq > $results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
pid_inst1=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance2.t16"
echo $OUT_T3
perf stat -e $counters -c -r $repeat $instance_2 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.2.fastq > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
pid_inst2=$!
echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

#OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance3.t16"
#echo $OUT_T4
#perf stat -e $counters -c -r $repeat $instance_2 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_2 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.3.fastq > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst3=$!

echo "#################################################################"
echo "# Test multi-threading - 8 threads - T2"
echo "#################################################################"

#OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance4.t16"
#echo $OUT_T5
#perf stat -e $counters -c -r $repeat $instance_4 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.4.fastq > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt
#perf stat -e $counters -a --per-socket  -c -r $repeat $instance_4 bwa aln -t 32 $local_index_path/HG_index_BWA_default/hsapiens_v37.fa $local_dataset_path/$IN.4.fastq > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt

echo "#################################################################"

while [ -e /proc/$pid_inst1]; do sleep 0.1; done
while [ -e /proc/$pid_inst2]; do sleep 0.1; done
while [ -e /proc/$pid_inst3]; do sleep 0.1; done

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
