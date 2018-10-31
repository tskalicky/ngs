#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l walltime=720:00:00
#PBS -l mem=50gb
#PBS -k oe
#PBS -N PB_m6A_FTO_trees
#PBS -M tomas.skalicky@seznam.cz
#PBS -m abe
#
#PARU KRTECEK server is using TORQUE scheduling system !!!
#
## initialize the required application
#
# Alignment - PE RNA-Seq
# Fasta2Phylip.py and Phylobayes
############################################################################################
# initialize the required application
PROGRAMDIR="/home/users/tskalicky/CEITEC/m6A/phylogeny"
DATADIR="/home/users/tskalicky/CEITEC/m6A/phylogeny/PB"
OUTPUTDIR="/home/users/tskalicky/CEITEC/m6A/phylogeny/PB/FTO"
#
mkdir $OUTPUTDIR
cd $OUTPUTDIR
cp -avr $PROGRAMDIR/"Fasta2Phylip.pl" $PROGRAMDIR/"pb" $PROGRAMDIR/"bpcomp" $PROGRAMDIR/"readpb" $PROGRAMDIR/"tracecomp" $OUTPUTDIR
cp -avr $DATADIR/"FTO_OG0005665_ren_mafft_gb.fst" $OUTPUTDIR
#
echo "Following files were copied to scratch:"
ls -Rc1
#
echo "Script started on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
./Fasta2Phylip.pl FTO_OG0005665_ren_mafft_gb.fst FTO_OG0005665_ren_mafft_gb.phy
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT1 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT2 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT3 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT4 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT5 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT6 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT7 &
./pb -d FTO_OG0005665_ren_mafft_gb.phy -s -cat -gtr -x 1 1000 FTO_OG0005665_ren_mafft_gb_GTR_CAT8
wait
echo "PB Finished starting bpcomp and tracecomp"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
#
./bpcomp -v -x 200 1 -o FTO_OG0005665_ren_mafft_gb_GTR_CAT FTO_OG0005665_ren_mafft_gb_GTR_CAT1 FTO_OG0005665_ren_mafft_gb_GTR_CAT2 FTO_OG0005665_ren_mafft_gb_GTR_CAT3 FTO_OG0005665_ren_mafft_gb_GTR_CAT4 FTO_OG0005665_ren_mafft_gb_GTR_CAT5 FTO_OG0005665_ren_mafft_gb_GTR_CAT6 FTO_OG0005665_ren_mafft_gb_GTR_CAT7 FTO_OG0005665_ren_mafft_gb_GTR_CAT8
./tracecomp -x 200 1 -o FTO_OG0005665_ren_mafft_gb_GTR_CAT FTO_OG0005665_ren_mafft_gb_GTR_CAT1 FTO_OG0005665_ren_mafft_gb_GTR_CAT2 FTO_OG0005665_ren_mafft_gb_GTR_CAT3 FTO_OG0005665_ren_mafft_gb_GTR_CAT4 FTO_OG0005665_ren_mafft_gb_GTR_CAT5 FTO_OG0005665_ren_mafft_gb_GTR_CAT6 FTO_OG0005665_ren_mafft_gb_GTR_CAT7 FTO_OG0005665_ren_mafft_gb_GTR_CAT8
# copy resources from scratch directory back on disk
# field, if not successful, scratch is not deleted
tar -cf PB_m6A_FTO_trees.tar $SCRATCHDIR --remove-files
cp -avr $SCRATCHDIR $DATADIR || export CLEAN_SCRATCH=false
cd $DATADIR
tar -xf PB_m6A_FTO_trees.tar 
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
