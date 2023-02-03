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
#SBATCH -t 6:00:00                 # Run time (hh:mm:ss)
#SBATCH --mail-type=all            # Send email at begin and end of job
#SBATCH -A DesignSafe-Hajjar       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=du.xinl@northeastern.edu
#SBATCH --mail-type=ALL

# Any other commands must follow all #SBATCH directives...
module load openfoam/9.0

# run a RANS simulation first
cd motorBike
blockMesh >log.blockMesh
snappyHexMesh >log.snappyHexMesh
cp -a 0/. 2/
potentialFoam >log.potentialFoam
simpleFoam >log.simpleFoam
cd ..

# run the LES simulation
cp -r motorBike motorBikeLES
cp lesFiles/Allrun motorBikeLES/
cd motorBikeLES
cp ../lesFiles/fvS* ../lesFiles/controlDict system/
cp ../lesFiles/momentumTransport constant/
rm -r 0
rm -r 1
rm -r 2
mv ./502 ./0
decomposePar >log.decomposePar
ibrun pisoFoam -parallel >log.pisoFoam
reconstructPar >log.reconstructPar

# Launch MPI code... 
# ibrun $HOME/bin/OpenSeesMP TransTowerWind1.tcl         # Use ibrun instead of mpirun or mpiexec
