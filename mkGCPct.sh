#!/bin/bash

# /ifs/depot/assemblies/M.musculus/mm9/mm9.fasta
GENOME_FASTA=$1
GENOME_BUILD=$(echo $GENOME_FASTA | perl -ne 'm|/([^/]*?).fa|; print $1')

echo GENOME_FASTA=$GENOME_FASTA
echo GENOME_BUILD=$GENOME_BUILD

if [ ! -e "genomes/${GENOME_BUILD}.genome" ]; then
    cat ${GENOME_FASTA}.fai | cut -f1,2 | fgrep -v _ | fgrep -vi decoy >genomes/${GENOME_BUILD}.genome
    echo "Building bedtools genome file [${GENOME_BUILD}.genome]"
fi

bsub -o LSF/ -J MKNUC_$$ -R "rusage[mem=60]" -n 3 \
    ./mkNucFile.sh genomes/${GENOME_BUILD}.genome $GENOME_FASTA

bsub -o LSF/ -J MKRDA_$$ -We 59 -R "rusage[mem=60]" -w "post_done(MKNUC_$$)" -n 3 \
    Rscript --no-save mkRDA.R ${GENOME_BUILD}_1000by100_TileBin.nuc.gz

