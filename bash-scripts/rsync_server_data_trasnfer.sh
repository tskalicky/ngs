#!/bin/bash
# To transfer huge files or many files from one server to another with support of reconnection when failed
rsync --progress file1 file2 user@remotemachine:/destination/directory
rsync --progress /storage/brno3-cerit/home/tskalicky/genomes.tar.gz tskalicky@147.231.253.10:/home/users/tskalicky/CEITEC
rsync --progress /home/tomas/Bioinformatics/CEITEC/Dis3L2/Dasa_spikein/uridylation/Dis3L2_uridyl_trimT_NEW.tar.gz tskalicky@zuphux.cerit-sc.cz:/storage/brno3-cerit/home/tskalicky/Dis3L2/Dasa_spikein/uridylation
rsync --progress /home/tomas/Bioinformatics/CEITEC/Dis3L2/Dasa_spikein/uridylation/Dis3L2_uridyl_trimT_UPSCALE.tar.gz tskalicky@zuphux.cerit-sc.cz:/storage/brno3-cerit/home/tskalicky/Dis3L2/Dasa_spikein/uridylation

rsync --progress /mnt/storage-brno3-cerit/nfs4/home/tskalicky/Dis3L2/Dasa_spikein/mapping/Scerevisiae_genome/bbmap/unmapped_reads/*.fq tskalicky@147.231.253.10:/home/users/tskalicky/CEITEC/Dis3L2/Dasa_SpikeIn/mapping/bbmap/unmapped_reads
