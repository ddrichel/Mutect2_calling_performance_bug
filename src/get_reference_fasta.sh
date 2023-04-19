#/bin/bash


mkdir -p ../ref

wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_33/GRCh38.primary_assembly.genome.fa.gz -P ../ref/
gunzip ../ref/GRCh38.primary_assembly.genome.fa
samtools faidx ../ref/GRCh38.primary_assembly.genome.fa
