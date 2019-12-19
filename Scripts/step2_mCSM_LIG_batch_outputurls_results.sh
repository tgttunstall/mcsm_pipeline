#!/bin/bash
#*************************************
#need to be in the correct directory
#*************************************
##: comments for code
#: commented out code

#********************************************************************
# TASK: submit result urls and fetch actual results using curl
# iterate over each result url from the output of step1 in the stored
# in file in /Results.
# Use curl to fetch results and extract relevant sections using hxtools
# and store these in another file in /Results 
# This script takes two arguments:
# 	input file: file containing results url
#				In this case: 336_mCSM_lig_complex1_result_url.txt
# 	output file: name of the file where extracted results will be stored
#				In this case : it is 336_mCSM_lig_complex1_output_MASTER.txt
#*********************************************************************

#if [ "$#" -ne 2 ]; then
  #if [ -Z $1 ]; then
#  echo "
#  Please provide both Input and Output files.

#  Usage: batch_read_urls.sh INFILE OUTFILE
#  "
#  exit 1
#fi

# First argument: Input File
# Second argument: Output File
#infile=$1
#outfile=$2

infile="../Results/336_mCSM_lig_complex1_result_url.txt"
outfile="../Results/336_mCSM_lig_complex1_output_MASTER.txt"


echo -n "Processing $(wc -l < ${infile}) entries from ${infile}"
echo
COUNT=0
while read -r line; do
#COUNT=$(($COUNT+1))
((COUNT++))
  curl --silent ${line} \
    | hxnormalize -x \
    | hxselect -c div.span4 \
    | hxselect -c div.well \
    | sed -r -e 's/<[^>]*>//g' \
    | sed -re 's/ +//g' \
    >> ${outfile}
  #| tee -a ${outfile}
#  echo -n '.'
echo -e "Processing entry ${COUNT}/$(wc -l < ${infile})..."  
  
done < "${infile}"

echo
echo "Processing Complete"

