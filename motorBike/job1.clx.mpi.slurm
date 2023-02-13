#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Frontera CLX nodes
#
#   *** MPI Job in Normal Queue ***
# 
# Last revised: 20 May 2019
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch clx.mpi.slurm" on a Frontera login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do NOT use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per CLX node: 56
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      fewer tasks per node to give each task more memory.
#
#----------------------------------------------------

#SBATCH -J Tower1             # Job name
#SBATCH -o Tower1.o%j         # Name of stdout output file
#SBATCH -e Tower1.e%j         # Name of stderr error file
#SBATCH -p small                   # Queue (partition) name
#SBATCH -N 1                       # Total # of nodes 
#SBATCH -n 8                       # Total # of mpi tasks
#SBATCH -t 24:00:00                # Run time (hh:mm:ss)
#SBATCH --mail-type=all            # Send email at begin and end of job
#SBATCH -A DesignSafe-Hajjar       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=du.xinl@northeastern.edu

# Any other commands must follow all #SBATCH directives...
module load openfoam/9.0
./Allrun
