#!/bin/bash

wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/seqc/Somatic_Mutation_WG/release/latest/high-confidence_sSNV_in_HC_regions_v1.2.vcf.gz -P  ../benchmark/
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/seqc/Somatic_Mutation_WG/release/latest/high-confidence_sINDEL_in_HC_regions_v1.2.vcf.gz -P  ../benchmark/
tabix ../benchmark/high-confidence_sSNV_in_HC_regions_v1.2.vcf.gz
tabix ../benchmark/high-confidence_sINDEL_in_HC_regions_v1.2.vcf.gz
bcftools concat -a ../benchmark/high-confidence_sSNV_in_HC_regions_v1.2.vcf.gz ../benchmark/high-confidence_sINDEL_in_HC_regions_v1.2.vcf.gz -Oz -o ../benchmark/high-confidence_sSNV_sINDEL_in_HC_regions_v1.2.vcf.gz
tabix ../benchmark/high-confidence_sSNV_sINDEL_in_HC_regions_v1.2.vcf.gz
