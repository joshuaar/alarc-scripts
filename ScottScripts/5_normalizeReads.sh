TRINITY_ROOT='/data1/utils/trinityrnaseq_r20131110/'
ASSEM_MEMORY=500G #MAKE SURE TO PUT G
ASSEM_THREADS=64
ASSEM_MINKMER=1
SS_LIB_TYPE=
JACCARD_CLIP=  #FILL IN WITH "--jaccard_clip" if you want to use, blank will skip
##ALSO CAN MODIFY TO ADD BUTTERFLY OPTIONS


mkdir ../5_NormalizeReads
cd ../5_NormalizeReads
ln -s ../4_MergeFilterSamplesByExperiment/* . 


ulimit
for x in `ls * | awk -F "." '{print $1}' | sort | uniq`
do 
echo normalizing $x
$TRINITY_ROOT/util/normalize_by_kmer_coverage.pl  --seqType fq --JM $ASSEM_MEMORY --max_cov 50 --left $x.trimmed.R1.fastq --right $x.trimmed.R2.fastq --JELLY_CPU 30 --pairs_together --output $x.normalized_reads
done 


