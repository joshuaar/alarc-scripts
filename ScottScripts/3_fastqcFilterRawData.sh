mkdir ../3_Fastqc_FilterRawData
cd ../2_FilterRawData/  
fastqc -t 32 -o ../3_Fastqc_FilterRawData *fastq
cd ../Scripts
./scrape_fastqc.py ../3_Fastqc_FilterRawData > ../3_Fastqc_FilterRawData/fastqc.summary.txt

