mkdir ../1_Fastqc_RawData
cd ../RawData/  
fastqc -t 20 -o ../1_Fastqc_RawData *fastq
cd ../Scripts
./scrape_fastqc.py ../1_Fastqc_RawData > ../1_Fastqc_RawData/fastqc.summary.txt

