#!/usr/bin/python
from Bio import SeqIO
import sys

"""Usage python trimT.py fastq_file"""
# This script will read fastq file and trim TTT homopolymers from end of the sequence
# Where are at least 3-4 Ts and maximum 1 mismatch is allowed. 
# This script was written in order to trim uridylated RNA-seq reads


file = sys.argv[1]


def trimT(seq, qual):
    length = -4
    if seq[-4:].count('T') == 3:
        if seq[-5] != 'T':
            return -3
        else:
            while seq[length - 1] == 'T':
                length = length - 1
            else:
                return(length)
    elif seq[-4:].count('T') == 4:
        while seq[length - 1] == 'T':
            length = length - 1
        else:
            if seq[length - 2] == 'T':
                length = length - 1
                while seq[length - 1] == 'T':
                    length = length - 1
                else:
                    return(length)
            else:
                return(length)


name = ''
seq = ''
qual = ''
n = 1
with open('trimT_' + file, 'w') as res: 
    for line in open(file):
        if n == 1:
            name = line.replace('\n', '')
            n += 1
        elif n == 2:
            seq = line.replace('\n', '')
            n += 1
        elif n == 3:
            n += 1
        elif n == 4:
            qual = line.replace('\n', '')
            length = trimT(seq, qual)
            res.write(name +'\n')
            if length:
                res.write(seq[:length] + '\n')
                res.write('+\n')
                res.write(qual[:length] + '\n')
            else:
                res.write(seq + '\n')
                res.write('+\n')
                res.write(qual + '\n')
            n = 1




