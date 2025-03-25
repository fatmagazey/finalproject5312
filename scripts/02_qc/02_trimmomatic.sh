#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=0-32

hostname
date

#################################################################
# Trimmomatic
#################################################################

module load Trimmomatic/0.39

# set input/output directory variables
INDIR=../../data/fastq/
TRIMDIR=../../results/02_qc/trimmed_fastq
mkdir -p $TRIMDIR

# adapters to trim out
ADAPTERS=/isg/shared/apps/Trimmomatic/0.39/adapters/TruSeq3-PE-2.fa

# sample bash array
SAMPLELIST=(SRR25266111 SRR25266112 SRR25266113 SRR25266114 SRR25266115 \
SRR25266116 SRR25266117 SRR25266118 SRR25266119 SRR25266120 \
SRR25266121 SRR25266122 SRR25266123 SRR25266124 SRR25266125 \
SRR25266126 SRR25266127 SRR25266128 SRR25266129 SRR25266130 \
SRR25266131 SRR25266132 SRR25266133 SRR25266134 SRR25266135 \
SRR25266136 SRR25266137 SRR25266138 SRR25266139 SRR25266140 \
SRR25266141 SRR25266142 SRR25266143)

# run trimmomatic

SAMPLE=${SAMPLELIST[$SLURM_ARRAY_TASK_ID]}

java -jar /isg/shared/apps/Trimmomatic/0.39/trimmomatic-0.39.jar PE -threads 4 \
        ${INDIR}/${SAMPLE}_1.fastq.gz \
        ${INDIR}/${SAMPLE}_2.fastq.gz \
        ${TRIMDIR}/${SAMPLE}_trim.1.fastq.gz ${TRIMDIR}/${SAMPLE}_trim_orphans.1.fastq.gz \
        ${TRIMDIR}/${SAMPLE}_trim.2.fastq.gz ${TRIMDIR}/${SAMPLE}_trim_orphans.2.fastq.gz \
        ILLUMINACLIP:"${ADAPTERS}":2:30:10 \
        SLIDINGWINDOW:4:15 MINLEN:45
