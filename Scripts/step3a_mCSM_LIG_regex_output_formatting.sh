#!/bin/bash
#*************************************
#need to be in the correct directory
#*************************************
##: comments for code
#: commented out code

#********************************************************************
# TASK: Intermediate results processing

## Make sure you create a copy of the file from previous script (step2) 336_mCSM_lig_complex1_output_MASTER.txt in the /Results and call it 336_mCSM_lig_complex1_output_processed.txt (i.e omit the word _MASTER). 
## This is because in this script, the processing happens in place 
## within the file. 
#FIXME: will need to automate this step

# output file (336_mCSM_lig_complex1_output_processed.txt) 
# has a convenient delimiter of ":" that can be used to 
# format the file into two columns (col1: field_desc and col2: values)
# However the section "PredictedAffinityChange:...." and 
# "DUETstabilitychange:.." are split over multiple lines and 
# prevent this from happening.Additionally there are other empty lines
# that need to be omiited. In order ensure these sections are not split
# over multiple lines, this script is written.
#*********************************************************************

infile="../Results/336_mCSM_lig_complex1_output_processed.txt"

#sed -i '/PredictedAffinityChange:/ { N; N; N; N; s/\n//g;}' ${infile} \
# | sed -i '/DUETstabilitychange:/ {x; N; N; s/\n//g; p;d;}' ${infile}

# Outputs records separated by a newline, that look something like this:
# PredictedAffinityChange:-2.2log(affinityfoldchange)-Destabilizing
# Mutationinformation:
# Wild-type:L
# Position:4
# Mutant-type:W
# Chain:A
# LigandID:PZA
# Distancetoligand:15.911&Aring;
# DUETstabilitychange:-2.169Kcal/mol
# 
# PredictedAffinityChange:-1.538log(affinityfoldchange)-Destabilizing
# (...etc)

# This script brings everything in a convenient format for further processing in python.
# bear in mind, this replaces the file in place, so make sure you retain a copy for your records
sed -i '/PredictedAffinityChange/ {
N
N
N
N
s/\n//g
}
/DUETstabilitychange:/ {
N
N
s/\n//g
}
/^$/d' ${infile}
