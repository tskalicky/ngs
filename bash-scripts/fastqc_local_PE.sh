#!/bin/bash
#QCDIR="/Users/tomas/Data/FTO/preprocessed/job_537816_wagap/trimmed/"
#DATA_DIR="/Users/tomas/Data/FTO/preprocessed/SE_libs/data/"
#DATA_DIR="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/TREX_WT3_PE_lib_job4255561_arien/data/trimmed/"
#QCDIR="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/fastqc/trimmed/FTO_KO3_job_4255583_arien"
#QCDIR="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/fastqc/trimmed/FTO_KO1_job_4256865_arien"
QCDIR="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/fastqc/trimmed/FTO_WT1_job_4257006_arien/"
#QCDIR2="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/fastqc/trimmed/FTO_KO2_job_4260396_arien" 
#FTO_KO3_1="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_KO3_job_4255583_arien/SRR3290145-FTO_KO_3_flexbar_qual_1.fastq.gz"
#FTO_KO3_2="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_KO3_job_4255583_arien/SRR3290145-FTO_KO_3_flexbar_qual_2.fastq.gz"
#FTO_KO1_1="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_KO1_job_4256865_arien/SRR3290143-FTO_KO_1_flexbar_qual_1.fastq.gz"
#FTO_KO1_2="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_KO1_job_4256865_arien/SRR3290143-FTO_KO_1_flexbar_qual_2.fastq.gz"
#FTO_KO2_1="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_KO2_job_4260396_arien/SRR3290144-FTO_KO_2_flexbar_qual_1.fastq.gz"
#FTO_KO2_2="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_KO2_job_4260396_arien/SRR3290144-FTO_KO_2_flexbar_qual_2.fastq.gz"
#FTO_WT2_1="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_WT2_job_4257007_arien/SRR3290147-TREX_WT_2_flexbar_qual_1.fastq.gz"
#FTO_WT2_2="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_WT2_job_4257007_arien/SRR3290147-TREX_WT_2_flexbar_qual_2.fastq.gz"
#
#METL16_PAR1="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/data/trimmed/METTL16_PAR1_job_4260487_arien/METTL16PAR-1_SRR6048658_flexbar_qual.fastq.gz"
#METL16_PAR2="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/data/trimmed/METTL16_PAR2_job_4260486_arien/METTL16PAR-2_SRR6048659_flexbar_qual.fastq.gz"
#METL16_UV1="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/data/trimmed/METTL16_UV1_job_4260489_arien/METTL16UV-1_SRR6048655_flexbar_qual.fastq.gz"
#METL16_UV2="/Users/tomas/Data/owncloud/CEITEC_lab/METTL16/data/trimmed/METTL16_UV2_job_4260490_arien/METTL16UV-2_SRR6048656_flexbar_qual.fastq.gz"
FTO_WT1_1="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_WT1_job_4257006_arien/SRR3290146-TREX_WT_1_flexbar_qual_1.fastq.gz"
FTO_WT1_2="/Users/tomas/Data/owncloud/CEITEC_lab/FTO_projekt/preprocessed/data/FTO_WT1_job_4257006_arien/SRR3290146-TREX_WT_1_flexbar_qual_2.fastq.gz"

set -e
#cd $DATA_DIR
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
#mkdir QCDIR QCDIR2
#echo "Now I am processing SE reads - Fastqc check"

#java -Xmx250m -jar /Users/tomas/bin/FastQC.app/Contents/MacOS/fastqc --outdir $QCDIR --format fastq --threads 4 SRR3290136-FTO_CLIP1_pass_1_flexbar.fastq.gz \
#SRR3290137-FTO_CLIP2_pass_1_flexbar.fastq.gz \
#SRR3290138-FTO_CLIP3_pass_1_flexbar.fastq.gz \
#SRR3290139-FTO_Input1_pass_1_flexbar.fastq.gz \
#SRR3290140-FTO_Input2_pass_1_flexbar.fastq.gz \
#SRR3290142-FTO_Input3_pass_1_flexbar.fastq.gz
#na MacOS pouzit tenhle prikaz:
#/Users/tomas/bin/FastQC.app/Contents/MacOS/fastqc --outdir $QCDIR --format fastq --threads 4 $FTO_KO3_1 $FTO_KO3_2
#echo "Done processing FTO KO3 PE reads - Fastqc check"
echo "Start processing FTO WT1 PE reads - Fastqc check"
#/Users/tomas/bin/FastQC.app/Contents/MacOS/fastqc --outdir $QCDIR --format fastq --threads 4 $METL16_PAR1 $METL16_PAR2 $METL16_UV1 $METL16_UV2
/Users/tomas/bin/FastQC.app/Contents/MacOS/fastqc --outdir $QCDIR --format fastq --threads 4 $FTO_WT1_1 $FTO_WT1_2
echo "Done processing FTO WT1 PE reads - Fastqc check"
#
cd $QCDIR
echo "entering" $QCDIR
echo "Number of reads after preprocessing is in fastqc/trimmed/total_sequences.txt"

for a in *zip
do
	unzip -q $a
	grep "Total Sequences" ${a%.zip*}/*.txt
done > total_sequences.txt
rm -r ./*fastqc/
#
#cd $QCDIR2
#echo "entering" $QCDIR2
#echo "Number of reads after preprocessing is in fastqc/trimmed/total_sequences.txt"
##
#for a in *zip
#do
#	unzip -q $a
#	grep "Total Sequences" ${a%.zip*}/*.txt
#done > total_sequences.txt
#rm -r ./*fastqc/
