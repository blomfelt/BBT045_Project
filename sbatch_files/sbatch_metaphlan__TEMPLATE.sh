#!/usr/bin/env bash

#SBATCH -A C3SE2023-2-17 -p vera
#SBATCH -n 20
#SBATCH -C MEM512
#SBATCH -t 5:00:00
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
# key directory
# FILL IN THE PATH TO YOUR WORKING DIRECTORY
WORKDIR=/cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/metaphlan;

# files used
# location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif;
# input file
# FILL IN THE NAME OF YOUR INPUT FASTQ
# NOTE THAT THIS SCRIPT IS WRITTEN FOR ONE (1) FILE
# IF YOU HAVE MULTIPLE FILES YOU MAY NEED TO WRITE A FOR LOOP

# temp files directory variable
WORKING_TMP=$TMPDIR/Metaphlan_TMP;


### Load modules
module purge
#module load MODULE_NAME/module.version ...;


# Copy relevant files to $TMPDIR
# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# copy the FASTQ file to the temporary directory
cp /cephyr/NOBACKUP/groups/bbt045_2024/project_group1/results/trimmomatic/*[12].trimmed.fastq.gz $WORKING_TMP;
#downstream_1.5km_2012_[12].trimmed.fastq.gz

### Running Metaphlan
for file in `ls *1.trimmed.fastq.gz | sed "s/_1.trimmed.fastq.gz//"`
do
    apptainer exec $CONTAINER_LOC metaphlan $file\_1.trimmed.fastq.gz,$file\_2.trimmed.fastq.gz \
                                            --input_type fastq --nproc 16 --unclassified_estimation --bowtie2out $file.bowtie2.bz2 -o $file\_profile.txt\
                                            
done


### Copy relevant files back, SLURM_SUBMIT_DIR is set by SLURM
cp $WORKING_TMP/* $WORKDIR;


# Refs: 
# C3SE container use: https://www.c3se.chalmers.se/documentation/applications/containers/
# Metaphlan Wiki: https://github.com/biobakery/MetaPhlAn/wiki
# --input_type {fastq,fasta,bowtie2out,sam}
# -o output file, --output_file output file
# --nproc N The number of CPUs to use for parallelizing the mapping [default 4]
