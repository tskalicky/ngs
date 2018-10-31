#!/bin/bash
#PBS -l select=1:ncpus=8:mem=20gb:scratch_local=40gb:brno=True
#PBS -l walltime=720:00:00
#PBS -q default
#PBS -j oe
#PBS -N PB_m6A_METTLs_muscle_trees
# initialize the required application
module add raxml-8.2.8
module add phylobayes-3.3b
module add blast+-2.6.0
#
### Variables
DATADIR="/storage/brno2/home/tskalicky/m6A_review/pb"
# using SCRATCHDIR storage using scp (disks not connected via NFS)
# clean the SCRATCH when job finishes (and data
# are successfully copied out) or is killed
trap 'clean_scratch' TERM EXIT
# use "scp -R ..." in case of copying directories
cp -v $DATADIR/METTLs_combined_muscle_gb.phy $SCRATCHDIR
cd $SCRATCHDIR
echo "SCRATCHDIR path is:" $SCRATCHDIR
#
echo "Following reads were copied to scratch:"
ls -c1
echo "Following reads were copied to scratch:" >> $SCRATCHDIR/Pipeline_debuging.txt # debugging will be removed
ls -c1 >> $SCRATCHDIR/Pipeline_debuging.txt # debugging will be removed

if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch directory is not created!" 1>&2; exit 1; fi #checks if scratch directory is created

############################################################################################
# commands
echo "Script started on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
#./Fasta2Phylip.pl METTLs_combined_muscle_gblocks.fst METTLs_combined_muscle_gb.phy
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT1 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT2 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT3 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT4 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT5 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT6 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT7 &
pb -d METTLs_combined_muscle_gb.phy -s -cat -gtr -x 1 5000 METTLs_combined_muscle_gb_GTR_CAT8 &
echo "These files were created:" >> $SCRATCHDIR/Pipeline_debuging.txt # debugging will be removed
ls -c1 >> $SCRATCHDIR/Pipeline_debuging.txt # debugging will be removed
wait
echo "PB Finished starting bpcomp and tracecomp"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
#
bpcomp -v -x 1000 1 -o METTLs_combined_muscle_gb_GTR_CAT METTLs_combined_muscle_gb_GTR_CAT1 \
METTLs_combined_muscle_gb_GTR_CAT2 METTLs_combined_muscle_gb_GTR_CAT3 \
METTLs_combined_muscle_gb_GTR_CAT4 METTLs_combined_muscle_gb_GTR_CAT5 \
METTLs_combined_muscle_gb_GTR_CAT6 METTLs_combined_muscle_gb_GTR_CAT7 \
METTLs_combined_muscle_gb_GTR_CAT8
tracecomp -x 1000 1 -o METTLs_combined_muscle_gb_GTR_CAT METTLs_combined_muscle_gb_GTR_CAT1 \
METTLs_combined_muscle_gb_GTR_CAT2 METTLs_combined_muscle_gb_GTR_CAT3 \
METTLs_combined_muscle_gb_GTR_CAT4 METTLs_combined_muscle_gb_GTR_CAT5 \
METTLs_combined_muscle_gb_GTR_CAT6 METTLs_combined_muscle_gb_GTR_CAT7 \
METTLs_combined_muscle_gb_GTR_CAT8
# copy resources from scratch directory back on disk
# field, if not successful, scratch is not deleted
#tar -cf PB_m6A_METTLs_muscle_trees.tar $SCRATCHDIR --remove-files
# copy resources from scratch directory back on disk 
#field, if not successful, scratch is not deleted
cp -avr $SCRATCHDIR $DATADIR || export CLEAN_SCRATCH=false
cd $DATADIR
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"