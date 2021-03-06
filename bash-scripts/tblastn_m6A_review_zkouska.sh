#!/bin/bash
cd /windows/D/ownCloud/CEITEC_lab/genomes
# variables
THREADS=$PBS_NUM_PPN
APPENDIX=".fna.gz"
DBTYPE="nucl"
### commands
date +"%d/%m/%Y %H:%M:%S" 
echo "Now I am decompressing all genomes"
for a in *$APPENDIX
do
	FILE=$a
	unpigz -v $FILE
done
#wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Done decompressing all genomes"
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
	echo makeblastdb -in $FILE2 -dbtype $DBTYPE -out $FILENAME2
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
# get length of an array
length2=${#DBLIST2[@]}
# use for loop to read all values and indexes
for (( f=1;f<=${length2};f++ )); # I know, I know programmers COUNT from zero :-D
do
	DBNAME2=${DBLIST2[$f]}
	#
	echo "Start tblastn of protein set against blastDB: $DBNAME2"
	echo tblastn -query protein_set.fa -db $SCRATCHDIR/blastDB/transcriptomeDB/$DBNAME2 \
	-out tblastn_m6A_$DBNAME2_transcriptome_search \
	1e-20 -outfmt '6 qseqid sallseqid length pident mismatch gaps qstart qend sstart send evalue bitscore qseq sseq' \
	-max_target_seqs 1000000 -culling_limit 1 -num_threads $THREADS
done
# Wait for all background jobs to finish before the script continues
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finnished tblastn of protein set against all blastDB"
