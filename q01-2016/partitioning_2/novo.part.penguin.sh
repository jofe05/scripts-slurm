#!/bin/bash

#SBATCH --job-name="NOVO-Part"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH -w penguin
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning/novo_%j.log 


IN=$1
repeat=$2
TAG="NOVO-Part"
num_threads=8
counters="cache-misses,cycles,instructions,cs,migrations,faults"
main_dir="/scratch/077-hpca4se-bioinf/jlenis"

mkdir $main_dir/results/$TAG

#NUMA: Partitioning Strategy
instance_1="numactl --membind=0 --physcpubind=0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61"
instance_2="numactl --membind=1 --physcpubind=1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61"
instance_2="numactl --membind=2 --physcpubind=2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63"
instance_4="numactl --membind=3 --physcpubind=3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63"

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

log_path="/scratch/077-hpca4se-bioinf/jlenis/logs/q1-2016/partitioning"

echo "> Benchmarks for NovoAling : $IN"
echo $SLURM_JOB_NODELIST

echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance1.t16"
echo $OUT_T3

perf stat -e $counters -c $instance_1 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.1.fastq -o SAM > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
#perf stat -e $counters -a --per-socket  -c   $instance_1 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.1.fastq -o SAM > $results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
pid_inst1=$!
echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance2.t16"
echo $OUT_T4

perf stat -e $counters -c   $instance_2 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.2.fastq -o SAM > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
#perf stat -e $counters -a --per-socket  -c   $instance_2 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.2.fastq -o SAM > $results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
pid_inst2=$!
echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance3.t16"
echo $OUT_T5

perf stat -e $counters -c   $instance_2 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.3.fastq -o SAM > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt &
#perf stat -e $counters -a --per-socket  -c   $instance_2 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.3.fastq -o SAM > $results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt &
pid_inst3=$!
echo "#################################################################"
echo "# Test multi-threading - 16 threads - T3"
echo "#################################################################"

OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.Instance4.t16"
echo $OUT_T6

perf stat -e $counters -c   $instance_4 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.4.fastq -o SAM > $results_path/$OUT_T6.sam 2> $log_path/$OUT_T6.txt 
#perf stat -e $counters -a --per-socket  -c   $instance_4 ./novoalign -c 16 -d $local_index_path/HG_index-Novoalign/hg9.nix -f $local_dataset_path/$IN.4.fastq -o SAM > $results_path/$OUT_T6.sam 2> $log_path/$OUT_T6.txt &

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
