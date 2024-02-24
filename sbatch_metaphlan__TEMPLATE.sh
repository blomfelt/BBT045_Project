#!/usr/bin/env bash

#SBATCH -A C3SE2023-2-17 -p vera
#SBATCH -n 5
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
WORKDIR=/cephyr/PATH/TO/YOUR/WORKING/DIRECTORY;

# files used
# location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif;
# input file
# FILL IN THE NAME OF YOUR INPUT FASTQ
FASTQ_FILE=<WRITE FILE NAME HERE>;
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
cp $WORKDIR/$FASTQ_FILE $WORKING_TMP;


### Running Metaphlan
apptainer exec $CONTAINER_LOC metaphlan $FASTQ_FILE --input_type fastq -o profiled_test.txt --nproc 4;


### Copy relevant files back, SLURM_SUBMIT_DIR is set by SLURM
cp $WORKING_TMP/* $WORKDIR;


# Refs: 
# C3SE container use: https://www.c3se.chalmers.se/documentation/applications/containers/
# Metaphlan Wiki: https://github.com/biobakery/MetaPhlAn/wiki
# --input_type {fastq,fasta,bowtie2out,sam}
# -o output file, --output_file output file
# --nproc N The number of CPUs to use for parallelizing the mapping [default 4]
