#!/bin/bash

#SBATCH --job-name="bowtie2"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH -w catwoman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis_new/logs/journal/hybrid/bowtie2_%j.log 
#SBATCH -C "Opteron"

module load likwid/4.0.1

IN=$1
TAG="bowtie2"
num_threads=8

main_dir="/scratch/077-hpca4se-bioinf/jlenis_new"

mkdir -p "$main_dir/results/$TAG"
mkdir -p "/tmp/data/results/$TAG"

echo $SLURM_JOB_NODELIST

#NUMA: Partitioning Strategy
instance_1="numactl --membind=0 --physcpubind=0-7"
instance_2="numactl --membind=1 --physcpubind=8-15"
instance_3="numactl --membind=2 --physcpubind=16-23"
instance_4="numactl --membind=3 --physcpubind=24-31"
instance_5="numactl --membind=4 --physcpubind=32-39"
instance_6="numactl --membind=5 --physcpubind=40-47"
instance_7="numactl --membind=6 --physcpubind=48-55"
instance_8="numactl --membind=7 --physcpubind=56-63"

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/bowtie-2.2.9_batcat"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"

local_dataset_path="/tmp/data/datasets/8"
local_index_path="/tmp/data/indexes"
local_results_path="/tmp/data/results/$TAG"

log_path="/scratch/077-hpca4se-bioinf/jlenis_new/logs/hybrid"

echo "> Benchmarks for Bowtie2 2.2.6: $IN"
echo $SLURM_JOB_NODELIST

\time -v likwid-memsweeper

for (( i=0; i<5; i++ ))
do
	echo "########################## WARMUP ITERATION $i #######################################"

	OUT_T1="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance1.t16"
	\time -v $instance_1 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_1 $local_dataset_path/$IN.DUMMY.1.fastq -S $local_results_path/$OUT_T1.sam 2> $log_path/$OUT_T1.txt &
	pid_inst1=$!

	OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance2.t16"
	\time -v $instance_2 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_2 $local_dataset_path/$IN.DUMMY.2.fastq -S $local_results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
	pid_inst2=$!

	OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance3.t16"
	\time -v $instance_3 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_3 $local_dataset_path/$IN.DUMMY.3.fastq -S $local_results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
	pid_inst3=$!

	OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance4.t16"
	\time -v $instance_4 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_4 $local_dataset_path/$IN.DUMMY.4.fastq -S $local_results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
	pid_inst4=$!

	OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance5.t16"
	\time -v $instance_5 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_5 $local_dataset_path/$IN.DUMMY.5.fastq -S $local_results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt &
	pid_inst5=$!

	OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance6.t16"
	\time -v $instance_6 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_6 $local_dataset_path/$IN.DUMMY.6.fastq -S $local_results_path/$OUT_T6.sam 2> $log_path/$OUT_T6.txt &
	pid_inst6=$!

	OUT_T7="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance7.t16"
	\time -v $instance_7 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_7 $local_dataset_path/$IN.DUMMY.7.fastq -S $local_results_path/$OUT_T7.sam 2> $log_path/$OUT_T7.txt &
	pid_inst7=$!

	OUT_T8="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Instance8.t16"
	\time -v $instance_8 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index_8 $local_dataset_path/$IN.DUMMY.8.fastq -S $local_results_path/$OUT_T8.sam 2> $log_path/$OUT_T8.txt 

	while [ -e /proc/$pid_inst2]; do sleep 0.1; done
	while [ -e /proc/$pid_inst3]; do sleep 0.1; done
	while [ -e /proc/$pid_inst4]; do sleep 0.1; done
	while [ -e /proc/$pid_inst5]; do sleep 0.1; done
	while [ -e /proc/$pid_inst6]; do sleep 0.1; done
	while [ -e /proc/$pid_inst7]; do sleep 0.1; done

	echo "#################################################################"
done

for (( i=0; i<5; i++ ))
do
	echo "##########################ITERATION $i #######################################"

	OUT_T1="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance1.t16"
	\time -v $instance_1 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.1.fastq -S $local_results_path/$OUT_T1.sam 2> $log_path/$OUT_T1.txt &
	pid_inst1=$!

	OUT_T2="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance2.t16"
	\time -v $instance_2 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.2.fastq -S $local_results_path/$OUT_T2.sam 2> $log_path/$OUT_T2.txt &
	pid_inst2=$!

	OUT_T3="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance3.t16"
	\time -v $instance_3 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.3.fastq -S $local_results_path/$OUT_T3.sam 2> $log_path/$OUT_T3.txt &
	pid_inst3=$!

	OUT_T4="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance4.t16"
	\time -v $instance_4 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.4.fastq -S $local_results_path/$OUT_T4.sam 2> $log_path/$OUT_T4.txt &
	pid_inst4=$!

	OUT_T5="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance5.t16"
	\time -v $instance_5 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.5.fastq -S $local_results_path/$OUT_T5.sam 2> $log_path/$OUT_T5.txt &
	pid_inst5=$!

	OUT_T6="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance6.t16"
	\time -v $instance_6 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.6.fastq -S $local_results_path/$OUT_T6.sam 2> $log_path/$OUT_T6.txt &
	pid_inst6=$!

	OUT_T7="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance7.t16"
	\time -v $instance_7 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.7.fastq -S $local_results_path/$OUT_T7.sam 2> $log_path/$OUT_T7.txt &
	pid_inst7=$!

	OUT_T8="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Instance8.t16"
	\time -v $instance_8 ./bowtie2 -p $num_threads -x $local_index_path/HG_index_bowtie2/bowtie2_index $local_dataset_path/$IN.8.fastq -S $local_results_path/$OUT_T8.sam 2> $log_path/$OUT_T8.txt 

	while [ -e /proc/$pid_inst2]; do sleep 0.1; done
	while [ -e /proc/$pid_inst3]; do sleep 0.1; done
	while [ -e /proc/$pid_inst4]; do sleep 0.1; done
	while [ -e /proc/$pid_inst5]; do sleep 0.1; done
	while [ -e /proc/$pid_inst6]; do sleep 0.1; done
	while [ -e /proc/$pid_inst7]; do sleep 0.1; done

	echo "#################################################################"
done

#Deleting results 

################################################################
rm -f $local_results_path/$OUT_T1.sam  
rm -f $local_results_path/$OUT_T2.sam
rm -f $local_results_path/$OUT_T3.sam  
rm -f $local_results_path/$OUT_T4.sam
rm -f $local_results_path/$OUT_T5.sam  
rm -f $local_results_path/$OUT_T6.sam
rm -f $local_results_path/$OUT_T7.sam  
rm -f $local_results_path/$OUT_T8.sam

#Returning to original path
cd $original_path


