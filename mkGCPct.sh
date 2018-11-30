#!/bin/bash

# /ifs/depot/assemblies/M.musculus/mm9/mm9.fasta

SDIR="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != "1" ]; then
    echo "usage: mkGCPct.sh GEOME.FASTA"
    exit
fi

GENOME_FASTA=$1
GENOME_BUILD=$(echo $GENOME_FASTA | perl -ne 'm|/([^/]*?).fa|; print $1')

echo GENOME_FASTA=$GENOME_FASTA
echo GENOME_BUILD=$GENOME_BUILD

if [ ! -e "genomes/${GENOME_BUILD}.genome" ]; then
    mkdir -p genomes
    cat ${GENOME_FASTA}.fai | cut -f1,2 | fgrep -v _ | fgrep -vi decoy >genomes/${GENOME_BUILD}.genome
    echo "Building bedtools genome file [${GENOME_BUILD}.genome]"
fi

$SDIR/mkNucFile.sh genomes/${GENOME_BUILD}.genome $GENOME_FASTA

Rscript --no-save mkRDA.R ${GENOME_BUILD}_1000by100_TileBin.nuc.gz

