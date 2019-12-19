#!/bin/bash

#*************************************
# need to be in the correct directory
#*************************************
##: comments for code
#: commented out code

#**********************************************************************
# TASK: Text file containing a list of SNPs; SNP in the format(C2E)
# per line. Sort by unique, which automatically removes duplicates.
# sace file in current directory
#**********************************************************************
infile="../Data/pnca_mis_SNPs_v2.csv"
outfile="../Data/pnca_mis_SNPs_v2_unique.csv"

# sort unique entries and output to current directory
sort -u ${infile} > ${outfile}

# count no. of unique snps mCSM will run on
count=$(wc -l < ${outfile})

# print to console no. of unique snps mCSM will run on
echo "${count} unique mutations for mCSM to run on"

