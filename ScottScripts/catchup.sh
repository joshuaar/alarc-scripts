TRINITY_ROOT='/data0/opt/AssemblySoftware/trinityrnaseq_r20131110/'
ASSEM_MEMORY=200G #MAKE SURE TO PUT G
ASSEM_THREADS=32
ASSEM_MINKMER=1
SS_LIB_TYPE=
JACCARD_CLIP=  #FILL IN WITH "--jaccard_clip" if you want to use, blank will skip
##ALSO CAN MODIFY TO ADD BUTTERFLY OPTIONS


#cat ../2_FilterRawData/*trimmed*R1.fastq > ../4_MergeFilterSamplesByExperiment/all.trimmed.R1.fastq
cat ../2_FilterRawData/*trimmed*R2.fastq > ../4_MergeFilterSamplesByExperiment/all.trimmed.R2.fastq

cd ../5_NormalizeReads
#ln -s ../4_MergeFilterSamplesByExperiment/all* . 


ulimit
for x in all
do 
echo normalizing $x
$TRINITY_ROOT/util/normalize_by_kmer_coverage.pl  --seqType fq --JM $ASSEM_MEMORY --max_cov 50 --left $x.trimmed.R1.fastq --right $x.trimmed.R2.fastq --JELLY_CPU 30 --pairs_together --output $x.normalized_reads
done 


