#!/bin/bash
#SBATCH --job-name=Test_Job
#SBATCH --output=%x.o%j
#SBATCH --error=%x.e%j
#SBATCH --partition quanah
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --time=48:00:00
##SBATCH --mem-per-cpu=5427MB ##5.3GB, Modify based on needs
module load matlab/R2020a
matlab -nodisplay -r Genetic_Algorithm_Battery > matlab.out