#!/bin/bash
#QCDIR="/Users/tomas/Data/FTO/preprocessed/job_537816_wagap/trimmed/"
#DATA_DIR="/Users/tomas/Data/FTO/preprocessed/SE_libs/data/"
#DATA_DIR="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/TREX_WT3_PE_lib_job4255561_arien/data/trimmed/"
QCDIR="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/fastqc/trimmed/new_adapters/FlagPAR_FlagUV_jobs/job_563293_wagap"
FlagPAR="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/data/trimmed/FlagPAR_FlagUV_job_563293_wagap/FlagPAR_SRR6048657_flexbar_qual3.fastq.gz"
FlagUV="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/data/trimmed/FlagPAR_FlagUV_job_563293_wagap/FlagUV_SRR6048654_flexbar_qual3.fastq.gz"
set -e
cd $DATA_DIR
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
echo "Now I am processing SE reads - Fastqc check"

#java -Xmx250m -jar /Users/tomas/bin/FastQC.app/Contents/MacOS/fastqc --outdir $QCDIR --format fastq --threads 4 SRR3290136-FTO_CLIP1_pass_1_flexbar.fastq.gz \
#SRR3290137-FTO_CLIP2_pass_1_flexbar.fastq.gz \
#SRR3290138-FTO_CLIP3_pass_1_flexbar.fastq.gz \
#SRR3290139-FTO_Input1_pass_1_flexbar.fastq.gz \
#SRR3290140-FTO_Input2_pass_1_flexbar.fastq.gz \
#SRR3290142-FTO_Input3_pass_1_flexbar.fastq.gz
#na MacOS pouzit tenhle prikaz:
/Users/tomas/bin/FastQC.app/Contents/MacOS/fastqc --outdir $QCDIR --format fastq --threads 4 $FlagPAR $FlagUV
echo "Done processing SE reads - Fastqc check"
#
cd $QCDIR
echo "entering" $QCDIR
echo "Number of reads after preprocessing is in fastqc/trimmed/total_sequences.txt"
#
for a in *zip
do
	unzip -q $a
	grep "Total Sequences" ${a%.zip*}/*.txt
done > total_sequences.txt
rm -r ./*fastqc/
