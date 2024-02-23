#!/usr/bin/env bash

## This specifies the project and what cluster to run on. Don't change it for this course!
#SBATCH -A C3SE2023-2-17 -p vera
## This specifies the number of nodes to use. Don't change it.
#SBATCH -n 1
## This specifies the time to allocate for the tasks in this script (format hours:mins:seconds)
## Calculate a reasonable amount of time you think this will take, and multiply by 1.5-ish so you have some margin
#SBATCH -t 15:00:00
## This specifies the name of the job, in this case (as we will run trim_galore in this example), we will call it 'trim_galore'
#SBATCH -J trimmomatic
## Here you can add your e-mail address and you _may_ get an e-mail when the job fails or is done 
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
## Set the names for the error and output files. Don't touch this unless you know what you are doing
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out


###
#
# Title: sbatch_example.sh
# Date: 2024.02.23
# Author: Johan Bengtsson-Palme, heavily inspired by Vi Varga
#
# Description: 
# This script will -- as an example -- run TrimGalore! on a set of input samples, specified in a loop
# 
# Usage: 
# sbatch sbatch_example.sh
#
###


### Set parameters
# This sets up your project folder as the working directory. Change the XX to your group number/name
# CORRECT THIS FILE PATH AS YOU NEED
WORKDIR=/cephyr/NOBACKUP/groups/bbt045_2024/project_group1;

# files used
# location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif;


# temp files directory variable, this specifies a name of a directory on the compute node that will be used to store data temporarily
WORKING_TMP=$TMPDIR/JOB_TMP;


### Load modules, the module purge just makes sure nothing unwanted is loaded on the compute node
module purge
#module load MODULE_NAME/module.version ...;


# Copy relevant files to $TMPDIR
# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# This is a good place to copy files to the working directory on the compute node, if needed for the script. It is not needed in this example, so this is commented out.
#cp FILE_TO_COPY $WORKING_TMP


### Running Trimmomatic

## First identify a list of files. This command will list all FORWARD read files in the project data directory, remove the last part ('_1.fastq.gz') and store the list in $FILE_LIST
FILE_LIST=`ls /cephyr/NOBACKUP/groups/bbt045_2024/PROJECT_DATA/*_1.fastq.gz | sed "s/_1.fastq.gz//"`
## This initiates a loop over the entire feel lists
for i in $FILE_LIST
do
  ## This will just write every command that is run to the standard output log. It is not needed, but can be nice to be able to follow the process
  echo "trim_galore --quality 20 --length 60 --cores 8 --paired -o $WORKDIR $i\_1.fastq.gz $i\_2.fastq.gz" 
  #ls $i\_1.fastq.gz $i\_2.fastq.gz
  ## This will run the trim_galore command within the container. Note that we use 8 cores to make the process more efficient, and that we use the paired option to keep track of the paired-end reads
  apptainer exec $CONTAINER_LOC trim_galore --quality 20 --length 60 --cores 8 --paired -o $WORKDIR $i\_1.fastq.gz $i\_2.fastq.gz
done


;


### Copy relevant files back, this is good practice but will actually not do anything for this specific script
cp $WORKING_TMP/* $WORKDIR;


