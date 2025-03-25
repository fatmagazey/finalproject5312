#!/bin/bash
#SBATCH --job-name=sra
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

#################################################################
# Download fastq files from SRA 
#################################################################

# load software
module load parallel/20180122
module load sratoolkit/3.0.1

# The data are from this study, NCBI BioProject: PRJNA994299
# López-Valiñas, Á., Valle, M., Pérez, M., Darji, A., Chiapponi, C., Ganges, L., Segalés, J., & Núñez, J. I. (2023). Genetic diversification patterns in swine influenza A virus (H1N2) in vaccinated and nonvaccinated animals. Frontiers in cellular and infection microbiology, 13, 1258321. https://doi.org/10.3389/fcimb.2023.1258321

OUTDIR=../../data/fastq
    mkdir -p ${OUTDIR}

ACCLIST=../../metadata/SRR_Acc_List.txt

# use parallel to download 5 accessions at a time. 
cat $ACCLIST | parallel -j 5 "fasterq-dump -O ${OUTDIR} {}"

# compress the files 
ls ${OUTDIR}/*fastq | parallel -j 33 gzip
