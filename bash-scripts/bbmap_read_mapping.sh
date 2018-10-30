#!/bin/bash
#PBS -l walltime=168:0:0 
#PBS -q default@wagap-pro.cerit-sc.cz 
#PBS -l select=1:ncpus=70:mem=150gb:scratch_local=150gb:os=debian9
#PBS -j oe
#PBS -N bbmap_Pconfusum
#
## initialize the required application
module add bowtie2-2.3.0
module add bbmap-36.92
module add samtools-1.6
############################################################################################
### Variables
OUTPUT_DIR="/storage/brno3-cerit/home/tskalicky/CUL13/mapping"
GENOME="/storage/brno3-cerit/home/tskalicky/CUL13/genome_Kika_repaired/Pconfusum_genome_cleaned_final_NCBI_upload.fa"
#RNASEQDIR="/storage/brno3-cerit/home/tskalicky/CUL13/RAW_Illumina/RNA-Seq/Cleaned_wo_H10_contamination"
#DIFFEXPDIR="/storage/brno3-cerit/home/tskalicky/CUL13/RAW_Illumina/RNA-Seq/Differential_Expression/Filtered_reads_wo_H10_contamination_bbmap"

THREADS=$PBS_NUM_PPN
APPENDIX=".tar.gz"
APPENDIX2=".fq"
APPENDIX3=".sam"
####################################################################################################
# copy input data using SCRATCHDIR storage which is shared via NFSv4
# clean the SCRATCH when job finishes (and data
# are successfully copied out) or is killed
# use cp -avr when copying directories
trap 'clean_scratch' TERM EXIT # sets up scratch cleaning in case an error occurs
cp -av $GENOME $RNASEQDIR/*$APPENDIX $DIFFEXPDIR/*$APPENDIX $SCRATCHDIR
cd $SCRATCHDIR

if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch directory is not created!" 1>&2; exit 1; fi #checks if scratch directory is created
echo "SCRATCHDIR path is:" $SCRATCHDIR
echo "Following files/folders were copied to scratch:"
ls -c1

### Commands
for a in *$APPENDIX
do
	READS=$a
	NAME=${a%.*.*}
	echo "Unpacking RNAseq data $READS"
	unpigz -c -p $THREADS $READS | tar xf -
	echo "Finnished unpacking RNAseq data $READS"
done

# Genome Indexing
ref1=$SCRATCHDIR/Pconfusum_genome_cleaned_final_NCBI_upload.fa
#
bbmap.sh ref=Pconfusum_genome_cleaned_final_NCBI_upload.fa
for b in *$APPENDIX2
do
	READS2=$b
	NAME2=${b%.*}
	echo "Mapping RNAseq data $READS"
	#To map with high sensitivity with mapped reads in fastaq and statistics:
	bbmap.sh in=$READS2 ref=$ref1 nodisk out=$NAME2".sam" outm=$NAME2"_mapped_only.fq" slow k=12 covstats=$NAME2"_covstats.txt" covhist=$NAME2"_covhist.txt" basecov=$NAME2"_basecov.txt" bincov=$NAME2"_bincov.txt"
done
#
#Pre Samtools processing
mkdir -p $SCRATCHDIR/{bbstats,samtools}
echo "Moving mapping statistics to bbstats folder"
mv -v *.txt bbstats/
echo "Moving mapped reads to samtools folder"
mv -v *.fai *.sam samtools/
#
cp $ref1 $SCRATCHDIR/samtools
cd $SCRATCHDIR/samtools
##samtools faidx preparing tab delimited file for samtools view
echo "Creating samtools genome index"
samtools faidx Pconfusum_genome_cleaned_final_NCBI_upload.fa
for c in *APPENDIX3
do
	READS3=$c
	NAME3=${c%.*}
	echo "Converting SAM to BAM file: $READS3"
	samtools view -@ $THREADS -F 0x4 -b -u -t Pconfusum_genome_cleaned_final_NCBI_upload.fa.fai $READS3 | samtools sort --output-fmt BAM --threads $THREADS - -o $NAME3".sorted"
	samtools index -b $NAME3".sorted"
	samtools mpileup -u -f Pconfusum_genome_cleaned_final_NCBI_upload.fa.fai -P solexa -F 0.1 $NAME3".sorted" > $NAME3".pileup"
	echo "Finnished conversion of SAM to BAM file: $READS3"
done
############################################################################################
### Copy data from scratch back to home dir and clean scratch
mkdir -p $OUTPUT_DIR
rm $SCRATCHDIR/*$APPENDIX $SCRATCHDIR/*$APPENDIX2 $SCRATCHDIR/samtools/*$APPENDIX3
cp -avr $SCRATCHDIR $OUTPUT_DIR || export CLEAN_SCRATCH=false
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"

