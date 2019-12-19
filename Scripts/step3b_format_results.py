#!/usr/bin/python
import pandas as pd
from collections import defaultdict

outCols=[
        'PredictedAffinityChange',
        'Mutationinformation',
        'Wild-type',
        'Position',
        'Mutant-type',
        'Chain',
        'LigandID',
        'Distancetoligand',
        'DUETstabilitychange'
        ]

lines = [line.rstrip('\n') for line in open('../Results/336_mCSM_lig_complex1_output_processed.txt')]

outputs = defaultdict(list)

for item in lines:
	col, val = item.split(':')
	outputs[col].append(val)

dfOut=pd.DataFrame(outputs)

pd.DataFrame.to_csv(dfOut,'../Results/336_complex1_formatted_results.csv', columns=outCols)
