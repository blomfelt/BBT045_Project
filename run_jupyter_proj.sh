#!/bin/bash

###################### Student input fields #####################

# Time requirement
TIME="01:00:00"			# Set the time you need to run Jupyter Lab

# Student id

OFFSET=2000
ID=10				# Students should use their id
STUDENT_ID=$(($OFFSET + $ID))


# Project id
PROJ_ID="C3SE2023-2-17"

# IP login node
IP="0.0.0.0"			# Do not change!

ml purge  # Ensure we don't have any conflicting modules loaded

# Replace with path to your container of choice
container=/cephyr/NOBACKUP/groups/bbt045_2024/ProjectSoftware/bbt045-projects.sif

# You can launch jupyter notebook or lab: 
srun -A ${PROJ_ID} -n 1 -t ${TIME} --pty apptainer  exec  $container jupyter lab --ip=${IP} --port ${STUDENT_ID}
