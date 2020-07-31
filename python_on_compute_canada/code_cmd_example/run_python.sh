#!/bin/bash
#SBATCH --account=def-caporos1
#SBATCH --time=00:02:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --job-name=test
#SBATCH --output=%x-%j.out

python code_example.py
