#Need Trinity installed and in path

#Some Variables:

TRINITY_ROOT='/data1/utils/trinityrnaseq_r20131110/'
ASSEM_MEMORY=500G #MAKE SURE TO PUT G
ASSEM_THREADS=60
ASSEM_MINKMER=1
SS_LIB_TYPE=RF
JACCARD_CLIP= #FILL IN WITH "--jaccard_clip" if you want to use, blank will skip
##ALSO CAN MODIFY TO ADD BUTTERFLY OPTIONS
mkdir ../6_Assembly
cd ../6_Assembly
ln -s ../5_N*/*normal*fq . 
echo "starting asssembly with parameters:"

ulimit

$TRINITY_ROOT/Trinity.pl --seqType fq --JM $ASSEM_MEMORY --left all.trimmed.R1.*norm*fq --right all.trimmed.R2.*norm*fq --CPU $ASSEM_THREADS $JACCARD_CLIP --min_kmer_cov $ASSEM_MINKMER --bflyCalculateCPU --bflyHeapSpaceInit 4G

ln -s trinity_out_dir/Trinity.fasta . 

if [ ! -f trinity_out_dir/Trinity.fasta ] ; then
   echo "Problem with Assembly!";
   cd ..
   exit
fi
cd ..
echo "Assembly ran successfully!"

echo "Proceeding with transcript decoding"
TransDecoder -t Trinity.fasta
echo "Transcript decoding completed"
