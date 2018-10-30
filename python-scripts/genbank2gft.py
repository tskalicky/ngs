#!/usr/bin/python
import Bio 
from Bio import GenBank
from Bio import SeqIO

fileList = ['F1.gb', 'F2.gb']

for f in fileList:
      with open(f, 'rU') as handle:
         for record in SeqIO.parse(handle, 'genbank'):
            for feature in record.features:
               if feature.type=='CDS':
                  #[extract feature values here]
                  count+=1

   print('You parsed', count, 'CDS features')