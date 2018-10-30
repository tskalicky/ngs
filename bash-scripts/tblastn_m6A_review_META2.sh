#!/bin/bash
#PBS -l walltime=24:0:0 
#PBS -q default@wagap-pro.cerit-sc.cz 
#PBS -l select=1:ncpus=40:mem=200gb:scratch_local=200gb:os=debian9
#PBS -j oe
#PBS -N tblastn_m6A_review2
#export PBS_SERVER=wagap-pro.cerit-sc.cz # needed only when executing from arien frontends
#
## initialize the required application
module add blast+-2.7.1
############################################################################################
### Variables
INPUT_DIR="/storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/tblastn/blastDB"
OUTPUT_DIR="/storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/tblastn"
#
THREADS=$PBS_NUM_PPN
#
####################################################################################################
# prepare files for copy - find genomic data in multiple folders and copy them into new one
# find /storage/brno3-cerit/home/tskalicky/genomes/ -type f -iname "*_genomic.fna.gz" \
# -exec cp -v {} /storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/genome_DB \;
#
# find /storage/brno3-cerit/home/tskalicky/genomes/ -type f -iname "*_rna.fna.gz" \
# -exec cp -v {} /storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/transcriptome_db \;
####################################################################################################
# copy input data using SCRATCHDIR storage which is shared via NFSv4
# clean the SCRATCH when job finishes (and data
# are successfully copied out) or is killed
# use cp -avr when copying directories
trap 'clean_scratch' TERM EXIT # sets up scratch cleaning in case an error occurs
cp -avr $INPUT_DIR $SCRATCHDIR
cd $SCRATCHDIR/blastDB

if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch directory is not created!" 1>&2; exit 1; fi #checks if scratch directory is created
echo "SCRATCHDIR path is:" $SCRATCHDIR

# Binaries
MAKEBLASTDB=$(which makeblastdb)
TBLASTN=$(which tblastn)

# Check if tools are installed
which $MAKEBLASTDB
which $TBLASTN
####################################################################################################
### commands
##
shopt -s nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# declare an array variables
declare -a PROTLIST=("WTAP.fa" "VIRMA.fa" "FTO.fa" "METTL4.fa" "METTL16.fa" "METTL14.fa" "METTL3.fa" "RBM15.fa" "ALKBH5.fa")
#get lenght of an array
length=${#PROTLIST[@]}
#
cd $SCRATCHDIR/blastDB/genomeDB
#
# POZN: modified in second round just for WTAp against genomicDB
for a in *.nhr
do
	FILE=$a
	DBNAME=${a%.*}
	for (( c=0;c<=${length};c++ )); # I know, I know programmers COUNT from zero :-D
	do
		PROTFILE=${PROTLIST[$c]}
		PROTNAME=${PROTFILE%.*}
		echo "Start tblastn of protein $PROTNAME against genome blastDB $DBNAME"
		tblastn -query $SCRATCHDIR/blastDB/$PROTFILE -db $SCRATCHDIR/blastDB/genomeDB/$DBNAME \
		-out $SCRATCHDIR/"$PROTNAME"_"$DBNAME" \
		-evalue 1e-20 -outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
		-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
	done
	wait
done
# wait
wait

######################################################################################################
# Transcriptome blast now
cd $SCRATCHDIR/blastDB/transcriptomeDB
date +"%d/%m/%Y %H:%M:%S" 
echo "Now I am processing all transcriptomes"
#
for b in *.nhr
do
	FILE2=$b
	DBNAME2=${b%.*}
	for (( c=0;c<=${length};c++ )); # I know, I know programmers COUNT from zero :-D
	do
		PROTFILE=${PROTLIST[$c]}
		PROTNAME=${PROTFILE%.*}
		echo "Start tblastn of protein $PROTNAME against transcriptome blastDB $DBNAME2"
		tblastn -query $SCRATCHDIR/blastDB/$PROTFILE -db $SCRATCHDIR/blastDB/transcriptomeDB/$DBNAME2 \
		-out $SCRATCHDIR/"$PROTNAME"_"$DBNAME2" \
		-evalue 1e-20 -outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
		-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
	done
	wait
done
# wait
wait
############################################################################################
### Copy data from scratch back to home dir and clean scratch
#mkdir -p $OUTPUT_DIR
cp -avr $SCRATCHDIR $OUTPUT_DIR || export CLEAN_SCRATCH=false
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"