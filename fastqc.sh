# runs fastqc on fastq files in cuttent directory
# first argument is output directory
mkdir $1
fastqc -t 20 -o $1 *fastq
scrape_fastqc.py $1 > $1/summary.txt

