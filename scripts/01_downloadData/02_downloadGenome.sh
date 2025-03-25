#!/bin/bash 
#SBATCH --job-name=download_genome
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date


OUTDIR=../../genome
mkdir -p $OUTDIR
cd $OUTDIR

# this paper used only one segement of the genome (4) rather than the full genome 
    #  https://www.ncbi.nlm.nih.gov/nuccore/HF674912
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/HF/674/912/HF674912.fna.gz
gunzip *gz
