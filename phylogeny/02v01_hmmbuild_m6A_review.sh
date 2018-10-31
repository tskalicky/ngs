### SCRIPT UNFINNISHED !!! ###
#!/bin/bash
#PBS -l nodes=1:ppn=10
#PBS -l walltime=96:00:00
#PBS -l mem=50gb
#PBS -k oe
#PBS -N hmmbuild_AA_profiles
#PBS -M tomas.skalicky@seznam.cz
#PBS -m abe
#
#PARU KRTECEK server is using TORQUE scheduling system !!!
#
## initialize the required application
ALIGN_DIR="/home/users/tskalicky/CEITEC/m6A/HMMER/alignments"
OUTPUT_DIR="/home/users/tskalicky/CEITEC/m6A/HMMER/profiles"
WORKDIR="/home/users/tskalicky/CEITEC/m6A/HMMER/workdir"
GENOMES="/home/users/tskalicky/CEITEC/genomes"
# variables
SPECIES=$(basename $ALIGN_DIR)
THREADS=$PBS_NUM_PPN
APPENDIX=".fna.gz"
###########################################################################
### commands
mkdir $WORKDIR
cd $WORKDIR
cp -av $ALIGN_DIR/*.aln $WORKDIR
##find {directory} -type f -name '*.extension' # how to look for certain files in several folders
# find $GENOMES -maxdepth 2 -type f -name '*.fna.gz' -exec cp -av {} $WORKDIR \;
#
# date +"%d/%m/%Y %H:%M:%S" 
# echo "Now I am decompressing all genomes"
# for a in *$APPENDIX
# do
# 	FILE=$a
# 	gzip -d $FILE
# done &
# #wait
# wait
# date +"%d/%m/%Y %H:%M:%S" 
# echo "Done decompressing all genomes"
#
date +"%d/%m/%Y %H:%M:%S" 
echo "Preparing HMMER Database."
shopt -s nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# declare an array variables
declare -a HMM_DB
for e in *.aln
do
	FILE2=$e
	FILENAME2=${e%.*}
	hmmbuild -o $FILENAME2"_summary" -O $FILENAME2"_annot_aln" $FILENAME2"_hmm_profile" $FILE2
	hmmpress $FILENAME2"_hmm_profile"
	# DBLIST[length_of_DBLIST + 1]=filename # This is one way how to fill an array with filenames
	HMM_DB[${#HMM_DB[@]}+1]=$FILENAME2"_hmm_profile"
done &
# get length of an array
length2=${#HMM_DB[@]}
# wait
wait
date +"%d/%m/%Y %H:%M:%S" 
echo "Finished preparing HMMER Database."
echo "There are $length2 HMMER profiles that will be used for hmm search."
echo "HMM_DB array now contains these profiles:"
echo "${HMM_DB[@]}"
#
# shopt nullglob # If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves.
# IFS=$'\n' # split on newline only, needed for filling arrays with output from find
# set -f    # disable globbing, ONLY needed for filling arrays with output from find
# # declare an array variables
# # This is other way how to fill an array with filenames
# declare -a GENOMES=($(find . -maxdepth 1 -name  '*genomic.fna' -exec basename {} \; | sort -n))
# declare -a TRANSCRIPTOMS=($(find . -maxdepth 1 -name  '*rna.fa' -exec basename {} \; | sort -n))
# # declare -a HMM_DB=($(find . -maxdepth 1 -name  '*.fna' -exec basename {} \; | sort -n))
# set +f # enable globbing, because is needed for other parts of the script, like variable expansions !!!
# # get length of an array
# quantity="${#GENOMES[@]}"
# quantity2="${#TRANSCRIPTOMS[@]}"
# echo "There are $quantity genomes that will be searched for profiles."
# echo "Genome names are: ${GENOMES[@]}"
# echo "There are $quantity2 transcriptoms that will be searched for profiles."
# echo "Genome names are: ${TRANSCRIPTOMS[@]}"
# #
# for (( w=0;w<${quantity};w +=1 )); do
# 	SAMPLE="${GENOMES[$w]}"
# 	SAMPLENAME=${SAMPLE%.*}
# 	if [[ -f $SAMPLE ]]; then
# 		date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
# 		echo "Start tblastn of protein $SAMPLE against blastDB ${HMM_DB[1]}"
# 		hmmscan 
# 		date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
# 		echo "Finnished tblastn of sample $SAMPLE against blastDB ${HMM_DB[1]}"	
# 	else
# 		date +"%d/%m/%Y %H:%M:%S"
# 		echo "There is no $SAMPLE file for hmmscan!" && exit 1
# 	fi
# done
# # Wait for all background jobs to finish before the script continues
# wait
# date +"%d/%m/%Y %H:%M:%S" 
# echo "Finnished tblastn of all protein set against all blastDB"
mv -v $WORKDIR/.* $OUTPUT_DIR
