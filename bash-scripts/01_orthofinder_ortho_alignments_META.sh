#!/bin/bash
#PBS -l select=1:ncpus=79:mem=400gb:scratch_local=400gb:os=debian9
#PBS -l walltime=720:00:00
#PBS -q default@wagap-pro.cerit-sc.cz
#PBS -j oe
#PBS -N m6A_orthofinder
# :os=debian9 option is for running on node Zewura7
# initialize the required application
module add orthofinder-2.0.0
module add fasttree-2.1.8
module add mafft-7.305
# using SCRATCHDIR storage which is shared via NFSv4
DATADIR="/storage/brno3-cerit/home/tskalicky/m6a_review/data"
OUTPUTDIR="/storage/brno3-cerit/home/tskalicky/m6a_review/ortho_results"
# clean the SCRATCH when job finishes (and data
# are successfully copied out) or is killed
trap 'clean_scratch' TERM EXIT
cp -avr $DATADIR $SCRATCHDIR
cd $SCRATCHDIR
if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch directory is not created!" 1>&2; exit 1; fi #checks if scratch directory is created
echo "SCRATCHDIR path is:" $SCRATCHDIR
# commands
# note: the more threads with -a option, the more RAM it consumes! 
# If you will run out of allocated RAM, the computation will not crash but the data will not be saved! Be carefull with -a option!
orthofinder -f $SCRATCHDIR/data -t 79 -a 30 -M msa -oa
#
# copy resources from scratch directory back on disk
# field, if not successful, scratch is not deleted
tar -cvf Orthofinder_alignments.tar $SCRATCHDIR --remove-files # taring data prior their export from scratch because of huge amount of small files
mkdir $OUTPUTDIR
cp -avr $SCRATCHDIR $OUTPUTDIR || export CLEAN_SCRATCH=false
cd $OUTPUTDIR
tar -xvf Orthofinder_alignments.tar 
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"




