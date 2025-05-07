#!/bin/bash 
#SBATCH --job-name=align_pipe
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=30G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[0-32]

hostname
date

# load required software
module load samtools/1.16.1
module load samblaster/0.1.24
module load bwa-mem2/2.1

#set directories
SAMPDIR=../../results/02_qc/trimmed_fastq

OUTDIR=../../results/03_Alignment/bwa_align
mkdir -p $OUTDIR

INDEX=../../results/03_Alignment/bwa_index/AI

# sample ID list
SAMPLELIST=(SRR25266111 SRR25266112 SRR25266113 SRR25266114 SRR25266115 SRR25266116 SRR25266117 SRR25266118 SRR25266119 SRR25266120
SRR25266121 SRR25266122 SRR25266123 SRR25266124 SRR25266125 SRR25266126 SRR25266127 SRR25266128 SRR25266129 SRR25266130 
SRR25266131 SRR25266132 SRR25266133 SRR25266134 SRR25266135 SRR25266136 SRR25266137 SRR25266138 SRR25266139 SRR25266140 SRR25266141 SRR25266142 SRR25266143)

# extract one sample ID
SAMPLE=${SAMPLELIST[$SLURM_ARRAY_TASK_ID]}

# create read group string
RG=$(echo \@RG\\tID:$SAMPLE\\tSM:$SAMPLE)

# execute the alignment pipe:
bwa-mem2 mem -t 8 -R ${RG} ${INDEX} ${SAMPDIR}/${SAMPLE}_trim.1.fastq.gz $SAMPDIR/${SAMPLE}_trim.2.fastq.gz | \
	samblaster | \
	samtools view -S -h -u - | \
	samtools sort -T ${OUTDIR}/${SAMPLE}.temp -O BAM >$OUTDIR/${SAMPLE}.bam 

# index alignment file
samtools index ${OUTDIR}/${SAMPLE}.bam
