# Extracts fastq.gz files by sample
# Useful for concatinating and decompressing fastq.gz files
# Argument $1 is an expression corresponding to single sample and direction
# Example: 27A*R1*.fastq.gz
# The concatinated file is moved to an output directory of choice
# Example: extract.sh 27A*R1*fastq.gz
outdir=extracted
mkdir $outdir
for i in "$@"
do
	echo "expression $i matches:"
	echo $i
	outname=$(sed 's/\*/./g' <<< $i)
	outname=$(sed 's/.gz//g' <<< $outname)
	echo "decompressing to:"
	echo $outdir/$outname
	zcat $i > $outdir/$outname
done
#zcat $1 
