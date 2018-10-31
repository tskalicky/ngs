#!/bin/bash
#PBS -l nodes=1:ppn=30
#PBS -l walltime=168:00:00
#PBS -l mem=50gb
#PBS -k oe
#PBS -N raxml_ALKBH5
#PBS -M tomas.skalicky@seznam.cz
#PBS -m abe
#
#PARU KRTECEK server is using TORQUE scheduling system !!!
#
## initialize the required application
export PATH="$PATH:/home/users/tskalicky/anaconda2/bin"
echo "PATH is:"
echo "$PATH"
#
raxml=$(which raxmlHPC-PTHREADS-AVX2)
which $raxml
# Set number of CPU
THREADS=$PBS_NUM_PPN
#
DATADIR="/home/users/tskalicky/CEITEC/m6A/phylogeny/raxml"
WORKDIR="/home/users/tskalicky/CEITEC/m6A/phylogeny/raxml/ALKBH5"
mkdir -p $WORKDIR
cp -av $DATADIR/"ALKBH5_OG0005435_ren_mafft_gb.fst" $WORKDIR
cd $WORKDIR
#raxmlHPC-PTHREADS-AVX2 -f a -x 12345 -p 987654 -N 200 -d -m PROTGAMMALG -T $THREADS -s ALKBH5_OG0005435_ren_mafft_gb.fst -n ALKBH5_OG0005435_quick
raxmlHPC-PTHREADS-AVX2 -f d -p 987654 -N 200 -m PROTGAMMALG -T $THREADS -s ALKBH5_OG0005435_ren_mafft_gb.fst -n ALKBH5_OG0005435_ren_mafft_gb
raxmlHPC-PTHREADS-AVX2 -b 12345 -p 987654 -N 1000 -m PROTGAMMALG -T $THREADS -s ALKBH5_OG0005435_ren_mafft_gb.fst -n ALKBH5_OG0005435_ren_mafft_gb.boot
raxmlHPC-PTHREADS-AVX2 -f b -m PROTGAMMALG -T $THREADS -z RAxML_bootstrap.ALKBH5_OG0005435_ren_mafft_gb.boot -t RAxML_bestTree.ALKBH5_OG0005435_ren_mafft_gb -n ALKBH5_OG0005435_ren_mafft_gb.fin
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
