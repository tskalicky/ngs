#!/bin/bash
#PBS -l walltime=168:0:0 
#PBS -q default@wagap-pro.cerit-sc.cz 
#PBS -l select=1:ncpus=10:mem=200gb:scratch_local=200gb:os=debian9
#PBS -j oe
#PBS -N blast_m6A_review
#export PBS_SERVER=wagap-pro.cerit-sc.cz # needed only when executing from arien frontends
#
## initialize the required application
module add blast+-2.7.1
############################################################################################
### Variables
GENOME_DIR="/storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/genome_DB"
TRANSCRIPTOME_DIR="/storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/transcriptome_db"
PROT_SET="/storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/protein_set.fa"
OUTPUT_DIR="/storage/brno3-cerit/home/tskalicky/m6a_review/BLAST/tblastn"
#
THREADS=$PBS_NUM_PPN
APPENDIX="_genomic.fna.gz"
APPENDIX2="_rna.fna.gz"
DBTYPE="nucl"
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
mkdir -p $SCRATCHDIR/blastDB/{genomeDB,transcriptomeDB}
cp -av $GENOME_DIR/*.fna.gz $SCRATCHDIR/blastDB/genomeDB
cp -av $TRANSCRIPTOME_DIR/*.fna.gz $SCRATCHDIR/blastDB/transcriptomeDB
cp -av $PROT_SET $SCRATCHDIR
cd $SCRATCHDIR

if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch directory is not created!" 1>&2; exit 1; fi #checks if scratch directory is created
echo "SCRATCHDIR path is:" $SCRATCHDIR
echo "Following files/folders were copied to scratch:"
ls -c1

# Binaries
MAKEBLASTDB=$(which makeblastdb)
TBLASTN=$(which tblastn)

# Check if tools are installed
which $MAKEBLASTDB
which $TBLASTN
####################################################################################################
### commands
cd $SCRATCHDIR/blastDB/genomeDB
date +"%d/%m/%Y %H:%M:%S" 
echo "Now I am decompressing all genomes"
for a in *$APPENDIX
do
	FILE=$a
	unpigz -v -p $THREADS $FILE
done
#wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Done decompressing all genomes"
#
date +"%d/%m/%Y %H:%M:%S" 
echo "Preparing genome blast Database."
#
shopt -s nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# declare an array variables
declare -a DBLIST
declare -a PROTLIST

for b in *.fna
do
	FILE=$b
	FILENAME=${b%.*}
	makeblastdb -in $FILE -dbtype $DBTYPE -out $FILENAME
	#DBLIST[length_of_DBLIST + 1]=filename
	DBLIST[${#DBLIST[@]}+1]=$(echo "$FILENAME")
done
# wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finished preparing genomic blast Database."
echo "DBLIST array now contains these databases:"
echo "${DBLIST[@]}"
#
cd $SCRATCHDIR
# get length of an array
length=${#DBLIST[@]}
# use for loop to read all values and indexes
for (( c=1;c<=${length};c++ )); # I know, I know programmers COUNT from zero :-D
do
	DBNAME=${DBLIST[$c]}
	#
	echo "Start tblastn of protein set against genome blastDB: $DBNAME"
	tblastn -query protein_set.fa -db $SCRATCHDIR/blastDB/genomeDB/$DBNAME \
	-out tblastn_m6A_$DBNAME_genome_search \
	-evalue 1e-20 -outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
	-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
done
# Wait for all background jobs to finish before the script continues
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finnished tblastn of protein set against all genome blastDB"
######################################################################################################
# Transcriptome blast now
cd $SCRATCHDIR/blastDB/transcriptomeDB
date +"%d/%m/%Y %H:%M:%S" 
echo "Now I am decompressing all transcriptomes"
for d in *$APPENDIX2
do
	FILE=$d
	unpigz -v -p $THREADS $FILE
done
#wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Done decompressing all transcriptomes"
#
date +"%d/%m/%Y %H:%M:%S" 
echo "Preparing transcriptome blast Database."
#
shopt -s nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# declare an array variables
declare -a DBLIST2
for e in *.fna
do
	FILE2=$e
	FILENAME2=${e%.*}
	makeblastdb -in $FILE2 -dbtype $DBTYPE -out $FILENAME2
	#DBLIST[length_of_DBLIST + 1]=filename
	DBLIST2[${#DBLIST2[@]}+1]=$(echo "$FILENAME2")
done
# wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finished preparing transcriptome blast Database."
echo "DBLIST2 array now contains these databases:"
echo "${DBLIST2[@]}"
#
cd $SCRATCHDIR
# get length of an array
length2=${#DBLIST2[@]}
# use for loop to read all values and indexes
for (( f=1;f<=${length2};f++ )); # I know, I know programmers COUNT from zero :-D
do
	DBNAME2=${DBLIST2[$f]}
	#
	echo "Start tblastn of protein set against blastDB: $DBNAME2"
	tblastn -query protein_set.fa -db $SCRATCHDIR/blastDB/transcriptomeDB/$DBNAME2 \
	-out tblastn_m6A_$DBNAME2_transcriptome_search \
	-evalue 1e-20 -outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
	-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
done
# Wait for all background jobs to finish before the script continues
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finnished tblastn of protein set against all blastDB"

############################################################################################
### Copy data from scratch back to home dir and clean scratch
mkdir -p $OUTPUT_DIR
cp -avr $SCRATCHDIR $OUTPUT_DIR || export CLEAN_SCRATCH=false
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"