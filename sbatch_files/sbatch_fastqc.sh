#!/usr/bin/env bash

#SBATCH -A C3SE2023-2-17 -p vera
#SBATCH -n 1
#SBATCH -t 2:00:00
#SBATCH -J fastqc
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out


###
#
# Title: sbatch_Trim_Galore.sh
# Date: 2024.02.20
# Author: Vi Varga
#
# Description: 
# This script will run IQ-TREE on C3SE Vera from the phylo-tutorial-env.sif
# Apptainer container file, in order to phylogenetic trees.
# 
# Usage: 
# sbatch sbatch_iqtree.sh
#
###


### Set parameters
# key directory
# CORRECT THIS FILE PATH AS YOU NEED
WORKDIR=/cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/fastqc;

# location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif;

# temp files directory variable
WORKING_TMP=$TMPDIR/TRIM_TMP;


### Load modules
module purge
#module load MODULE_NAME/module.version ...;


# Copy relevant files to $TMPDIR
# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;

# This is a good place to copy files to the working directory on the compute node, if needed for the script. It is not needed in this example, so this is commented out.
#cp /cephyr/NOBACKUP/groups/bbt045_2024/PROJECT_DATA/*.fastq.gz $WORKING_TMP
cp /cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/trimmomatic/*.fastq.gz $WORKING_TMP

### Running fastQC

for file in `ls *.fastq.gz | grep -v "_lake_"`
do
    apptainer exec $CONTAINER_LOC fastqc $file -o $WORKING_TMP
done

#for i in `ls /cephyr/NOBACKUP/groups/bbt045_2024/PROJECT_DATA/*_1.fastq.gz | sed "s/_1.fastq.gz//"`
#do
#  echo "trim_galore --quality 20 --length 60 --cores 8 --paired -o /cephyr/NOBACKUP/groups/bbt045_2024/projectAliceRita5 #$i\_1.fastq.gz $i\_2.fastq.gz" 
#  #ls $i\_1.fastq.gz $i\_2.fastq.gz
#  apptainer exec $CONTAINER_LOC trim_galore --quality 20 --length 60 --cores 8 --paired -o #/cephyr/NOBACKUP/groups/bbt045_2024/projectAliceRita5 $i\_1.fastq.gz $i\_2.fastq.gz
#done


### Copy relevant files back, SLURM_SUBMIT_DIR is set by SLURM
cp $WORKING_TMP/*.zip $WORKDIR;
cp $WORKING_TMP/*.html $WORKDIR;


# Refs: 
# C3SE container use: https://www.c3se.chalmers.se/documentation/applications/containers/
# IQ-TREE Manual: http://www.iqtree.org/doc/iqtree-doc.pdf
# -s is the option to specify the name of the alignment file that is always required by IQ-TREE to work.
# -m is the option to specify the model name to use during the analysis. 
# The special MFP key word stands for ModelFinder Plus, which tells IQ-TREE to perform ModelFinder 
# and the remaining analysis using the selected model.
# Here, the model to use has been pre-selected: LG+R5
# To make this reproducible, need to use -seed option to provide a random number generator seed.
# -wbtl Like -wbt but bootstrap trees written with branch lengths. DEFAULT: OFF
# -T AUTO: allows IQ-TREE to auto-select the ideal number of threads
# -ntmax: set the maximum number of threads that IQ-TREE c use
