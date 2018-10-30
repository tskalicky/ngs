#!/bin/bash
#PBS -l select=1:ncpus=79:mem=400gb:scratch_local=400gb:os=debian9
#PBS -l walltime=720:00:00
#PBS -q default@wagap-pro.cerit-sc.cz
#PBS -j oe
#PBS -N m6A_ortho_trees
# initialize the required application
module add orthofinder-2.0.0
module add fasttree-2.1.8
module add mafft-7.305
#NOTE - os=debian9 parametr pro zevura7
##We wont be using SCRATCH dueing addition of new species - HUGE amnout of data for copy
##using SCRATCHDIR storage which is shared via NFSv4
##DATADIR="/mnt/storage-brno3-cerit/nfs4/home/$LOGNAME/m6a_review/data"
## clean the SCRATCH when job finishes (and data
## are successfully copied out) or is killed
#trap 'clean_scratch' TERM EXIT
#cp -avr $DATADIR $SCRATCHDIR
#cd $SCRATCHDIR
DATADIR="/mnt/storage-brno3-cerit/nfs4/home/tskalicky/m6a_review/proteoms/Results_Nov02/WorkingDirectory"
#
echo "Script started on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
cd $DATADIR
# orthofinder will run only -a 40 threads because the higher num the higher RAM consumption. With this huge dataset it would require more than 400GB of RAM
orthofinder -fg $DATADIR -t 79 -a 40
#
#
## copy resources from scratch directory back on disk
## field, if not successful, scratch is not deleted
##tar -cvf Orthofinder_alignments.tar $SCRATCHDIR --remove-files
##cp -avr $SCRATCHDIR $DATADIR || export CLEAN_SCRATCH=false
##cd $DATADIR
##tar -xvf Orthofinder_alignments.tar 
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"




