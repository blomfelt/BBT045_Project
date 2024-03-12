#!/usr/bin/env bash

#SBATCH -A C3SE2023-2-17 -p vera
#SBATCH -n 4
#SBATCH -t 15:00:00
#SBATCH -J trimmomatic
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out


###
#
# Original title: sbatch_Trim_Galore.sh
# New title: sbatch_trimmomatic_2012.sh
# Date: 2024.02.20
# Author: Vi Varga
# Modified by: Felix Blomfelt
#
# Description: 
# This script will run trimmomatic on C3SE Vera from the bbt045-projects.sif
# Apptainer container file, in order to trim the raw reads.
# 
# Usage: 
# sbatch sbatch_trimmomatic_2012.sh
#
###


### Set parameters
# Working directory
WORKDIR=/cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/trimmomatic;

# Location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif;

# Temp files directory variable
WORKING_TMP=$TMPDIR/TRIM_TMP;

### Load modules
module purge

# Create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;

# Copy relevant files to $TMPDIR
cp /cephyr/NOBACKUP/groups/bbt045_2024/PROJECT_DATA/*2012*.fastq.gz $WORKING_TMP


### Running Trimmomatic
for file in `ls *_1.fastq.gz  | grep -v "_lake_" | sed "s/_1.fastq.gz//"`
do
    apptainer exec $CONTAINER_LOC trimmomatic PE -phred33 \
                    $file\_1.fastq.gz $file\_2.fastq.gz \
                    $file\_1.trimmed.fastq.gz $file\_1.un.trimmed.fastq.gz \
                    $file\_2.trimmed.fastq.gz $file\_2.un.trimmed.fastq.gz \
                    TOPHRED33 \
                    LEADING:30 TRAILING:30 \
                    MINLEN:60
done


### Copy relevant files back, SLURM_SUBMIT_DIR is set by SLURM
cp $WORKING_TMP/*.trimmed.fastq.gz $WORKDIR;


# Refs: 
# C3SE container use: https://www.c3se.chalmers.se/documentation/applications/containers/