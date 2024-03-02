#!/usr/bin/env bash

#SBATCH -A C3SE2023-2-17 -p vera
#SBATCH -n 20
#SBATCH -C MEM512
#SBATCH -t 24:00:00
#SBATCH -J metaphlan
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out


###
#
# Title: sbatch_metaphlan.sh
# Date: 2024.02.22
# Author: Vi Varga
# Modified by: Felix Blomfelt
#
# Description: 
# This script will run Metaphlan on C3SE Vera from the bbt045-projects.sif
# Apptainer container file.
# 
# Usage: 
# sbatch sbatch_metaphlan.sh
#
###


### Set parameters
# Working directory
WORKDIR=/cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/metaphlan;

# Location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif;

# Temp files directory variable
WORKING_TMP=$TMPDIR/Metaphlan_TMP;

### Purge modules
module purge

# Create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;

# Copy relevant files to $TMPDIR
cp /cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/trimmomatic/*[12].trimmed.fastq.gz $WORKING_TMP;

### Running Metaphlan
for file in `ls *1.trimmed.fastq.gz | sed "s/_1.trimmed.fastq.gz//"`
do
    apptainer exec $CONTAINER_LOC metaphlan $file\_1.trimmed.fastq.gz,$file\_2.trimmed.fastq.gz \
                                            --input_type fastq --nproc 16 \
                                            --unclassified_estimation \
                                            --bowtie2out $file.bowtie2.bz2 -o $file\_profile.txt\
                                            
done


### Copy relevant files back, SLURM_SUBMIT_DIR is set by SLURM
cp $WORKING_TMP/* $WORKDIR;


# Refs: 
# C3SE container use: https://www.c3se.chalmers.se/documentation/applications/containers/
# Metaphlan Wiki: https://github.com/biobakery/MetaPhlAn/wiki
# --input_type {fastq,fasta,bowtie2out,sam}
# -o output file, --output_file output file
# --nproc N The number of CPUs to use for parallelizing the mapping [default 4]
