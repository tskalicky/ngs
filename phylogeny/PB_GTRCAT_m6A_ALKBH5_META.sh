#!/bin/bash
#PBS -l select=1:ncpus=8:mem=50gb:scratch_local=50gb
#PBS -l walltime=720:00:00
#PBS -q default@wagap-pro.cerit-sc.cz
#PBS -j oe
#PBS -N PB_m6A_ALKBH5_trees
# initialize the required application
module add raxml-8.2.8
module add phylobayes-3.3b
module add blast+-2.6.0
#NOTE - os=debian9 parametr pro zevura7
#using SCRATCHDIR storage which is shared via NFSv4
DATADIR="/storage/brno3-cerit/home/tskalicky/m6a_review/phylogeny/orthofinder/pb"
# clean the SCRATCH when job finishes (and data
# are successfully copied out) or is killed
trap 'clean_scratch' TERM EXIT
cp -avr $DATADIR/"ALKBH5_OG0005435_ren_mafft_gb.phy" $DATADIR/"Fasta2Phylip.pl" $SCRATCHDIR
cd $SCRATCHDIR
#
if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch directory is not created!" 1>&2; exit 1; fi #checks if scratch directory is created
echo "SCRATCHDIR path is:" $SCRATCHDIR
echo "Following files were copied to scratch:"
ls -Rc1
#
echo "Script started on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
./Fasta2Phylip.pl ALKBH5_OG0005435_ren_mafft_gb.fst ALKBH5_OG0005435_ren_mafft_gb.phy
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT1 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT2 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT3 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT4 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT5 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT6 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT7 &
pb -d ALKBH5_OG0005435_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT8
wait
echo "PB Finished starting bpcomp and tracecomp"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
#
bpcomp -v -x 200 1 -o ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT1 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT2 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT3 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT4 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT5 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT6 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT7 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT8
tracecomp -x 200 1 -o ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT1 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT2 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT3 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT4 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT5 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT6 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT7 ALKBH5_OG0005435_ren_mafft_gb_GTR_CAT8
# copy resources from scratch directory back on disk
# field, if not successful, scratch is not deleted
tar -cf PB_m6A_ALKBH5_trees.tar $SCRATCHDIR --remove-files
cp -avr $SCRATCHDIR $DATADIR || export CLEAN_SCRATCH=false
cd $DATADIR
tar -xf PB_m6A_ALKBH5_trees.tar 
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
