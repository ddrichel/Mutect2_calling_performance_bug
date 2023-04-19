#!/bin/bash

set -eox

function run_som_py (){
    outvcf=$(basename $query)
    outvcf=$sc/${outvcf%.vcf.gz}_no_homref.vcf.gz
    bcftools view -e 'GT[*]="RR"' $query -Oz -o $outvcf
    tabix $outvcf
    outprefix=${outprefix}_som_py
    ../hap_py_install/bin/som.py $truth $outvcf -r $genome -R $wesbed  -o ../callsets_performance/$outprefix 
}


function get_tumor_from_multisample_query (){
    outvcf=$(basename $vcf)
    bcftools query -f "%CHROM %POS %REF %ALT [%GT ]\n" $vcf | awk 'OFS="\t"{if($5==$6)print $1,$2,$3,$4;}' > $sc/variants2remove.txt
    outvcf0=$sc/${outvcf%.vcf.gz}_tumor_raw.vcf.gz
    outvcf1=$sc/${outvcf%.vcf.gz}_tumor.vcf.gz
    bcftools view -s $sample $vcf -Oz -o $outvcf0
    tabix -f $outvcf0
    if [ -s  $sc/variants2remove.txt ];
       then
	   awk 'NR==FNR{a[$1"_"$2"_"$3"_"$4]=1; next;}{if(substr($0,1,1)=="#"){print $0;} else if(a[$1"_"$2"_"$4"_"$5]!=1) {print $0;}}'  $sc/variants2remove.txt <(gunzip -c $outvcf0) > ${outvcf1%.gz} 
	   bgzip -f ${outvcf1%.gz}
	   tabix -f $outvcf1
	 else
	     cp $outvcf0  $outvcf1
	     cp ${outvcf0}.tbi  ${outvcf1}.tbi
       fi
    rm $sc/variants2remove.txt
    query=$outvcf1
}



genome=../ref/GRCh38.primary_assembly.genome.fa
wesbed=../intervals/S07604624_Covered_human_all_v6_plus_UTR.liftover.to.hg38_merged_allowed_contigs_intersect_HighConfidence.bed
truth=../benchmark/high-confidence_sSNV_sINDEL_in_HC_regions_v1.2.vcf.gz
sample=WES_FD_T
### scratch directory
sc=../tmp
mkdir -p $sc


for i in 4181 4190 
do
	 query=../vcfs/WES_FD_TN_${i}_filtered.vcf.gz
	 vcf=$query
	 sample=WES_FD_T
	 ## the tumor sample is extracted from the tumor-normal calls, homozygous reference calls are removed from the tumor sample, as they are likely to be false positives
	 get_tumor_from_multisample_query
	 outprefix=WES_FD_TN_${i}_filter
	 run_som_py
done
