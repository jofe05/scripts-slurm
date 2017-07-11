#!/bin/bash

#SBATCH --job-name="snap"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH -w batman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis_new/logs/hybrid/snap_%j.log 
#SBATCH -C "Opteron"

module load likwid/4.0.1

IN=$1
TAG="snap"
num_threads=32

main_dir="/scratch/077-hpca4se-bioinf/jlenis_new"

mkdir -p "$main_dir/results/$TAG"
mkdir -p "/tmp/data/results/$TAG"

echo $SLURM_JOB_NODELIST

#NUMA: Partitioning Strategy
instance_1="numactl --interleave=0-3 --physcpubind=0-31"
instance_2="numactl --interleave=4-7 --physcpubind=32-63"

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/snap-1.0beta.18_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"

local_dataset_path="/tmp/data/datasets/2"
local_index_path="/tmp/data/indexes"
local_results_path="/tmp/data/results/$TAG"

log_path="/scratch/077-hpca4se-bioinf/jlenis_new/logs/hybrid"

echo "> Benchmarks for snap-beta.18: $IN"
echo $SLURM_JOB_NODELIST


for (( i=0; i<3; i++ ))
do
	echo "########################## INTERLEAVE WARMUP ITERATION $i #######################################"
	#\time -v likwid-memsweeper

	OUT_T1="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Interleave1.t16"
	\time -v $instance_1 ./snap-aligner single $local_index_path/HG_index_snap_1 $local_dataset_path/$IN.DUMMY.1.fastq -t $num_threads -o $local_results_path/$OUT_T1.sam 2> $log_path/$OUT_T1.txt &
	pid_inst1=$!


	OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Interleave2.t16"
	\time -v $instance_2 ./snap-aligner single $local_index_path/HG_index_snap_1 $local_dataset_path/$IN.DUMMY.1.fastq -t $num_threads -o $local_results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt 

	while [ -e /proc/$pid_inst1 ]; do sleep 0.1; done

	echo "#################################################################"
done

for (( i=0; i<3; i++ ))
do
	echo "########################## INTERLEAVE ITERATION $i #######################################"
	#\time -v likwid-memsweeper

	OUT_T1="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Interleave1.t16"
	\time -v $instance_1 ./snap-aligner single $local_index_path/HG_index_snap_1 $local_dataset_path/$IN.1.fastq -t $num_threads -o $local_results_path/$OUT_T1.sam 2> $log_path/$OUT_T1.txt &
	pid_inst1=$!


	OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Interleave2.t16"
	\time -v $instance_2 ./snap-aligner single $local_index_path/HG_index_snap_1 $local_dataset_path/$IN.1.fastq -t $num_threads -o $local_results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt 

	while [ -e /proc/$pid_inst1 ]; do sleep 0.1; done

	echo "#################################################################"
done

#Deleting results 

################################################################
rm -f $local_results_path/$OUT_T1.sam  
rm -f $local_results_path/$OUT_T2.sam

#Returning to original path
cd $original_path
