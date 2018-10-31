#!/bin/bash
#PBS -l nodes=1:ppn=30
#PBS -l walltime=168:00:00
#PBS -l mem=50gb
#PBS -k oe
#PBS -N raxml_FTO
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
WORKDIR="/home/users/tskalicky/CEITEC/m6A/phylogeny/raxml/FTO"
mkdir -p $WORKDIR
cp -av $DATADIR/"FTO_OG0005665_ren_mafft_gb.fst" $WORKDIR
cp -av /home/users/tskalicky/CEITEC/m6A/phylogeny/raxmlHPC-PTHREADS-AVX2 $WORKDIR
cd $WORKDIR
#raxmlHPC-PTHREADS-AVX2 -f a -x 12345 -p 987654 -N 200 -d -m PROTGAMMALG -T $THREADS -s FTO_OG0005665_ren_mafft_gb.fst -n ALKBH5_OG0005435_quick
./raxmlHPC-PTHREADS-AVX2 -f d -p 987654 -N 200 -m PROTGAMMALG -T $THREADS -s FTO_OG0005665_ren_mafft_gb.fst -n FTO_OG0005665_ren_mafft_gb_extensive
./raxmlHPC-PTHREADS-AVX2 -b 12345 -p 987654 -N 1000 -m PROTGAMMALG -T $THREADS -s FTO_OG0005665_ren_mafft_gb.fst -n FTO_OG0005665_ren_mafft_gb_extensive.boot
./raxmlHPC-PTHREADS-AVX2 -f b -m PROTGAMMALG -T $THREADS -z RAxML_bootstrap.FTO_OG0005665_ren_mafft_gb_extensive.boot -t RAxML_bestTree.FTO_OG0005665_ren_mafft_gb_extensive -n FTO_OG0005665_ren_mafft_gb_extensive.fin
echo "Script finished on:"
date +"%d/%m/%Y %H:%M:%S $HOSTNAME"
