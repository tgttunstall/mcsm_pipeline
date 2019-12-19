#!/bin/bash

#*************************************
#need to be in the correct directory
#*************************************
##: comments for code
#: commented out code

#**********************************************************************
# TASK: submit requests using curl: HANDLE redirects and refresh url. 
# Iterate over mutation file and write/append result urls to a file
# result url file: stored in the /Results directory
# mutation file: one mutation per line, no chain ID
# output: in a file, should be n urls (n=no. of mutations in file)
# NOTE: these are just result urls, not actual values for results
#**********************************************************************
## iterate over mutation file; line by line and submit query using curl
filename="../Data/pnca_mis_SNPs_v2_unique.csv"

## some useful messages
echo -n -e "Processing $(wc -l < ${filename}) entries from ${filename}\n"
COUNT=0
while read -r line; do
((COUNT++))
    mutation="${line}"
#    echo "${mutation}"
pdb='../Data/complex1_no_water.pdb'
mutation="${mutation}"
chain="A"
lig_id="PZA"
affin_wt="0.99"
host="http://biosig.unimelb.edu.au"
call_url="/mcsm_lig/prediction"

##=========================================
##html field_names names required for curl
##complex_field:wild=@
##mutation_field:mutation=@
##chain_field:chain=@
##ligand_field:lig_id@
##energy_field:affin_wt
#=========================================
refresh_url=$(curl -L \
     -sS \
     -F "wild=@${pdb}" \
     -F "mutation=${mutation}" \
     -F "chain=${chain}" \
     -F "lig_id=${lig_id}" \
     -F "affin_wt=${affin_wt}" \
     ${host}${call_url} | grep "http-equiv")

#echo $refresh_url
#echo ${host}${refresh_url}

#use regex to extract the relevant bit from the refresh url
#regex:sed -r 's/.*(\/mcsm.*)".*$/\1/g'

#Now build: result url using host and refresh url and write the urls to a file in the Results dir
result_url=$(echo $refresh_url | sed -r 's/.*(\/mcsm.*)".*$/\1/g')
sleep 10

echo -e "${mutation} : processing entry ${COUNT}/$(wc -l < ${filename})..."

echo -e "${host}${result_url}" >> ../Results/$(wc -l < ${filename})_mCSM_lig_complex1_result_url.txt
#echo -n '.'
done < "${filename}"

echo
echo "Processing Complete"

##end of submitting query, receiving result url and storing results url in a file

