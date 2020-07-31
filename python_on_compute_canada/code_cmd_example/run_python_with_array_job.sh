#!/bin/bash
#SBATCH --account=def-caporos1
#SBATCH --array=1-10
#SBATCH --time=00:02:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --job-name=test_parallel
#SBATCH --output=%x-%j.out

python code_example_parallel.py $SLURM_ARRAY_TASK_ID
