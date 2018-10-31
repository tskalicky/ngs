#!/bin/bash
#PBS -l nodes=1:ppn=10
#PBS -l walltime=96:00:00
#PBS -l mem=50gb
#PBS -k oe
#PBS -N tblastn_m6A_Athaliana
#PBS -M tomas.skalicky@seznam.cz
#PBS -m abe
#
#PARU KRTECEK server is using TORQUE scheduling system !!!
#
## initialize the required application
GENOME_DIR="/home/users/tskalicky/CEITEC/genomes/Arabidopsis_thaliana"
PROT_REFERENCE="/home/users/tskalicky/CEITEC/m6A"
OUTPUT_DIR="/home/users/tskalicky/CEITEC/m6A/blast"
# variables
THREADS=$PBS_NUM_PPN
APPENDIX=".fna.gz"
DBTYPE="nucl"
### commands
# mkdir $OUTPUT_DIR
cd $OUTPUT_DIR
cp -av $PROT_REFERENCE/*.fa $OUTPUT_DIR
cp -av $GENOME_DIR/*.fna $OUTPUT_DIR
# date +"%d/%m/%Y %H:%M:%S" 
# echo "Now I am decompressing all genomes"
# for a in *$APPENDIX
# do
# 	FILE=$a
# 	unpigz -v $FILE
# done
# #wait
# wait
# date +"%d/%m/%Y %H:%M:%S" 
# echo "Done decompressing all genomes"
#
date +"%d/%m/%Y %H:%M:%S" 
echo "Preparing genome blast Database."
shopt -s nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# declare an array variables
declare -a DBLIST2
for e in *.fna
do
	FILE2=$e
	FILENAME2=${e%.*}
	makeblastdb -in $FILE2 -dbtype $DBTYPE -out $FILENAME2
	DBLIST[length_of_DBLIST + 1]=filename
	DBLIST2[${#DBLIST2[@]}+1]=$FILENAME2
done
# one liner
# for e in *.fna; do FILENAME2=${e%.*}; DBLIST2[${#DBLIST2[@]}+1]=$FILENAME2; echo ${DBLIST2[@]}; done
# wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finished preparing blast Database."
echo "DBLIST2 array now contains these databases:"
echo "${DBLIST2[@]}"
#
# get length of an array
length2=${#DBLIST2[@]}
# use for loop to read all values and indexes
for (( f=1;f<=${length2};f++ )); # I know, I know programmers COUNT from zero :-D
do
	DBNAME2=${DBLIST2[$f]}
	#
	echo "Start tblastn of protein set against blastDB: $DBNAME2"
	tblastn -query METTL14_Athali_NP_001078365_1.fa -db $OUTPUT_DIR/$DBNAME2 \
	-out "tblastn_m6A_METTL14_Athali_"$DBNAME2"_search" -evalue 1e-20 \
	-outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
	-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
done
#
for (( f=1;f<=${length2};f++ )); # I know, I know programmers COUNT from zero :-D
do
	DBNAME2=${DBLIST2[$f]}
	#
	echo "Start tblastn of protein set against blastDB: $DBNAME2"
	tblastn -query METTL16_Athali_NP_001031382_1.fa -db $OUTPUT_DIR/$DBNAME2 \
	-out "tblastn_m6A_METTL16_Athali_"$DBNAME2"_search" -evalue 1e-20 \
	-outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
	-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
done
# Wait for all background jobs to finish before the script continues
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finnished tblastn of protein set against all blastDB"
