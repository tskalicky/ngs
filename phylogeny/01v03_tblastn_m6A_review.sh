#!/bin/bash
#PBS -l nodes=1:ppn=10
#PBS -l walltime=96:00:00
#PBS -l mem=50gb
#PBS -k oe
#PBS -N tblastn_m6A_Tpseudo
#PBS -M tomas.skalicky@seznam.cz
#PBS -m abe
#
#PARU KRTECEK server is using TORQUE scheduling system !!!
#
## initialize the required application
GENOME_DIR="/home/users/tskalicky/CEITEC/genomes/Thalassiosira_pseudonana"
PROT_REFERENCE="/home/users/tskalicky/CEITEC/m6A"
OUTPUT_DIR="/home/users/tskalicky/CEITEC/m6A/blast"
# variables
SPECIES=$(basename $GENOME_DIR)
THREADS=$PBS_NUM_PPN
APPENDIX=".fna.gz"
DBTYPE="nucl"
###########################################################################
### commands
mkdir $OUTPUT_DIR/"$SPECIES"
cd $OUTPUT_DIR/"$SPECIES"
cp -av $PROT_REFERENCE/*.fa $OUTPUT_DIR/"$SPECIES"
cp -av $GENOME_DIR/*.fna.gz $OUTPUT_DIR/"$SPECIES"
date +"%d/%m/%Y %H:%M:%S" 
echo "Now I am decompressing all genomes"
for a in *$APPENDIX
do
	FILE=$a
	gzip -d $FILE
done &
#wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Done decompressing all genomes"
#
date +"%d/%m/%Y %H:%M:%S" 
echo "Preparing genome blast Database."
shopt -s nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# declare an array variables
declare -a BLAST_DB
for e in *.fna
do
	FILE2=$e
	FILENAME2=${e%.*}
	makeblastdb -in $FILE2 -dbtype $DBTYPE -out $FILENAME2
	# DBLIST[length_of_DBLIST + 1]=filename # This is one way how to fill an array with filenames
	BLAST_DB[${#BLAST_DB[@]}+1]=$FILENAME2
done
# get length of an array
length2=${#BLAST_DB[@]}
# one liner
# for e in *.fna; do FILENAME2=${e%.*}; BLAST_DB[${#BLAST_DB[@]}+1]=$FILENAME2; echo ${BLAST_DB[@]}; done
# wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finished preparing blast Database."
echo "There are $length2 blast databses that will be used for tblastn."
echo "BLAST_DB array now contains these databases:"
echo "${BLAST_DB[@]}"
#
# shopt nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
IFS=$'\n' # split on newline only, needed for filling arrays with output from find
set -f    # disable globbing, ONLY needed for filling arrays with output from find
# declare an array variables
# This is other way how to fill an array with filenames
declare -a PROTEINS=($(find . -maxdepth 1 -name  '*.fa' -exec basename {} \; | sort -n))
# declare -a BLAST_DB=($(find . -maxdepth 1 -name  '*.fna' -exec basename {} \; | sort -n))
set +f # enable globbing, because is needed for other parts of the script, like variable expansions !!!
# get length of an array
quantity="${#PROTEINS[@]}"
echo "There are $quantity protein samples that will be blasted."
echo "Sample names are: ${PROTEINS[@]}"
#
for (( w=0;w<${quantity};w +=1 )); do
	SAMPLE="${PROTEINS[$w]}"
	SAMPLENAME=${SAMPLE%.*}
	if [[ -f $SAMPLE ]]; then
		date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
		echo "Start tblastn of protein $SAMPLE against blastDB ${BLAST_DB[1]}"
		tblastn -query $SAMPLE -db $OUTPUT_DIR/$SPECIES/"${BLAST_DB[1]}" \
		-out "tblastn_m6A_"$SAMPLENAME"_"${BLAST_DB[1]}"_search" -evalue 1e-3 \
		-outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
		-culling_limit 1 -num_threads $THREADS
		date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
		echo "Finnished tblastn of sample $SAMPLE against blastDB ${BLAST_DB[1]}"
		date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
		echo "Start tblastn of protein $SAMPLE against blastDB ${BLAST_DB[2]}"
		tblastn -query $SAMPLE -db $OUTPUT_DIR/$SPECIES/"${BLAST_DB[2]}" \
		-out "tblastn_m6A_"$SAMPLENAME"_"${BLAST_DB[2]}"_search" -evalue 1e-3 \
		-outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
		-culling_limit 1 -num_threads $THREADS
		date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
		echo "Finnished tblastn of sample $SAMPLE against blastDB ${BLAST_DB[2]}"		
	else
		date +"%d/%m/%Y %H:%M:%S"
		echo "There is no $SAMPLE file for blasting!" && exit 1
	fi
done
# Wait for all background jobs to finish before the script continues
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finnished tblastn of all protein set against all blastDB"
