#!/bin/bash
#PBS -l select=1:ncpus=20:mem=50gb:scratch_local=50gb
#PBS -l walltime=96:00:00
#PBS -q uv@wagap-pro.cerit-sc.cz
#PBS -j oe
#PBS -N raxml_m6A_METTL16_quick
# initialize the required application
# add modules
module add raxml-8.2.8
module add blast+-2.6.0
# get name of machine where job is run
DATADIR="/storage/brno3-cerit/home/tskalicky/m6a_review/raxml"

cd $DATADIR
raxmlHPC-PTHREADS -f a -x 12345 -p 987654 -N 200 -d -m PROTGAMMALG -T 20 -s METTL16_OG0004168_ren_mafft_gb.fst -n METTL16_OG0004168_quick
#raxmlHPC-PTHREADS -f d -p 987654 -N 200 -m PROTGAMMALG -T 20 -s 98clustrers_aln-gb2.phy -n Multiprotein_orthofinder_extensive
#raxmlHPC-PTHREADS -b 12345 -p 987654 -N 1000 -m PROTGAMMALG -T 20 -s 98clustrers_aln-gb2.phy -n Multiprotein_orthofinder_extensive.boot
#raxmlHPC-PTHREADS -f b -m PROTGAMMALGF -T 20 -z RAxML_bootstrap.Multiprotein_orthofinder_extensive.boot -t RAxML_bestTree.Multiprotein_orthofinder_extensive -n Multiprotein_orthofinder_extensive.fin
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
