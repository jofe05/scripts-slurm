#!/bin/bash

#SBATCH --job-name="gem"
#SBATCH --exclusive
#SBATCH --mem=125G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH -w catwoman
#SBATCH --time=40:00:00
#SBATCH --partition=p_hpca4se 
#SBATCH -o /scratch/077-hpca4se-bioinf/jlenis_new/logs/hybrid/gem_%j.log 
#SBATCH -C "Opteron"

module load likwid/4.0.1

IN=$1
TAG="gem"
num_threads=64

main_dir="/scratch/077-hpca4se-bioinf/jlenis_new"

mkdir -p "$main_dir/results/$TAG"
mkdir -p "/tmp/data/results/$TAG"

echo $SLURM_JOB_NODELIST

#Changing working directory
original_path=`pwd`
mapper_path="$main_dir/software/mappers/gem3-3.1_batcat/"
cd $mapper_path

index_path="$main_dir/data/indexes"
dataset_path="$main_dir/data/datasets"
results_path="$main_dir/results/$TAG"
tools_path="$main_dir/software/tools"

local_dataset_path="/tmp/data/datasets"
local_index_path="/tmp/data/indexes"
local_results_path="/tmp/data/results/$TAG"

log_path="/scratch/077-hpca4se-bioinf/jlenis_new/logs/hybrid"

echo "> Benchmarks for GEM3 : $IN"
echo $SLURM_JOB_NODELIST

for (( i=0; i<3; i++ ))
do
	echo "########################## DEFAULT WARMUP ITERATION $i #######################################"
	\time -v likwid-memsweeper

	OUT_T1="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.DUMMY.It_$i.Default.t16"
	\time -v  bin/gem-mapper -t $num_threads -I $local_index_path/HG_index_GEM_1/index.gem -i $local_dataset_path/$IN.DUMMY.fastq -o $local_results_path/$OUT_T1.sam 2> $log_path/$OUT_T1.txt

	echo "#################################################################"
done

for (( i=0; i<3; i++ ))
do
	echo "########################## DEFAULT ITERATION $i #######################################"
	\time -v likwid-memsweeper

	OUT_T1="$SLURM_JOB_ID.$TAG.$SLURM_JOB_NODELIST.It_$i.Default.t16"
	\time -v  bin/gem-mapper -t $num_threads -I $local_index_path/HG_index_GEM_1/index.gem -i $local_dataset_path/$IN.fastq -o $local_results_path/$OUT_T1.sam 2> $log_path/$OUT_T1.txt 

	echo "#################################################################"
done

#Deleting results 
################################################################
rm -f $local_results_path/$OUT_T1.sam 

#Returning to original path
cd $original_path
